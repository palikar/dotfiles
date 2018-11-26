#!/usr/bin/env python3

import sys
import setuptools
from distutils.core import setup



def package_files(directory):
    paths = []
    for (path, directories, filenames) in os.walk(directory):
        for filename in filenames:
            paths.append(os.path.join('..', path, filename))
    return paths


if sys.version_info < (3, 3):
    print("THIS MODULE REQUIRES PYTHON 3.3+. YOU ARE CURRENTLY\
    USING PYTHON {0}".format(sys.version))
    sys.exit(1)


exec(open('{{project_name}}/version.py').read())

setup(
    name="{{project_name}}",
    version=__version__,
    include_package_data=True,
    author="{{author_name}}",
    author_email="{{author_email}}",
    description="{{description}}",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    packages=setuptools.find_packages(),
    license="GNU General Public License v3.0",
    keywords="{{keywords}}",
    url="https://github.com/palikar/{{project_name}}",
    setup_requires=["pytest-runner"],
    tests_require=["pytest"],
    # entry_points={
    #     'console_scripts': [
    #         '{{project_name}} = {{project_name}}.'
    #     ]
    # },
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "Natural Language :: English",
        "License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
        "Operating System :: POSIX :: Linux",
        "Programming Language :: Python :: 3.3",
        "Programming Language :: Python :: 3.4",
        "Programming Language :: Python :: 3.5",
        "Programming Language :: Python :: 3.6",
        "Topic :: Software Development :: Libraries :: Python Modules",
    ],
)
