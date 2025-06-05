pipeline {
    agent any

    environment {
        SSH_KEY = credentials('chat-server-key')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'dev'
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
            echo 'Ansible playbook executed successfully!'
            echo 'You can now access the chat server at http://44.207.84.102'
        }
        failure {
            echo 'Ansible playbook execution failed.'
        }
    }
}
