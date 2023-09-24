import datetime
import os.path
import tempfile
import zipfile
from typing import Final, List

import fire

from helpers import *

python_repl = sys.executable
DATA_DIR = os.getenv('DATA_DIR', '/data')

JUPYTER_NOTEBOOK: Final[str] = '.ipynb'
PYTHON: Final[str] = '.py'

EXECUTION_FRAMEWORK: str


def train(train_script: str, requirements_txt: str = None, data_dir=DATA_DIR):
    logging.info("starting train")

    if not os.path.exists(data_dir):
        logging.warning(f'data dir {data_dir} not found')
        sys.exit(1)

    if requirements_txt:
        logging.info("Installing dependencies in progress")
        requirements_path = os.path.join(
            data_dir,
            requirements_txt,
        )
        install_dependencies(
            python_repl,
            requirements_path,
        )

    training_cmd: List[str]
    script_ext = os.path.splitext(train_script)[1]
    match script_ext:
        case ".py":
            EXECUTION_FRAMEWORK = PYTHON
            training_cmd = [python_repl, train_script]
        case ".ipynb":
            EXECUTION_FRAMEWORK = JUPYTER_NOTEBOOK
            cmd_string = f'jupyter nbconvert --execute --to html --output {train_script} {train_script}'
            training_cmd = cmd_string.split(' ')
            training_cmd = [python_repl, '-m']+training_cmd

        case _:
            logging.critical('invalid training script')
            sys.exit(1)

    result = subprocess.run(
        training_cmd,
        cwd=data_dir,
        capture_output=True,
        encoding="UTF-8",
    )

    logging.info(result.stdout)
    logging.error(result.stderr)

    with open(os.path.join(data_dir, 'stdout'), 'w') as f1, open(os.path.join(data_dir, 'stderr'), 'w') as f2:
        f1.write(result.stdout)
        f2.write(result.stderr)
        # TODO: pass files directly to subprocess...

    return True


def train_v2(train_script: str, input_archive='decenter-model.zip', requirements_txt: str = None):
    logging.info(f"start {datetime.datetime.utcnow()}")

    data_dir = DATA_DIR
    if not os.path.exists(data_dir):
        logging.warning(f'data dir {data_dir} doesnt exists')

        logging.info('creating temp directory for data dir')

        temp_dir = tempfile.TemporaryDirectory(prefix="decenter-ai-",
                                               suffix="-training-working-dir", )
        data_dir = temp_dir.name

    print("data_dir is ", data_dir)

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

    if result:
        zipfile_ = archive_directory(
            os.path.join(os.getcwd(), 'outputs', output_archive),
            data_dir,
        )
        print("archived working directory", zipfile_)

    # temp_dir.cleanup()
    # logging.debug("cleanup the temp dir")
    logging.info(f"end {datetime.datetime.utcnow()}")


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)

    # fire.Fire(train, 'train', 'Train')
    # fire.Fire(train_v2, 'train_v2', 'Train v2')
    fire.Fire({
        'train': train,
        'train_v2': train_v2
    })
