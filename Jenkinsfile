pipeline {
    agent any
    options {
        skipDefaultCheckout(false)
    }
    tools {
        nodejs 'nodejs'
    }
    stages {
        stage('Build React') {
            steps {
                dir('myApp') {
                    echo 'Installing dependencies...'
                    bat 'npm install'
                    echo 'Building React app...'
                    bat 'npm run build'
                }
            }
        }
        stage('Docker Build') {
            steps {
                echo 'Creating Docker image...'
                bat 'docker build -t react-app:latest .'
            }
        }
    }
}