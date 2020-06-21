pipeline {
    agent any
    parameters {
        string(name: 'TERRAFORM_GIT_URI', defaultValue: 'git@github.com:Nogutsune/Node_Sample_Kubernetes.git', description:'Git URI')
        string(name: 'TERRAFORM_GIT_BRANCH', defaultValue: 'master', description:'Git branch ')
        string(name: 'DOCKER_REPO_NAME', defaultValue: 'nodejs-test', description:'Docker repository name')
        string(name: 'DOCKER_REPO_URL', defaultValue: '655307685566.dkr.ecr.us-east-1.amazonaws.com', description:'Docker repository URL')
        string(name: 'DOCKER_HTTPS_REPO_URL', defaultValue: 'https://655307685566.dkr.ecr.us-east-1.amazonaws.com', description:'Docker repository HTTPS URL')
    }
    environment {
        TF_HOME = tool('terraform-1.0.9')
        TF_IN_AUTOMATION = "true"
        PATH = "$TF_HOME:$PATH"
        AWS_ACCESS_KEY_ID = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    }

    stages {
        stage('TerraformInit_&_Plan'){
            steps {
                git branch: "${params.TERRAFORM_GIT_BRANCH}",
                    url: "${params.TERRAFORM_GIT_URI}"
                sh "/usr/local/bin/terraform get -update"
                script {
                       sh "cd terraform/"
                       sh "/usr/local/bin/terraform init -backend=true"
                       sh "/usr/local/bin/terraform refresh -var 'aws_access_key=$AWS_ACCESS_KEY_ID' -var 'aws_secret_key=$AWS_SECRET_ACCESS_KEY'"
                       sh "/usr/local/bin/terraform plan -var 'aws_access_key=$AWS_ACCESS_KEY_ID' -var 'aws_secret_key=$AWS_SECRET_ACCESS_KEY' -out terraform.tfplan;echo \$? > status"
                       stash name: "terraform-plan", includes: "terraform.tfplan"
                    }
               }
          }

        stage('TerraformApply'){
            steps {
                script{
                       sh "cd terraform/"
                       unstash "terraform-plan"
                       sh 'pwd'
                       sh '/usr/local/bin/terraform apply terraform.tfplan'
                    }
                }
            }

          stage('Build Sample App Docker Image'){
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'jenkins-test-user', variable: 'AWS_ACCESS_KEY_ID']]) {
                script {
                    sh "cd sample_node_app"
                    def image = docker.build("${params.DOCKER_REPO_NAME}:${BUILD_NUMBER}", '-f Dockerfile .')
                    docker.withRegistry("${params.DOCKER_HTTPS_REPO_URL}", 'ecr:us-east-1:jenkins-test-user'){
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'jenkins-test-user', accessKeyVariable: 'AWS_ACCESS_KEY_ID',secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh("eval \$(aws ecr get-login --no-include-email | sed 's|https://||')")
                            }
                        sh "docker tag ${params.DOCKER_REPO_NAME}:${BUILD_NUMBER} ${params.DOCKER_REPO_URL}/${params.DOCKER_REPO_NAME}:v_${BUILD_NUMBER}"
                        sh "docker tag ${params.DOCKER_REPO_NAME}:${BUILD_NUMBER} ${params.DOCKER_REPO_URL}/${params.DOCKER_REPO_NAME}:latest"
                        sh "docker push ${params.DOCKER_REPO_URL}/${params.DOCKER_REPO_NAME}"
                    }
                }
             }
          }
       }
       stage('kubernetes deploy'){
           steps {
               withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'jenkins-test-user', variable: 'AWS_ACCESS_KEY_ID']]) {
               script{
                      sh "aws eks --region us-east-1 update-kubeconfig --name insider-master-node"
                      sh "kubectl apply -f kubernetes/"
                   }
                }
              }
           }

    }
}
