#!/usr/bin/env groovy

pipeline {
    agent any
    options {
        buildDiscarder(
            logRotator(numToKeepStr:'10'))
    }
    environment {
        VIRTUAL_ENV = "${env.WORKSPACE}/venv"
    }

    stages {
        stage ('Checkout') {
            steps {
                checkout scm
            }
        }

        stage ('Install_Requirements') {
            steps {
                sh """#!/bin/bash -ex
                    export PATH=/home/psoni/anaconda3/bin:$PATH
                    [ -d venv ] && rm -rf venv
                    conda create -p ${VIRTUAL_ENV}
		    source activate ${VIRTUAL_ENV}
                    pip install -r requirements.txt
                    make clean
                """
            }
        }

        stage ('Check_style') {
            steps {
                sh """#!/bin/bash -ex
                    find . -iname "*.py" | xargs pep8 | tee pep8.log
                """
                sh """#!/bin/bash -ex
                    find . -iname "*.py" | xargs pylint | tee pylint.log
                """
                step([$class: 'WarningsPublisher',
                  parserConfigurations: [[
                    parserName: 'Pep8',
                    pattern: 'pep8.log'
                  ],
                  [
                    parserName: 'pylint',
                    pattern: 'pylint.log'
                  ]],
                  unstableTotalAll: '0',
                  usePreviousBuildAsReference: true
                ])
            }
        }

    }

}
