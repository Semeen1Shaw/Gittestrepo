pipeline {
    agent any

    environment {
        IMAGE_NAME = "your-docker-user/flaskapp"
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
                kustomize edit set image $IMAGE_NAME=$IMAGE_NAME:dev-$SHORT_SHA --load-restrictor=LoadRestrictionsNone --reorder=legacy
                kubectl apply -k k8s/overlays/dev
                '''
            }
        }
    }
}
