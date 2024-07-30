pipeline {
  agent {
    kubernetes {
      label 'jenkinsrun'
      defaultContainer 'builder'
      yaml """
kind: Pod
metadata:
  name: kaniko
spec:
  containers:
  - name: builder
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: docker-config
        mountPath: /kaniko/.docker/
  volumes:
    - name: docker-config
      secret:
        secretName: docker-config
"""
    }
  }
  stages {
    stage('Build-Docker-Image') {
      steps {
        sh "/kaniko/executor --dockerfile app/Dockerfile --context app --destination abanobmorkos10/pwc_app:latest"
      }
    }
    stage('Deploy to minikube') {
      steps {
        echo 'Deploying to eks cluster ...'
        withCredentials([file(credentialsId: 'kube-config', variable: 'KUBECONFIG')]) {
          script {
            sh """
              # Install kubectl
              curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              chmod +x kubectl
              mv kubectl /usr/local/bin/
              
              # Apply Kubernetes manifests
              kubectl apply -f k8s_app/spp.yaml
              kubectl apply -f k8s_app/service.yaml
            """
          }
        }
      }
    }
  }
}
