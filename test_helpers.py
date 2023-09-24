import pytest
import os
import shutil
from helpers import (
    get_notebook_cmd,
    get_python_cmd,
    install_dependencies,
    archive_directory,
)

# Define test data or fixtures if needed


@pytest.fixture
def test_data_dir(tmpdir):
    # Create a temporary directory for testing
    test_dir = tmpdir.mkdir("test_data")
    yield str(test_dir)

# Test get_notebook_cmd function


def test_get_notebook_cmd():
    cmd = get_notebook_cmd("starter_script.ipynb", "python3")
    assert cmd == ["python3", "-m", "jupyter", "nbconvert", "--execute",
                   "--to", "notebook", "--allow-errors", "starter_script.ipynb"]

# Test get_python_cmd function


def test_get_python_cmd():
    cmd = get_python_cmd("starter_script.py", "python3")
    assert cmd == ["python3", "starter_script.py"]

# Test install_dependencies function


def test_install_dependencies():
    # Provide a requirements.txt file for testing
    requirements_path = "path/to/requirements.txt"
    result = install_dependencies("python3", requirements_path)
    assert result.returncode == 0  # Check that the installation was successful

# Test archive_directory function


def test_archive_directory(test_data_dir):
    # Create a temporary directory with some test files
    test_files_dir = os.path.join(test_data_dir, "test_files")
    os.makedirs(test_files_dir)
    with open(os.path.join(test_files_dir, "file1.txt"), "w") as f:
        f.write("Test file 1 content")
    with open(os.path.join(test_files_dir, "file2.txt"), "w") as f:
        f.write("Test file 2 content")

    # Archive the directory
    archive_path = os.path.join(test_data_dir, "test_archive")
    created_archive = archive_directory(
        archive_path, test_files_dir, test_data_dir)

    # Check that the archive file was created
    assert os.path.exists(created_archive)

# Add more test cases as needed


if __name__ == "__main__":
    pytest.main()
