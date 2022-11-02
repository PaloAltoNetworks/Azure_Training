![](https://lh4.googleusercontent.com/18oAPNp1uzZ6qY6bJxg2fWYWUEV-pQzNa_dSAqSp2lEjdg4hlEyLlQYc1OAowXxSqrp5Bk9iXRYOu-mECiqSr-gzo56d8QAh97VrfTbwX4uYN2ABB8BKM9XZK2mSzSXDN3qeHzp8xRsNHmALdeNEPiw)

![](https://lh3.googleusercontent.com/_-_DS9VDmI1QhI68JOiMchoWH7Bo1fqYn0qbD9Y24KH1T1zAG272HQy7cetrLxw3buJYbJEcj7TMjxv0CeWt-z1p4a3hl1FrNKPMROVo6L42XLIWFkjw_yPGlVTzhcPz1v2IB2JCUXMrAl4p2n9kbnY)  

# Palo Alto Networks Azure Autoscaling Lab Guide

<br/><br/>

# Overview

The goal of this Lab is to take you through the experience of deploying the Palo Alto Networks VM-Series on Microsoft Azure to protect your Cloud Native Applications. This workshop will take you through the three step process of using the service - Automate, Deploy and Secure.

As part of the workshop you will learn to deploy the VM-Series on a Common model with Autoscaling.

<br/><br/>

# Environment Overview

**ADD PICTURE**

For this workshop we have automated the deployment of the lab environment and you will using an existing Panorama. The credentials to the Panorama will be provided during the Workshop. This is achieved via Terraform, that you will be launching as part of the lab over the Azure CLI.

<br/>

## What You'll Do

- Deploy the Azure resources required for the lab using Terraform
- wwwww
- www
- www
- www
- www
- www

<br/><br/>

# Activity 0: Validate Azure Access

At first go to https://portal.azure.com and login with your credentials. Palo alto Networks Employees with the Corporate Credentials and Externals with the Credntials that they used during the Pre-Req Lab.

# Activity 1: Lab Setup

## What you'll need

To complete this lab, you'll need:



<br/>

# Deploy Spoke Ressource

## What You'll Do

- Deploy the Spoke Ressource Group with ARM Template
- Create a Route Table / UDR to overwrite the default behaviour and redirect the traffic to the ILB Frontend IP
- Update Webserver and Install Apache2 Webserver
- Update Index.Html
- Test inbound/outbound traffic

In this part, We will Deploy a single Linux Server in a dedicated Resource Group
<p align="center">
<img src="https://github.com/PaloAltoNetworks/Azure_Training/blob/main/Azure_Autoscaling_Lab/Images/webapp.png">
</p>

[<img src="https://github.com/PaloAltoNetworks/Azure_Training/blob/main/Azure_Autoscaling_Lab/Images/deploybutton.png"/>](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FPaloAltoNetworks%2FAzure_Training%2Fmain%2FAzure%20Advanced%20Lab%2Fspokedeployment.json)
[<img src="https://github.com/PaloAltoNetworks/Azure_Training/blob/main/Azure_Autoscaling_Lab/Images/deploybutton.png"/>](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/spokedeployment.json)
</br>
</br>
</br>


## Create Cloud NGFW configurations with Terraform

```
cd ~/ps-lab-aws-cloud-ngfw/automation-lab/cloudngfw
```

- Edit the main.tf and add the ARN of your IAM role on line 14 under lra_arn

```
lrn_arn = "arn:aws:iam::5271******:role/CloudNGFWRole"
```

- Add your QwikLabs AWS account ID role on line 20 for `account_id`

```
resource "cloudngfwaws_rulestack" "example" {
  name        = "terraform-rulestack"
  scope       = "Local"
  account_id  = "527167305681" ## Replace with your Qwiklabs account ID
  description = "Made by Terraform"
  profile_config {
    anti_spyware = "BestPractice"
  }
}
```

- terraform init and apply and verify your resources were created

## Create your own rule using the address groups

- Reference the [Terraform Provider documentation](https://registry.terraform.io/providers/PaloAltoNetworks/cloudngfwaws/latest/docs/resources/security_rule) for creating a `cloudngfwaws_security_rule`

- Edit main.tf and add a new resource to allow traffic from the attack-vpc to the vuln-vpc
- Your security rule resource should reference the prefix lists using the terraform resources

Hint for source and destination syntax
```
  source {
        prefix_lists = [cloudngfwaws_prefix_list.attack-vpc.name]
  }
  destination {
    prefix_lists = [cloudngfwaws_prefix_list.vuln-vpc.name]
  }
```

After you have added the resource run terraform apply and validate it is created successfully

# Congratulations!!!

Congratulations,  you have successfully completed this Hands ON lab. As part of this lab you went through the process to SUBSCRIBE to Palo Alto CloudNGFW Service on AWS. You familiarize yourself with ways to DEPLOY the service to protect your application on AWS. And finally, you learned how to SECURE your environment with ‘Best Practices’ security profiles from Palo Alto Networks.

<br/><br/>

# Lab Teardown

<br/>

## Unsubscribe from CloudNGFW Service

1. Navigate to the AWS Marketplace console. You can search for ‘market’ and click on ‘AWS Marketplace Subscriptions’.

![](https://lh4.googleusercontent.com/O5hgxnAoeoECZQ08ZRhA8gMvqFo2O3tpKKJkUzoAkVKmrHpmwvI9KXMeZdpawJgbu_-fF-dx0H6iQzZ4W4JJTt9N0DO9mgPc3MeLM2QYQJlS-O_rkE1wzGvZ9gU8WfkiOnEk0OEo67i774T_6oEy10A)

2. Click on ‘Cloud NGFW PAY-as…” service

![](https://lh3.googleusercontent.com/4aTSAiGs0nqdYUEYDuY-WaxvkjKc1xSGLsdyZpdTtdS9O6pzgbne3NUMTnlLhz7XHOcaJmOij_KlaEYbu6WaZzQI3E7aratcAcg2muuij9dGayEgCkjP7B2gvHkJL0EoiidW6-0almiUUi36PiezyQ4)

3. Click on ‘Action’ at the bottom of the page and click on ‘Cancel Subscription’

![](https://lh5.googleusercontent.com/G2u3Fh6Vcs8N3ropb_m1u5VSmqIfH-4Zc4CILY-F3R6VkwDYpXXy9SoxvA7rA8ZutG3m402tjmpp7_Ds-XCE8ktnn6xCSKryy3dKBCuP9jQKddB29op-XMJzmX7aBR_ktDLx2iDyrPJL32yLREsx1qI)

4. Select the checkbox to acknowledge and click on ‘Yes, cancel subscription’ 

![](https://lh3.googleusercontent.com/IUAPi4B9B-nT9da7P3P9SnvXiW014vR7FsRuAPy-vcpsQ7amLz9kjNRAmHxioV2SVqafs-c1sdeNCj7nkSfiPiGwYIwCXKUOdI_QEHRvbnbCEi-PzreZzT3nuVaBCG5jhU2yOHCnXKFUnKSqufJai2g)

![](https://lh6.googleusercontent.com/31pCarQ0Gty06az_aEBt0adXKWOjT_yhnYR33kug07SV73bZS1zUMotlqmuwTj5Cowipi7lcoI5atCx3OfFfSGxlBPyi3JmEFALcqPYAVqrg9J72m1esBhnH8AQcfuW1DVX59VSxJBNJcJD68U9Gb40)

5. You have successfully unsubscribed from the CloudNGFW service.

<br/><br/>

# Resources and Reference

Here are links to some of the resources for CloudNGFW service.

- [eBook: Cloud NGFW - Palo Alto Networks](https://www.paloaltonetworks.com/resources/ebooks/cloud-ngfw)
- [Cloud NGFW: Solution Brief - Palo Alto Networks](https://www.paloaltonetworks.com/resources/whitepapers/cloud-ngfw-solution-brief)
- [Cloud NGFW for AWS Datasheet - Palo Alto Networks](https://www.paloaltonetworks.com/resources/datasheets/cloud-ngfw-for-aws)
- [AWS Marketplace: Palo Alto Networks Cloud NGFW (Next-Generation Firewall) Pay-As-You-Go](https://aws.amazon.com/marketplace/pp/prodview-sdwivzp5q76f4#:~:text=7%2DDay%20Free%20Trial%3A%20Click,Get%20started%20today)!
- [Getting Started with Cloud NGFW for AWS](https://docs.paloaltonetworks.com/cloud-ngfw/aws/cloud-ngfw-on-aws/getting-started-with-cloud-ngfw-for-aws)

<br/><br/>

# Troubleshooting

<br/>

## Issues with the Lab Setup

In case you run into any errors during the execution of the setup script the deployment is a failure, you can follow the below steps;
- Run the setup script again. This should take care of any temporary issues like timeouts, etc.
- If you still see an error, reach out to your Lab Administrator for further steps.
- You can also open the _setup.sh_ script in an editor and attempt all the steps one by one in the same order as in the script from a separate terminal.

<br/>

## Docker related Issues

If the docker list command errors out or does not show the containers, use the following commands to start containers manually.

1. Try restarting the instance
2. If the att-svr container is not coming up, use this command to start it manually. At the command prompt, execute this command:

```
sudo docker container run -itd --rm --name att-svr -p 8888:8888 -p 1389:1389 us.gcr.io/panw-gcp-team-testing/qwiklab/pcc-log4shell/l4s-demo-svr:1.0
```

3. If the vul-app-1 container is not up, use this command to start it. At the command, prompt execute this command:

```
sudo docker container run -itd --rm --name vul-app-1 -p 8080:8080 us.gcr.io/panw-gcp-team-testing/qwiklab/pcc-log4shell/l4s-demo-app:1.0
```
