# Web Application Deployment using AWS CodePipeline, ECR, and ECS

## Overview

This project demonstrates how to deploy a Node.js web application on Amazon ECS Fargate using AWS CodePipeline. The pipeline integrates GitHub as the source, builds the Docker image using AWS CodeBuild, pushes the image to Amazon ECR, and finally deploys the application to Amazon ECS.

## Prerequisites

Before proceeding, ensure you have the following:

- An AWS account
- AWS CLI configured with appropriate credentials
- AWS CodePipeline, CodeBuild, ECR, and ECS set up
- GitHub repository containing the application files
- Docker installed locally (for testing)

## Project Structure

Here is the structure of the project repository:

```plaintext
├── Dockerfile            # Docker instructions to build the container image
├── buildspec.yml         # AWS CodeBuild configuration
├── command.txt           # Contains useful CLI commands for Docker and ECR
├── index.html            # Frontend HTML page of the application
├── package.json          # Node.js dependencies and application information
```

## Explanation of Files

1. **Dockerfile**: 
   - This file contains the instructions on how to build the Docker image for the Node.js application. It defines the base image (Node.js), sets the working directory, installs dependencies using the `package.json` file, and starts the application.
   
2. **buildspec.yml**: 
   - This file is used by AWS CodeBuild to automate the build process. It defines the steps to log into Docker Hub and Amazon ECR, build the Docker image, and push it to ECR. It also generates the `imagedefinitions.json` file, which is used by Amazon ECS to pull the correct image for deployment.

3. **index.html**: 
   - This is the main HTML page served by the web application. It provides the frontend view of the application and can be customized based on your requirements.
   
4. **package.json**: 
   - This file manages the application's dependencies and configuration for the Node.js environment. It includes details such as the application name, version, dependencies, and start scripts used when the application is started in a container.

5. **command.txt**: 
   - This text file stores useful AWS CLI and Docker commands that are helpful for interacting with the application, such as building Docker images, pushing them to ECR, and setting up the ECS environment.

## Step-by-Step Deployment Guide

### Step 1: Create a GitHub Repository

1. Ensure that the application files (`Dockerfile`, `buildspec.yml`, `index.html`, and `package.json`) are committed and pushed to your GitHub repository.
2. This repository will act as the source for AWS CodePipeline.

### Step 2: Set Up Amazon ECR (Elastic Container Registry)

1. Create a new ECR repository where the Docker image of your application will be stored:
   ```bash
   aws ecr create-repository --repository-name ecs-fargate-app --region <your-region>
   ```
2. Note down the ECR repository URI, as it will be used during the build process.

## Step-by-Step Deployment Guide

### Step 3: Configure Amazon ECS and Fargate

1. **Create an ECS Cluster**:
   - Navigate to the ECS dashboard in AWS and create a new Fargate cluster.
   - Define the required services such as networking, and associate an IAM role that allows ECS to interact with other AWS services (like pulling images from ECR).

2. **Create a Task Definition**:
   - In the ECS dashboard, create a new Task Definition.
   - Choose Fargate as the launch type.
   - Specify the container details, including:
     - The Docker image URI from ECR.
     - Memory and CPU requirements.
     - Port mappings (e.g., map port 80 to expose the application).
   - Set the environment variables if your application requires them.

3. **Create a Service**:
   - Once the task definition is created, create an ECS service that will manage the task.
   - Choose the number of tasks (instances of the application) you want to run.
   - Set up auto-scaling if needed to handle traffic based on your application load.
   - The service will ensure that your application is running at the desired capacity and will restart failed tasks automatically.

### Step 4: Set Up AWS CodePipeline

1. **Source Stage**:
   - In the AWS CodePipeline dashboard, start creating a new pipeline.
   - Choose GitHub as the source provider and connect your repository.
   - Select the branch where your application code resides. This will trigger a build when there are changes to this branch.

2. **Build Stage**:
   - Add a new build stage using AWS CodeBuild.
   - Select an existing build project or create a new one, specifying the `buildspec.yml` file that resides in your GitHub repository. 
   - This file defines how CodeBuild logs into Docker Hub, builds the Docker image, and pushes it to Amazon ECR.

3. **Deploy Stage**:
   - For the deployment stage, choose Amazon ECS as the deployment provider.
   - Link the ECS cluster and the service created earlier in the configuration. 
   - Ensure the ECS service can pull the correct Docker image using the `imagedefinitions.json` file, which is generated during the build stage.

### Step 5: Testing the Application

1. After a successful deployment, navigate to the ECS dashboard and check the service status.
   - Ensure that the tasks are running and healthy.
   - You can view the logs of the running tasks for debugging if necessary.
   
2. Obtain the public DNS or IP address of the ECS service (from the load balancer or public IP) and navigate to it in your browser.
   - You should see your web application served by the Node.js server.

3. If there are issues, review the logs in ECS and CodePipeline, and check that the correct Docker image was pulled from ECR.

### Best Practices

1. **Use Version Tags for Docker Images**:
   - It's a good practice to use unique version tags for your Docker images instead of using `latest`. This ensures that ECS pulls the correct version of your application and prevents accidental overwrites.

2. **Secure Sensitive Information**:
   - Store sensitive data, such as API keys and database credentials, in AWS Secrets Manager or AWS Systems Manager Parameter Store, and reference them in your task definitions.

3. **Enable Auto-scaling for ECS**:
   - Use the ECS service auto-scaling feature to automatically adjust the number of running tasks based on CPU or memory usage. This ensures that your application can handle traffic spikes.

4. **Logging and Monitoring**:
   - Use AWS CloudWatch Logs to monitor the logs from your ECS tasks and CodeBuild builds. Set up CloudWatch Alarms to notify you of any unusual behavior in the application or infrastructure.

### Troubleshooting

1. **Docker Image Not Found**:
   - Ensure that the Docker image is successfully built and pushed to the correct ECR repository. Verify the image URI and that the ECS task definition is pulling the correct version.

2. **Failed Build in CodeBuild**:
   - Check the `buildspec.yml` for any errors in the commands.
   - Ensure that AWS CLI commands used in the build are correctly configured with the appropriate permissions.

3. **Task Fails to Start in ECS**:
   - Verify that the task definition is configured with the correct memory, CPU, and network settings.
   - Check the IAM roles to ensure ECS has permissions to pull images from ECR and access other AWS services if necessary.

### Conclusion

This project demonstrates how to automate the deployment of a web application using AWS CodePipeline, Amazon ECS, and Docker. By integrating CodePipeline with GitHub, CodeBuild, and ECS, you can establish a continuous integration and continuous delivery (CI/CD) pipeline, ensuring that your web application is deployed efficiently with minimal manual intervention.

The setup is scalable, secure, and reliable, making it an excellent solution for deploying containerized applications using Amazon ECS and AWS Fargate. You can further extend this setup by adding security measures, performance optimizations, or additional stages for testing and validation before deployment.
