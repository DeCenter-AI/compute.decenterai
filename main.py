import os
from typing import Final, List

import fire

from helpers import *

python_repl = sys.executable

JUPYTER_NOTEBOOK: Final[str] = '.ipynb'
PYTHON: Final[str] = '.py'

EXECUTION_FRAMEWORK: str


def train(train_script: str, requirements_txt: str = None, data_dir='/data'):
    if requirements_txt:
        # TODO: implement logic for python
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
        case _:
            logging.critical('invalid training script')

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


if __name__ == "__main__":
    fire.Fire(train)
