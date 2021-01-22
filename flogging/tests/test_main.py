import pytest


def test_main():
    from flogging.flogging import setup as setup_logging

    setup_logging(level="info", structured=False)
