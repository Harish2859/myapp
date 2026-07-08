pipeline {
    agent any
    stages {
        stage('Build React') {
            steps {
                echo 'Installing dependencies...'
                bat 'npm install'
                echo 'Building React app...'
                bat 'npm run build'
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