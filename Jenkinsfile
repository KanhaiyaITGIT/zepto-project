pipeline {
    agent any
    environment {
        PATH = "/opt/maven/bin:$PATH"
    }

    stages {
        stage('git clone') {
            steps {
                git url: "https://github.com/KanhaiyaITGIT/zepto-project.git", branch: "main"
            }
        }
        stage('code test') {
            steps {
                echo "code testing start..!!"
                sh "mvn clean package -Dmaven.test.skip=true"
                echo "test completed"
            }
        }
        stage('test report') {
            steps {
                echo "report generating..!!"
                sh "mvn surefire-report:report"
                echo "report generated"
            }
        }
        stage('sonar analysis') {
            environment {
                sonarHome = tool 'sonar-scanner'
            }
            steps {
                echo "code ananlysis starting"
                withSonarQubeEnv('sonar-server') {
                    sh "${sonarHome}/bin/sonar-scanner"
                }
                echo "analysis completed ✅"
            }
        }
    }
    post {
        always {
            echo "work completed, cleaning workspace"
            cleanWs()
        }
    }
}
