**Vivid Arts Studio**
The Vivid Arts Studio project is a web application that allows users to upload images, process them using AWS Lambda, and store the results in an Amazon S3 bucket. 
This repository contains the necessary scripts and configurations to deploy and run the application.

**Features**
**Image Upload:** Users can upload images through a web interface.
**Serverless Image Processing:** AWS Lambda is used to process uploaded images (e.g., convert to black and white).
**Storage:** Processed images are stored in an Amazon S3 bucket.
**Dockerized Application:** The Flask application is containerized using Docker for easy deployment.

**Files**

**app.py:** Main Flask application for handling image uploads and triggering Lambda functions.

**dockerfile:** Dockerfile for creating a Docker container for the Flask application.

**image_processing_lambda.py:** AWS Lambda function script for processing images.

**lambda.tf:** Terraform configuration for AWS Lambda, IAM role, and S3 bucket notification.

**policy.tf:** Terraform configuration for creating an IAM policy and attaching it to a user.

**S3bucket.tf:** Terraform configuration for creating an AWS S3 bucket.

**Usage**
**AWS Credentials:**

Replace placeholder values in app.py and lambda.tf with your AWS access key, secret key, and region.

**Docker Container:**

Build the Docker container using the provided Dockerfile.

**Infrastructure Deployment:**

Use Terraform to deploy the infrastructure (lambda.tf, policy.tf, S3bucket.tf).

**Run the Application:**

Start the Flask application in the Docker container.
Access the Application:

Use the provided endpoint to access the application, upload images, and view processed results.
Contribute:

Explore the code, contribute enhancements, and make the project even better!
