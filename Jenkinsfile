pipeline {
    agent {
        kubernetes {
            yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: docker
            image: abanobmorkos10/docker
            command:
            - cat
            tty: true
            securityContext:
              privileged: true
       '''
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