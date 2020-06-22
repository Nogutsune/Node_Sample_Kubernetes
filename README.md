# Sample_Node_App_Kubernetes
This is a simple Node App that is deployed on Kubernetes and I have used for terraform as infrastructure automation for setting master node and worker nods in EKS. 

## Directories/Files Overview ## 

- **sample_node_app** : This forlder contains the source code (`index.js` & `package.json`) for the simple nodejs application, just prints out text on the web browser.It also contains `Dockerfile` and later I build the image and pushed to ecr repository.

- **kubernetes** : This folder contains kubernetes configuration files that are need to orchestrate the docker image. `nodejs_app_deployment.yaml` contains configuration for creating deployment.
`nodejs_app_service.yaml` contains configuration for creating clasical loadbalancer service to serve traffic.
`autoscaling_hpa.yaml` contains configuration for creating horizontal pod scaling for deployment based on cpu and memory usage. `priority_class.yaml` contains configerations priority for the pods of deployment.
