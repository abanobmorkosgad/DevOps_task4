pipeline {
    agent {
        kubernetes {
            label 'jenkinsrun'
            defaultContainer 'builder'
            yaml """
kind: Pod
metadata:
  name: kaniko
  namespace: jenkins
spec:
  serviceAccountName: jenkins-admin
  containers:
  - name: kubectl
    image: bitnami/kubectl:latest
    command:
      - "/bin/sh"
      - "-c"
      - "sleep 99d"
    tty: true
    securityContext:
      runAsUser: 0
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - cat
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
                container('kaniko') {
                    script {
                        sh '/kaniko/executor --dockerfile app/Dockerfile --context app --destination abanobmorkos10/pwc_app:latest'
                    }
                }
            }
        }
        stage('deploy to eks') {
            environment {
                AWS_ACCESS_KEY_ID = credentials("aws_access_key_id")
                AWS_SECRET_ACCESS_KEY = credentials("aws_secret_access_key")
            }
            steps {
                container('kubectl') {
                    withCredentials([file(credentialsId: 'kube-config', variable: 'KUBECONFIG')]) {
                        script {
                            sh '''
                            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                            unzip awscliv2.zip
                            ./aws/install

                            kubectl apply -f k8s_app
                            '''
                        }
                    }
                }
            }
        }
    }
}
