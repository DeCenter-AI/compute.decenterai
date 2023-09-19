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

def install_deps(python_repl=sys.executable, requirements: list = None, cwd=None):
    if not requirements:
        return

    print('install_deps', requirements)

    def install(package):
        subprocess.check_call(
            [python_repl, '-m', 'pip', 'install', package],
            # stdout=st.info,
            # stderr=st.error,
            universal_newlines=True,
        )

    # Use a ThreadPoolExecutor to install the packages in parallel
    with concurrent.futures.ThreadPoolExecutor() as executor:
        executor.map(install, requirements)

def install_dependencies(
    python_repl=sys.executable, requirements_path=None, requirements=None, cwd=None,
):
    if requirements:
        logging.info('install_dependencies:')
        install_deps(python_repl, requirements, cwd)

    if not requirements_path:
        logging.warning('install_dependencies:requirements_path not found')
        return

    print('installing dependencies:  for ', python_repl)
    command = [python_repl, '-m', 'pip', 'install', '-r', requirements_path]
    result = subprocess.run(
        command,
        cwd=cwd,
        capture_output=True,
        encoding='UTF-8',
    )

    logging.info(result.stdout)
    logging.error(result.stderr)


    return result

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
