pipeline {
    agent any

    environment {
        sshCredentials = credentials('chat-server-key')
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
                withCredentials([sshUserPrivateKey(credentialsId: 'chat-server-key', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                        export ANSIBLE_HOST_KEY_CHECKING=False
                        ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --private-key $SSH_KEY
                    '''
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
        always {
            cleanWs()
        }
    }
}
