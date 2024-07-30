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
    image: abanobmorkos10/aws-kubectl
    command:
      - "/bin/bash"
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
                        sh '/kaniko/executor --dockerfile app/Dockerfile --context app --destination abanobmorkos10/pwc_app:${BUILD_NUMBER}'
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
                            sh 'sed -i \"s|image:.*|image: abanobmorkos10/pwc_app:${BUILD_NUMBER}|g\" k8s_app/app.yaml'
                            sh 'kubectl apply -f k8s_app'
                        }
                    }
                }
            }
        }
    }
}
