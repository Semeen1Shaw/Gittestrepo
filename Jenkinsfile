pipeline {
  agent any

  environment {
    IMAGE_NAME = "semeen1shaw/pythonapp"
    SHORT_SHA = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
  }

  triggers {
    githubPush()
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        script {
          env.SHORT_SHA = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
        }
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
        withCredentials([file(credentialsId: 'kubeconfig_dev', variable: 'KUBECONFIG_FILE')]) {
          sh '''
            export KUBECONFIG=$KUBECONFIG_FILE
            cd k8s/overlays/dev
            kustomize edit set image $IMAGE_NAME=$IMAGE_NAME:dev-$SHORT_SHA
            kubectl apply -k .
          '''
        }
      }
    }
  }
}
//n3xt to add the test stage
// Added the github webhook testing 3
