pipeline {

    agent any
    environment {
        PATH = "/opt/maven/bin:$PATH"
    }

    stages {
        stage('git clone') {
            steps {
                echo "git repo cloning"
                git url: "https://github.com/KanhaiyaITGIT/zepto-project.git", branch: "main"
            }
        }
        stage('code test') {
            steps {
                echo "code testing start"
                sh "mvn test"
                junit 'target/surefire-reports/*.xml'
                echo "code tested"
            }
        }
        stage('report generate') {
            steps {
                echo "generating report"
                sh "mvn surefire-report:report"
                echo "report generated"
            }
        }
        stage('sonarqube analysis') {
            environment {
                sonarHome = tool "sonar-scanner"
            }
            steps {
                echo "sonarqube analysis starting...!!"
                withSonarQubeEnv('sonar-server') {
                    sh "${sonarHome}/bin/sonar-scanner"
                }
                echo "waiting for quality gates.."
                waitForQualityGate abortPipeline: true
                echo "quality gate passed"
            }
        }
    }
    post {
        success {
            echo "pipeline completed successfully"
        }
        failure {
            echo "pipeline failed, check logs"
        }
        always {
            echo "pipeline completed..cleaning workspacce"
            cleanWs()
        }
    }
}
