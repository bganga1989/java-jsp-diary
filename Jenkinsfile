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
                sh 'mvn clean install package'
            }
        }
        stage('SonarQube analysis'){
           //    def scannerHome = tool 'sonar';
           steps{
               withSonarQubeEnv('sonar'){
                   // If you have configured more than one global server connection, you can specify its name
                   //      sh "${scannerHome}/bin/sonar-scanner"
                   sh "mvn sonar:sonar"
                }
            }
        }
        stage('Publish to Nexus'){
           steps{
               script{
                   def readPomVersion = readMavenPom file: 'pom.xml'
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
                    version: "${readPomVersion.version}"
               }
           }
       }
       stage ('Deploy with Ansible'){
            steps{
                echo "Deploying ...."
                sshPublisher(publishers:
                [sshPublisherDesc(
                    configName: 'Ansible',
                    transfers: [
                        sshTransfer(
                            cleanRemote: false,
                            execCommand:'ansible-playbook --vault-password-file=/etc/ansible/my_pass /etc/ansible/deploy.yml -i ./aws_ec2.yaml --private-key=/etc/ansible/ec2.pem',
                            execTimeout: 120000
                        )
                    ],
                    usePromotionTimestamp: false,
                    useWorkspaceInPromotion: false,
                    verbose: false)
                    ])
                
            }
       }
    }
}
