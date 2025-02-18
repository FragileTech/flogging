import pytest


@pytest.mark.parametrize("structured", [True, False])
def test_main(structured):
    from flogging.flogging import setup as setup_logging

    setup_logging(level="info", structured=structured)
