pipeline {
    agent any
    
    tools {
        maven 'maven-3.9'
    }
    
    stages{
        stage ('Build'){
            steps {
                sh 'mvn clean package'
            }
            post {
                success {
                    echo 'Archiving the artifacts'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

        stage ('Deploy to tomcat server'){         
            steps {
                deploy adapters: [tomcat8(credentialsId: 'tomcat-credentials', path: '', url: 'http://65.1.133.61:8080/')], contextPath: null, war: '**/*.war'
            }
         
        }
    }
}
