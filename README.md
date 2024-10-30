# AWS-cloud-project-three---Mesurement Points

This project showcases how to deploy lambdas in a VPC and the concept of VPC endpoints.This is an extension of AWS cloud project two. I am using 2 availability zones. For redundancy, I have created 1 private subnet in each availability zone. The lambda will be in the private subnet. The lambda will be accessing the dynamodb table via a vpc gateway endpoint. A private  REST API Gateway is also created to retrieve data from dynamodb and can only be accessed within the vpc via a vpc interface endpoint.

The architecture diagram is shown below:

![measurement_points drawio (3)](https://github.com/user-attachments/assets/bf5c83de-c1b2-4d0e-8ced-f1931ae0a057)






Steps to deploy terraform:
- cd lambdas/record_mpt
- pip3 install -r requirements.txt --target package
- cd package;zip -r ../record_mpt.zip .
- cd ..
- zip -r record_mpt.zip record_mpt.py
- Repeat the steps above for get_mpt and remember to replace all filenames to get_mpt.zip  and get_mpt.py
- Go back to the root directory.
- cd terraform
- if you are using linux terminal, please export your AWS credentials
- ./run_script.sh
