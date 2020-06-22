# Sample_Node_App_Kubernetes
This is a simple Node App that is deployed on Kubernetes and I have used for terraform as infrastructure automation for setting master node and worker nods in EKS. 

## Directories/Files Overview ## 

- **sample_node_app** : This forlder contains the source code (`index.js` & `package.json`) for the simple nodejs application, just prints out text on the web browser.It also contains `Dockerfile` and later I build the image and pushed to ecr repository (steps showed in `Jenkinsfile` ).

- **kubernetes** : This folder contains kubernetes configuration files that are need to orchestrate the docker image. `nodejs_app_deployment.yaml` contains configuration for creating deployment.
`nodejs_app_service.yaml` contains configuration for creating clasical loadbalancer service to serve traffic.
`autoscaling_hpa.yaml` contains configuration for creating horizontal pod scaling for deployment based on cpu and memory usage. `priority_class.yaml` contains configerations priority for the pods of deployment.

- **terraform** : This folder contains entire infrastructure automation including networking, access(RBAC) , master-node control plane and worker-node setup for EKS. In the `Jenkinsfile` I ran terrform init , terraform plan & terraform apply commands. 

- **Jenkinsfile** : CI/CD process for entire project, containing different stages to build infrastructure (`TerraformInit_&_Plan` and `TerraformApply`), build & push docker image (`Build&PushSampleAppDockerImage`) and deploy kubernetes deployment and service (`KubernetesDeploy`). Atlast stage we will get `Service_Url` i.e. loadbalancer url.

![final deployed project view](https://github.com/Nogutsune/Node_Sample_Kubernetes/blob/master/images/final_view.png?raw=true)

## Addressed Issues ##

- **There should be 10 replicas running.**

  In *kubernetes/nodejs_app_deployment.yaml* I have mentioned ```replicas: 10```
- **The deployment should autoscale at average 50% cpu and 60% memory.**

  I have created *kubernetes/autoscaling_hpa.yaml* which autoscales pods from 10 to 15 if averageCPUutilization reaches 50% or if averageMemoryUtilization reaches 60%. 
- **Use a custom docker image hosted on ECR called nodejs-test:latest (any region).**

  Created *nodejs-test* ecr repository via terraform refer *terraform/ecr.tf* . In *Jenkinsfile* in `Build&PushSampleAppDockerImage` stage, after building and tagging image I push image (tagged `655307685566.dkr.ecr.us-east-1.amazonaws.com/nodejs-test:latest`) to this ecr. 
- **Bonus points if you include how to login and pull an image from ECR.**

  I have created a role for worker nodes and included the policy `arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly` refer *terraform/iam.tf* , then I can use `image: 655307685566.dkr.ecr.us-east-1.amazonaws.com/nodejs-test:latest` in *kubernetes/nodejs_app_deployment.yaml* it can automatically pull image from ecr. 
- **Expose the app on port 3000 via an EC2 classic load balancer.**

  The node application expose port 3000 refer *sample_node_app/Dockerfile* which is further used as container port in *kubernetes/nodejs_app_deployment.yaml* and in the *kubernetes/nodejs_app_service.yaml* I have created classical loadbalancer to serve the application
- **Any change to the deployment should always ensure at least 7 replicas are running at all times.**

  In *kubernetes/nodejs_app_deployment.yaml* I have configured rolling update as deployment strategy to make sure 7 pods are always available 

```strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 3
  ```
      
- **Should have higher priority than daemonset pods.**

  Created *kubernetes/priority_class.yml* which setup priority class of the pods and later configured in *kubernetes/nodejs_app_deployment.yaml* `priorityClassName: high-priority`
- **Bonus points if you do the task as code i.e. using terraform or any other configuration language of your choice.**

  Refer terraform folders.
- **Bonus points if you also load test the application and include the test results in your submission.**


