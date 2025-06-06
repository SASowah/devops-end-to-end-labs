pipeline {
    agent any

    environment {
        SSH_KEY = credentials('chat-server-key')
        SERVER_IP = '44.207.84.102' // Change this if your IP updates
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'dev',
                    url: 'https://github.com/SASowah/devops-end-to-end-labs.git'
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                sshagent(['chat-server-key']) {
                    sh 'ansible-playbook -i ansible/inventory.ini ansible/playbook.yml'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful! Access the following services:'
            echo "Chat App:       http://${env.SERVER_IP}"
            echo "Prometheus:     http://${env.SERVER_IP}:9090"
            echo "Grafana:        http://${env.SERVER_IP}:3000"
            echo 'Default Grafana Login: admin / admin'
        }

        failure {
            echo '❌ Deployment failed. Check Ansible and Jenkins logs for details.'
        }
    }
}
