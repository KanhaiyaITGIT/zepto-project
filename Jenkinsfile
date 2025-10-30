pipeline {
    agent any
    environment {
        PATH = "/opt/maven/bin:$PATH"
    }

    stages {
        stage('git clone') {
            steps {
                echo "cloning git repo"
                git url: "https://github.com/KanhaiyaITGIT/zepto-project.git", branch: "main"
                echo "repo cloned successfully, please check further parameters"
            }
        }
        stage('code build') {
            steps {
                echo "building code"
                sh "mvn clean package -Dmaven.test.skip=true"
                echo "build completed"
            }
        }
        stage('report generate') {
            steps {
                echo "generating report"
                sh "mvn surefire-report:report"
                echo "report generated"
            }
        }
        stage ('Sonarqube analysis') {
            environment {
                sonarHome = tool 'sonar-scanner'
            }
            steps {
                echo "sonarqube analysis starting"
                withSonarQubeEnv('sonar-server') {
                    sh "${sonarHome}/bin/sonar-scanner"
                }
                echo 'sonarqube analysis completed'
            }
        }
        stage('Quality Gates') {
            steps {
                echo "quality gate analysis"
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: false
                }
            }
        }
    }
    post {
        success {
            echo "code successfully deployed"
        }
        failure {
            echo "code failed..!!, check the logs"
        }
        always {
            echo "cleaning workspace.."
            cleanWs()
        }
    }
}
