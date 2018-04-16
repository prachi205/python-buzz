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
		    echo $PATH
                    [ -d venv ] && rm -rf venv
                    conda create -p ${VIRTUAL_ENV}
		    source activate ${VIRTUAL_ENV}
                    pip install --upgrade pip
                    pip install -r requirements.txt
                    make clean
                """
            }
        }

        stage ('Check_style') {
            steps {
                sh """
                    [ -d report ] || mkdir report
                    export PATH=${VIRTUAL_ENV}/bin:${PATH}
                """
                sh """
                    export PATH=${VIRTUAL_ENV}/bin:${PATH}
                    make pep8 | tee pep8.log || true
                """
                sh """
                    export PATH=${VIRTUAL_ENV}/bin:${PATH}
                    make pylint | tee pylint.log || true
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