import datetime
import os.path
import tempfile
import zipfile
from typing import Final, List

import fire
from dotenv import load_dotenv

from helpers import *
from web3 import lighthouse
from web3.cid import is_cid

python_repl = sys.executable
DATA_DIR = os.getenv("DATA_DIR", "/data")

JUPYTER_NOTEBOOK: Final[str] = ".ipynb"
PYTHON: Final[str] = ".py"

output_dir: Final[str] = os.getenv("OUTPUT_DIR", "./outputs")
OUTPUT_ARCHIVE: Final[str] = os.getenv("OUTPUT_ARCHIVE", "")

EXECUTION_FRAMEWORK: str


def path_not_found(path: str):
    if not os.path.exists(path):
        logging.warning(f"{path} not found")
        return True

    return False


def train(train_script: str, requirements_txt: str = None, data_dir=DATA_DIR):
    logging.info("starting train")

    data_dir = os.path.abspath(data_dir)  # jupyter nb convert needs abspath

    if path_not_found(data_dir):
        sys.exit(1)

    if requirements_txt:
        logging.info("Installing dependencies in progress")
        requirements_path = os.path.join(
            data_dir,
            requirements_txt,
        )
        if path_not_found(requirements_path):
            logging.critical(
                f"requirements path- {requirements_path} not found",
            )
        else:
            install_dependencies(
                python_repl,
                requirements_path,
            )

    train_script = os.path.join(data_dir, train_script)
    if path_not_found(train_script):
        logging.critical(f"train script path- {train_script} not found")
        sys.exit(1)

    training_cmd: List[str]
    script_ext = os.path.splitext(train_script)[1]
    match script_ext:
        case ".py":
            EXECUTION_FRAMEWORK = PYTHON
            training_cmd = [python_repl, train_script]
        case ".ipynb":
            EXECUTION_FRAMEWORK = JUPYTER_NOTEBOOK
            cmd_string = f"jupyter nbconvert --execute --to html --output {train_script} {train_script}"
            training_cmd = cmd_string.split(" ")
            training_cmd = [python_repl, "-m"] + training_cmd

        case _:
            logging.critical("invalid training script")
            sys.exit(1)

    logging.info(f"train cmd - {training_cmd}")

    result = subprocess.run(
        training_cmd,
        cwd=data_dir,
        capture_output=True,
        encoding="UTF-8",
    )

    logging.info(result.stdout)
    logging.error(result.stderr)

    with open(os.path.join(data_dir, "stdout"), "w") as f1, open(
        os.path.join(data_dir, "stderr"),
        "w",
    ) as f2:
        f1.write(result.stdout)
        f2.write(result.stderr)
        # TODO: pass files directly to subprocess...

    return True


def train_v2(
    train_script: str,
    input_archive: str,
    requirements_txt: str = None,
):
    logging.info(f"start {datetime.datetime.utcnow()}")

    data_dir = DATA_DIR
    if not os.path.exists(data_dir):
        logging.warning(f"data dir {data_dir} doesnt exists")

        logging.info("creating temp directory for data dir")

        temp_dir = tempfile.TemporaryDirectory(
            prefix="decenter-ai-",
            suffix="-training-working-dir",
        )
        data_dir = temp_dir.name

    print("data_dir is ", data_dir)

    if is_cid(input_archive):
        new_archive = os.path.join(data_dir, f"{input_archive}.zip")
        f2 = lighthouse.download(input_archive, new_archive)
        input_archive = os.path.join(data_dir, f2.name)
        os.rename(new_archive, input_archive)

    with zipfile.ZipFile(input_archive, "r") as zip_ref:
        zip_ref.extractall(data_dir)

    extracted_files = os.listdir(data_dir)
    print("extracted:", extracted_files)
    data_dir_contents = os.listdir(data_dir)
    print("data_dir contains", data_dir_contents)

    result = train(train_script, requirements_txt, data_dir)

    output_archive = os.path.basename(input_archive)
    output_archive = os.path.splitext(output_archive)[0]

    if "decenter" not in output_archive:
        output_archive = "decenter-ai-" + output_archive

    if OUTPUT_ARCHIVE:
        print("output archive is already specified in env: ", OUTPUT_ARCHIVE)
        output_archive = OUTPUT_ARCHIVE

    if result:
        zipfile_ = archive_directory(
            os.path.join(output_dir, output_archive),
            data_dir,
        )
        print("archived working directory to", zipfile_)

        if isinstance(data_dir, tempfile.TemporaryDirectory):
            print("cleaning up the data dirctory")
            data_dir.cleanup()

    # temp_dir.cleanup()
    # logging.debug("cleanup the temp dir")
    logging.info(f"end {datetime.datetime.utcnow()}")


if __name__ == "__main__":
    load_dotenv()

    logging.basicConfig(level=logging.INFO)

    # fire.Fire(train, "train", "Train")
    # fire.Fire(train_v2, "train_v2", "Train v2")
    fire.Fire({"train": train, "train_v2": train_v2})
