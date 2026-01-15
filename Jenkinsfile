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
                    def dockerComposeCmd = "docker-compose -f docker-compose.yaml up --detach"
                    sshagent(['ec2-server-key']) {
                        sh "scp docker-compose.yaml ec2-user@54.79.3.129:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@54.79.3.129 ${dockerComposeCmd}"
                    }
                }
            }
        }
    }
}