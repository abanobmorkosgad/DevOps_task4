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
            sh "/kaniko/executor --dockerfile app/Dockerfile --context app"
        //   }
        }
      }
    }
  }
}