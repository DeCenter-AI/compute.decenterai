import fire
import subprocess
import logging
import logging as log
import os
import sys
import icecream as ic
import concurrent
from helpers import *

requirements = None

temp_dir_path = os.getcwd()
python_repl = sys.executable
driver_script = ''


if requirements:
    logging.info("Installing dependencies in progress")
    requirements_path = os.path.join(
        temp_dir_path,
        requirements,
    )
    install_dependencies(
        python_repl,
        requirements_path,
        cwd=temp_dir_path,
    )

training_cmd = get_python_cmd(
    driver_script,
    python_interpreter=python_repl,
)


result = subprocess.run(
            training_cmd,
            cwd=temp_dir_path,
            capture_output=True,
            encoding="UTF-8",
        )

logging.info(result.stdout)  # TODO: logs trace
logging.info(result.stderr)






if __name__ == "__main__":
    print("start")
