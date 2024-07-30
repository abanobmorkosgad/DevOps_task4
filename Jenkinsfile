pipeline {
    agent {
        kubernetes {
            label 'jenkinsrun'
            defaultContainer 'dind'
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: dind
    image: docker:18.05-dind
    securityContext:
      privileged: true
    volumeMounts:
      - name: dind-storage
        mountPath: /var/lib/docker
  volumes:
    - name: dind-storage
      emptyDir: {}
"""
        }
      }
  stages {
    // stage('Clone') {
    //   steps {
    //     container('docker') {
    //       git branch: 'main', changelog: false, poll: false, url: 'https://mohdsabir-cloudside@bitbucket.org/mohdsabir-cloudside/java-app.git'
    //     }
    //   }
    // }  
    stage('Build-Docker-Image') {
      steps {
        dir('app'){
            // container('docker') {
            sh 'docker build -t abanobmorkos10/app_pwc:latest .'
        //   }
        }
      }
    }
  }
}