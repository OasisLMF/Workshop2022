import io
import os
import re
import setuptools


SCRIPT_DIR = os.path.abspath(os.path.dirname(__file__))


def get_readme():
    with io.open(os.path.join(SCRIPT_DIR, 'README.md'), encoding='utf-8') as readme:
        return readme.read()


def get_version():
    """
    Return package version as listed in `__version__` in `init.py`.
    """
    with io.open(os.path.join(SCRIPT_DIR, 'src', '__init__.py'), encoding='utf-8') as init_py:
        return re.search('__version__ = [\'"]([^\'"]+)[\'"]', init_py.read()).group(1)


version = get_version()

setuptools.setup(
    name="oasis_workshop",
    version=version,
    include_package_data=True,
    package_data={},
    entry_points={},
    author='Oasis LMF',
    author_email="support@oasislmf.org",
    packages=['oasis_workshop'],
    package_dir={'oasis_workshop': 'src'},
    python_requires='>=3.7',
    install_requires=['requests', 'requests-toolbelt', 'tqdm', 'tabulate', 'pandas', 'altair'],
    description='Helper functions for oasis-workshop',
    long_description=get_readme(),
    long_description_content_type='text/markdown',
    url='https://github.com/OasisLMF/Workshop2022',
)
