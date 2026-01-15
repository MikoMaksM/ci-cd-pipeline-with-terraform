#!/usr/bin/env groovy

library identifier: 'jenkins-shared-library@starting-code',
         retriever: modernSCM(
           [$class: 'GitSCMSource',
            remote: 'https://github.com/MikoMaksM/jenkins-shared-library.git',
            credentialsId: 'github-credentials1']
         )

pipeline {
    agent any
    tools {
        maven 'maven-3.9'
    }
    environment {
        IMAGE_NAME = 'mikomaksm/demo-app:java-maven-1.0'
    }
    stages {
        stage('build app') {
            steps {
                echo 'building application jar...'
                buildJar()
            }
        }
        stage('build image') {
            steps {
                script {
                    echo 'building the docker image...'
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo 'deploying docker image to EC2...'
                    def dockerCmd = "docker run -p 8080:8080 -d ${IMAGE_NAME}"
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@54.79.3.129 ${dockerCmd}"
                    }
                }
            }
        }
    }
}