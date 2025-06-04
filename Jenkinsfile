pipeline {
    agent any

    environment {
        SSH_KEY = credentials('chat-server-key')
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/dev']],
                    userRemoteConfigs: [[url: 'https://github.com/SASowah/devops-end-to-end-labs.git']]
                ])
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
        }
        failure {
            echo 'Ansible playbook execution failed.'
        }
    }
}
