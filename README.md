# salesproject: Batch processing on AWS

## **Project Overview**
This project migrates an on-premises batch processing system to AWS, addressing challenges in **reliability, scalability, and maintainability**. The architecture leverages AWS services like **S3, Glue, and Redshift Serverless** to create a robust, serverless data pipeline. All infrastructure is provisioned using **Terraform**, ensuring consistency and reproducibility.


![image](https://github.com/user-attachments/assets/4e94dc60-3204-4549-952a-fb3a63843dc0)


---

## **Project Structure**
The repository contains the following Terraform configuration files:

1. **`backend.tf`**: Configures the S3 backend for storing the Terraform state file.
2. **`vpc.tf`**: Defines the VPC, subnets, Internet Gateway, NAT Gateway, Route Tables, and Security Groups.
3. **`iamrole.tf`**: Creates IAM roles and policies for secure service interactions.
4. **`redshift.tf`**: Provisions Redshift Serverless Workgroup, Namespace, and associated configurations.
5. **`glue.tf`**: Configures Glue jobs, connections, and crawlers for data processing.
6. **`providers.tf`**: Specifies the required Terraform providers and versions.
7. **`s3.tf`**: Creates S3 buckets for raw data, processed data, and backups.
8. **`variable.tf`**: Defines input variables for reusable configurations.
9. **`sns.tf`**: Sets up SNS topics for error notifications.

---

## **Features**
- **Serverless Architecture**: Uses managed services like Redshift Serverless and Glue for scalability and reduced operational overhead.
- **Automated Data Pipeline**: Glue jobs are scheduled to run hourly to process new data.
- **Error Handling**: SNS sends email notifications for Glue job failures.
- **Infrastructure as Code**: All resources are deployed using Terraform, ensuring consistency and reproducibility.
- **Security**: Redshift is deployed in a private subnet, and credentials are stored securely in Secrets Manager.

---

## **Prerequisites**
1. **AWS Account**: Ensure you have an active AWS account.
2. **Terraform**: Install Terraform on your local machine.
3. **AWS CLI**: Configure AWS CLI with your credentials (access key and secret key.

---

## **Setup Instructions**
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/HakeemSalaudeen/Batch-processing-on-AWS_salesproject.git
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Review Variables**:
   Update the `variable.tf` file with your specific configurations (Redshift credentials).

4. **Deploy Infrastructure**:
   ```bash
   terraform apply
   ```

5. **Verify Deployment**:
   - Check the AWS Management Console to ensure all resources are created.
   - Test the data pipeline by uploading a file to the S3 bucket.

---

## **Code Quality**
- **Code Linting**: All Terraform files are formatted using `terraform fmt` for consistency.
- **Best Practices**: Follows Terraform best practices for modularity and readability.

---

## **Monitoring and Maintenance**
- **CloudWatch**: Use CloudWatch to monitor Glue jobs, Redshift performance, and system logs.
- **SNS Alerts**: Configure SNS topics to receive notifications for failures.

---

## **Contributing**
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Submit a pull request with a detailed description of your changes.

---

**Happy Coding!** 🚀
