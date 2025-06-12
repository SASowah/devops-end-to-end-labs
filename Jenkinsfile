pipeline {
    agent any
   
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        DOCKER_IMAGE = 'samsow/ecommerce-backend'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'development', url: 'https://github.com/SASowah/devops-end-to-end-labs.git'
            }
        }
        
        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Login to Docker Hub
                    sh 'echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin'
                    
                    // Build the Docker image
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                    sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                    
                    // Push the Docker image
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }
        
        stage('Deploy to EKS') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        
                        # Update kubeconfig with legacy auth
                        aws eks update-kubeconfig --region us-east-1 --name ecommerce-eks --kubeconfig kubeconfig.yaml
                        
                        # Apply Kubernetes manifests using kubeconfig
                        KUBECONFIG=kubeconfig.yaml kubectl apply -f kubernetes/deployment.yaml
                        KUBECONFIG=kubeconfig.yaml kubectl apply -f kubernetes/service.yaml
                        KUBECONFIG=kubeconfig.yaml kubectl apply -f kubernetes/ingress.yaml
                    '''
                }
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
            cleanWs()
        }
    }
}