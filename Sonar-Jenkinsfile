pipeline{
    agent any
    tools{
        maven 'maven-3.9'
    }
    environment{
        ArtifactId = readMavenPom().getArtifactId()
        Version = readMavenPom().getVersion()
        Name = readMavenPom().getName()
        GroupId = readMavenPom().getGroupId()
    }
    stages{
        stage('SCM Checkout'){
            steps{
                git 'https://github.com/bganga1989/java-jsp-diary.git'
            }
        }
        stage ('Build'){
            steps{
                sh 'mvn clean install package'
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
        stage ('Publish to Nexus'){
            steps{
                script{
                    def NexusRepo = Version.endsWith("SNAPSHOT") ? "java-jsp-diary-SNAPSHOT" : "java-jsp-diary"
                    nexusArtifactUploader artifacts:
                    [[artifactId: "${ArtifactId}",
                    classifier: '',
                    file: "target/${ArtifactId}-${Version}.war",
                    type: 'war']],
                    credentialsId: 'nexus3',
                    groupId: "${GroupId}",
                    nexusUrl: '65.2.169.22:8081',
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    repository: "${NexusRepo}",
                    version: "${Version}"
                }
            }
        }
        stage ('Print Environment variables'){
            steps{
                echo "Artifact ID is '${ArtifactId}'"
                echo "Version is '${Version}'"
                echo "GroupID is '${GroupId}'"
                echo "Name is '${Name}'"
            }
        }
        Deploying the build artifact to Apache Tomcat
        stage ('Deploy to Tomcat'){
            steps{
                echo "Deploying ...."
                sshPublisher(publishers: 
                [sshPublisherDesc(
                    configName: 'tomcat-server', 
                    transfers: [
                        sshTransfer(
                            cleanRemote:false,
                            execCommand: 'ansible-playbook /opt/playbooks/downloadanddeploy_as_tomcat_user.yaml -i /opt/playbooks/hosts',
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
