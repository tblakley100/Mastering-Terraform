Please write code in HCL to do the following:

Deploy a new VPC in AWS in the us-east-2 region.

Within the VPC, deploy a public and a private subnet and give them names to indicate which they are.

The public subnet should be associated with a custom route table containing a route to an Internet Gateway.

Create a security group that allows traffic only on ports 80 (HTTP) and 443 (HTTPS).

Deploy EC2 instance using the NGINX Bitnami AMI.

Associate the deployed NGINX instance with the created security group

Tag resources with useful information about the project.
    Tags should be common and re-purposed as needed:
    ManagedBy  = "Terraform"
    Project    = "06-resources"
    Owner = "TCB"


Files created in this folder should be provider.tf to contain the AWS provider info and should be set to create
the resources is US-EAST-2.  All networking components should be in networking.tf.  All compute resources should be
in compute.tf.