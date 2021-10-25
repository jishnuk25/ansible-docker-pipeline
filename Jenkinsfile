def CONTAINER_NAME = 'loginapptomcat'
def CONTAINER_TAG = 'latest'
def DOCKER_HUB_USER = '25795'

pipeline {

    agent any

    environment {
        PATH = "/usr/share/maven/bin:$PATH"
    }

    stages {
        stage("Checkout") {
            steps {
                git url:'https://github.com/jishnuk25/ansible-docker-pipeline.git', credentialsId:'00548fae-616-47bf-a7f0-5add59ab5ded'
            }
        }
        stage("Build") {
            steps { 
                sh "mvn clean install"
            }
        }
        stage("Archive artifacts") {
            steps{
                archiveArtifacts artifacts: 'target/*.war', followSymlinks: false, onlyIfSuccessful: true
            }
        }
        stage("Image prune") {
            steps {
                imagePrune(CONTAINER_NAME)
            }
        }
        stage("Image build") {
            steps {
                imageBuild(CONTAINER_NAME, CONTAINER_TAG)
            }
        }
        stage("Image push") {
            steps{
                withCredentials([usernamePassword(credentialsId:'dockerHubAccount', passwordVariable:'PASSWORD', usernameVariable:'USERNAME')]) {
                    imagePush(CONTAINER_NAME, CONTAINER_TAG, USERNAME, PASSWORD)
                }
            }
        }
        stage("deploy(ansible)") {
            steps {
                ansiblePlaybook credentialsId: 'dev-server', disableHostKeyChecking: true, installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy-docker.yml'
            }
        }
    }
}

def imagePrune(containerName) {
    try {
    sh "sudo docker image prune -f"
    sh "docker stop $containerName"
    }
    catch(error) {}
}

def imageBuild(containerName, tag) {
    sh "docker build -t $containerName:$tag -t $containerName --pull --no-cache ."
    echo "Image ${containerName}:${tag} built successfully"
}

def imagePush(containerName, tag, dockerUser, dockerPassword) {
    sh "docker login -u $dockerUser -p $dockerPassword"
    sh "docker tag $containerName:$tag $dockerUser/$containerName:$tag"
    sh "docker push $dockerUser/$containerName:$tag"
    echo "${containerName}:${tag} pushed to Docker Hub successfully"
}