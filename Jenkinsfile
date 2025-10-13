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
                echo "test starting.."
                sh 'mvn clean package -Dmaven.test.skip=true'
                echo "test succesfully" 
            }
        }

        stage('code build') {
            steps {
                echo "generating build report"
                sh 'mvn surefire:report:report'
                echo "build succesfully"
            }
        }

        stage('sonarqube analysis') {
           environment {
               sonarHome = tool 'sonar-scanner'
           }
           steps {
               withSonarQubeEnv('sonar-server') {
                   sh "${sonarHome}/bin/sonar-scanner"
               }
           }
        }
    }
}
