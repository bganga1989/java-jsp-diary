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
       stage ('Deploy'){
            steps{
                echo "Deploying ...."
                sshPublisher(publishers:
                [sshPublisherDesc(
                    configName: 'Ansible',
                    transfers: [
                        sshTransfer(
                            cleanRemote: false,
                            execCommand:'ansible-playbook /home/ec2-user/downloadanddeploy.yml -i ./aws_ec2.yaml --private-key=ec2.pem',
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
