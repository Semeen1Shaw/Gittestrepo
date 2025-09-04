pipeline {
    agent any

    environment {
        IMAGE_NAME = "semeen1shaw/pythonapp"
        SHORT_SHA = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
    }

    triggers {
        githubPush()  // or gitlabPush() or pollSCM('* * * * *') if needed
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Dev Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:dev-$SHORT_SHA .
                docker push $IMAGE_NAME:dev-$SHORT_SHA
                '''
            }
        }

        stage('Build Prod Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:prod-$SHORT_SHA .
                docker push $IMAGE_NAME:prod-$SHORT_SHA
                '''
            }
        }

        stage('Deploy to Dev') {
            steps {
                sh '''
                # Update the dev overlay with new image tag
		cd k8s/overlays/dev
                kustomize edit set image $IMAGE_NAME=$IMAGE_NAME:dev-$SHORT_SHA 
                kubectl apply -k .
                '''
            }
        }
    }
}
