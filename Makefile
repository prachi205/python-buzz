#!/usr/bin/make

########################################################
# Makefile for $(NAME)
#
# useful targets:
#	make check -- manifest checks
#	make clean -- clean distutils
#	make coverage_report -- code coverage report
#	make flake8 -- flake8 checks
#	make pylint -- source code checks
#	make rpm -- build RPM package
#	make sdist -- build python source distribution
#	make systest -- runs the system tests
#	make tests -- run all of the tests
#	make unittest -- runs the unit tests
#
# Notes:
# 1) flake8 is a wrapper around pep8, pyflakes, and McCabe.
########################################################
# variable section

NAME = "python_jenkinsfile_testing"

PYTHON=python

########################################################

all: clean check flake8 pylint tests

pep8:
	pep8 ./buzz/generator.py

pylint:
	find . -iname "*.py" | xargs pylint

clean:
	@echo "Cleaning up stuff"
	rm -rf MANIFEST
	@echo "Cleaning up byte compiled python stuff"
	@echo "Cleaning up test reports"
	rm -rf test-reports/*
