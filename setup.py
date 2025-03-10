from importlib.machinery import SourceFileLoader
from pathlib import Path

from setuptools import find_packages, setup


version = SourceFileLoader(
    "flogging.version",
    str(Path(__file__).parent / "flogging" / "version.py"),
).load_module()

with open(Path(__file__).with_name("README.md"), encoding="utf-8") as f:
    long_description = f.read()

setup(
    name="flogging",
    description="flogging nice logging formatting and structured logging.",
    long_description=long_description,
    long_description_content_type="text/markdown",
    packages=find_packages(),
    version=version.__version__,
    license="MIT",
    author="fragiletech",
    author_email="gmarkhor@gmail.com",
    url="",
    keywords=["logging"],
    tests_require=["pytest>=5.3.5", "hypothesis>=5.6.0"],
    extras_require={},
    install_requires=["xxhash"],
    package_data={"": ["README.md"]},
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3.10",
        "Topic :: Software Development :: Libraries",
    ],
)
