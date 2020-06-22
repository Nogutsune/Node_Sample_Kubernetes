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
- **Bonus points if you include how to login and pull an image from ECR.**
- **Expose the app on port 3000 via an EC2 classic load balancer.**
- **Any change to the deployment should always ensure at least 7 replicas are running at all times.**
- **Should have higher priority than daemonset pods.**
- **Bonus points if you do the task as code i.e. using terraform or any other configuration language of your choice.**
- **Bonus points if you also load test the application and include the test results in your submission.**
