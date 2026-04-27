"""Sample test for AES project."""

import pytest

from aes_project import main


def test_main_output(capsys):
    """Test that main() prints expected output."""
    main()
    captured = capsys.readouterr()
    assert "Hello from AES project!" in captured.out


def test_version():
    """Test version is defined."""
    import aes_project
    assert hasattr(aes_project, '__version__')
    assert aes_project.__version__ == "0.1.0"
