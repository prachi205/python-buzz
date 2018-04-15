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
                sh """
                    [ -d venv ] && rm -rf venv
                    virtualenv venv
                    export PATH=${VIRTUAL_ENV}/bin:${PATH}
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
                    make check || true
                """
                sh """
                    export PATH=${VIRTUAL_ENV}/bin:${PATH}
                    make flake8 | tee report/flake8.log || true
                """
                sh """
                    export PATH=${VIRTUAL_ENV}/bin:${PATH}
                    make pylint | tee report/pylint.log || true
                """
                step([$class: 'WarningsPublisher',
                  parserConfigurations: [[
                    parserName: 'Pep8',
                    pattern: 'report/flake8.log'
                  ],
                  [
                    parserName: 'pylint',
                    pattern: 'report/pylint.log'
                  ]],
                  unstableTotalAll: '0',
                  usePreviousBuildAsReference: true
                ])
            }
        }

    }

}
