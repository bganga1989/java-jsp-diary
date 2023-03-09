pipeline{
    agent any
    tools{
        maven 'maven-3.9'
    }
    stages{
        stage('SCM Checkout'){
            steps{
                git 'https://github.com/bganga1989/java-jsp-diary.git'
            }
        }
        stage('Build'){
            steps{
                sh 'mvn clean package'
            }
        }
        stage('SonarQube analysis'){
           //    def scannerHome = tool 'Sonar-scanner';
           steps{
               withSonarQubeEnv('Sonar'){
                   // If you have configured more than one global server connection, you can specify its name
                   //      sh "${scannerHome}/bin/sonar-scanner"
                   sh "mvn sonar:sonar"
                }
            }
        }
        stage('Upload War to Nexus'){
            steps{
                nexusArtifactUploader artifacts: [
                    [
                        artifactId: 'java-jsp-diary',
                        classifier: '',
                        file: 'target/java-jsp-diary.war',
                        type: 'war'
                    ]
                ],
                credentialsId: 'nexus3',
                groupId: 'com.yusufsezer',
                nexusUrl: '65.2.169.22:8081',
                nexusVersion: 'nexus3',
                protocol: 'http',
                repository: 'java-jsp-diary',
                version: '0.0.1'
            }
        }
        stage('Deploy to Tomcat Server'){
            steps{
                deploy adapters: [tomcat8(credentialsId: 'tomcat-credentials', path: '', url: 'http://65.1.133.61:8080/')], contextPath: null, war: '**/*.war'
            }
        }
    }
}
