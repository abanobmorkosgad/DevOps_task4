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
    - cat
    tty: true
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
            steps {
                container('kubectl') {
                    withCredentials([file(credentialsId: 'kube-config', variable: 'KUBECONFIG')]) {
                        script {
                            sh 'kubectl apply -f k8s_app'
                        }
                    }
                }
            }
        }
    }
}
