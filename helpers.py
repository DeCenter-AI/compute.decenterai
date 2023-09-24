import concurrent
import logging
import os
import shutil
import subprocess
import sys

from icecream import ic


def get_notebook_cmd(starter_script: str, python_repl=sys.executable):
    # It will save executed notebook to your-notebook.nbconvert.ipynb file. You can specify the custom output name and custom output director
    cmd_string = 'jupyter nbconvert --execute --to notebook --output custom-name --output-dir /custom/path/ your-notebook.ipynb'

    cmd_string = (
        'jupyter nbconvert --execute --to notebook --allow-errors your-notebook.ipynb'
    )
    #  You can execute the notebook and save output into PDF or HTML format. Additionally, you can hide code in the final notebook. The example command that will execute notebook and save it as HTML file with code hidden.
    cmd_string = f'jupyter nbconvert --execute --to html --no-input {starter_script}'
    cmd_string = f'jupyter nbconvert --execute --to html --output {starter_script} {starter_script}'

    # cmd_string = f'jupyter nbconvert --execute --to notebook {starter_notebook}'
    command = cmd_string.split(' ')

    if python_repl is not None:
        command = [python_repl, '-m'] + command

    return command


def get_python_cmd(starter_script, python_interpreter=sys.executable):
    command = [python_interpreter, starter_script]
    return command


def install_deps(python_repl=sys.executable, requirements: list = None):
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
        python_repl=sys.executable, requirements_path=None, requirements=None,
):
    if requirements:
        logging.info('install_dependencies:')
        install_deps(python_repl, requirements)

    if not requirements_path:
        logging.warning('install_dependencies:requirements_path not found')
        return

    print('installing dependencies:  for ', python_repl)
    command = [python_repl, '-m', 'pip', 'install', '-r', requirements_path]
    result = subprocess.run(
        command,
        capture_output=True,
        encoding='UTF-8',
    )

    logging.info(result.stdout)
    logging.error(result.stderr)

    return result


def archive_directory(
        archive_path_name: str, src_dir: str, base_dir: str = None, format='zip',
) -> str:
    # with tempfile.TemporaryDirectory() as temp_dir:
    #     subprocess.run(command, cwd=temp_dir)
    print('zipping', os.listdir(src_dir))

    created_archive_loc = shutil.make_archive(
        archive_path_name,
        format,
        src_dir,
        base_dir,
        True,
        logger=logging.getLogger(),
    )

    ic(created_archive_loc)

    return created_archive_loc
