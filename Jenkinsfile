pipeline {
    agent any
    parameters {
        string(name: 'TERRAFORM_GIT_URI', defaultValue: 'git@github.com:Nogutsune/Node_Sample_Kubernetes.git', description:'Git URI')
        string(name: 'TERRAFORM_GIT_BRANCH', defaultValue: 'master', description:'Git branch ')
    }
    environment {
        TF_HOME = tool('terraform-1.0.9')
        TF_IN_AUTOMATION = "true"
        PATH = "$TF_HOME:$PATH"
        AWS_ACCESS_KEY_ID = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    }

    stages {
        stage('Terraform Init & Plan'){
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
        }
}
