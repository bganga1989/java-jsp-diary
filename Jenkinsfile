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
    }
}
