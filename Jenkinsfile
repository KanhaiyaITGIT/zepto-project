pipeline {
    agent any
    enviornment {
        PATH = "/opt/maven/bin:$PATH"
    }

    stages {
        stage('git clone') {
            git url: "https://github.com/KanhaiyaITGIT/zepto-project.git", branch: "main"
        }

        stage('code test') {
            steps {
                echo "test starting.."
                sh "mvn install package -Dmaven.test.skip=true"
                echo "test succesfully" 
            }
        }

        stage('code build') {
            steps {
                echo "generating build report"
                sh "mvn surefire:report:report"
                echo "build succesfully"
            }
        }

        stage('sonarqube analysisc') {
           enviornment {
               sonarHome = tool 'scanner-scanner'
           }
           steps {
               withSonarQube('sonar-server') {
                   sh "${scannerHome}/bin/sonar-scanner"
               }
           }
        }
    }
}
