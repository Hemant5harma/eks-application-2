pipeline {
    agent any

    tools {
        nodejs 'nodejs' 
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Hemant5harma/eks-application-2.git'
            }
        }

        stage('Test') {
            steps {
                echo 'Test done'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'docker-cred']) {
                        sh '''
                            docker build -t ${JOB_NAME}:${BUILD_ID} .
                            docker tag ${JOB_NAME}:${BUILD_ID} hemanthub/${JOB_NAME}:${BUILD_ID}
                            docker tag ${JOB_NAME}:${BUILD_ID} hemanthub/${JOB_NAME}:latest
                        '''
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'docker-cred']) {
                        sh '''
                            docker push hemanthub/${JOB_NAME}:${BUILD_ID}
                            docker push hemanthub/${JOB_NAME}:latest
                        '''
                    }
                }
            }
        }
        stage('Deploy to EKS') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yml'
                sh 'kubectl apply -f k8s/service.yml'
                sh 'kubectl rollout restart deployment/eks2'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs for more details.'
        }
    }
}
