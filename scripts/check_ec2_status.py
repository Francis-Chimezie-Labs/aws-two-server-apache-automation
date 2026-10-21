import os
import boto3

# AWS region
region = os.getenv("AWS_REGION", "us-east-2")

# Connect to AWS EC2
ec2 = boto3.client("ec2", region_name=region)

# Get EC2 instance IDs from environment variables
instances = {
    "Apache Server 1": os.getenv("APACHE_SERVER_1_ID"),
    "Apache Server 2": os.getenv("APACHE_SERVER_2_ID")
}

for server_name, instance_id in instances.items():

    if not instance_id:
        print(f"{server_name}: Instance ID not configured.")
        continue

    response = ec2.describe_instances(
        InstanceIds=[instance_id]
    )

    state = response["Reservations"][0]["Instances"][0]["State"]["Name"]

    if state == "running":
        print(f"{server_name} is RUNNING.")

    elif state == "stopped":
        print(f"{server_name} is STOPPED.")

    else:
        print(f"{server_name} is currently: {state}")