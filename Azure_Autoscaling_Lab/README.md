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

- Login into your Azure Account
- Download GitHub Reposetority into you Azure Environment
- Modifying Terraform code
- Deploy the Azure resources required for the lab using Terraform
- Configure Panorama
- Deploy Spoke Ressource and configure Traffic routing
- **TROUBLESHOOTING!!!!**
- Create/Update Panorama Security Policies, NAT Policies, etc...

<br/><br/>

# Activity 1: Lab Setup

## What you'll need

To complete this lab, you'll need:

- Login to Azure Portal (https://portal.azure.com) and login with your Credentials
- Download Terraform Code from GitHub
- Modify Terraform Code
- Execute Terraform Code
- Validate Deployment in Azure Portal and Panorama

1. Login in to Azure Portal (https://portal.azure.com) 
<details>
  <summary style="color:black">Expand For Details</summary>

  Azure Portal Landing Page
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/AzurePortal.png)

</details>
<br/>

2. Open Azure Cloud Shell
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/AzureCLI.png)
3. click on Create storage
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/storagecli.png)
4. Once the creation of the storage is completed you will see the following
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/cloudshell.png)
5. Download Terraform Code from GitHub
   1. in the Cloud shell execute the following command
    ```
    git clone https://github.com/PaloAltoNetworks/Azure_Training.git
    ```
    2. As output you will see the following
    ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/clonerepo.png)
6. Now brose to the Azure Autoscaling folder
   ```
   cd ./Azure_Training/Azure_Autoscaling_Lab/vmseries_scaleset
   ```
7. Rename the ```example.tfvars``` to ```terraform.tfvars``` mv ./example.tfvars terraform.tfvars
   <details>
    <summary style="color:black">Expand For Details</summary>

      **Command:**
      ``` mv ./example.tfvars terraform.tfvars```
  </details>
8. Modify the ```terraform.tfvars``` inside Cloud shell with the ```vi``` command
   1. Modify the following variables in the File
   
   ```
   resource_group_name = <StudentName>-RG
   virtual_network_name = <StudentName>-vnet
   storage_account_name = "<studentname>azurelab" #Important only lowercase allowed
   allow_inbound_mgmt_ips
   ```

   ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/example.png)

9. As next switch to the folder ```inbound_files``` and rename the ```init-cfg.sample.txt``` to ```init-cfg.txt``` using the ```mv``` command
10. Modify the ```init-cfg.txt``` inside Cloud shell with the ```vi``` command. 
    
  ```
    type=dhcp-client
    auth-key=INSTUCTOR WILL PROVIDE KEY
    panorama-server=NSTUCTOR WILL PROVIDE IP
    dgname=Student1   #Replace the Number with Studentnumber provided by the Instructor
    tplname=Workshop-Student1-ST   #Replace the Number with Studentnumber provided by the Instructor
    plugin-op-commands=panorama-licensing-mode-on
    dhcp-send-hostname=yes
    dhcp-send-client-id=yes
    dhcp-accept-server-hostname=yes
    dhcp-accept-server-domain=yes
  ```
11. Save your changes
12. Move back to the ```vmseries_scaleset``` with the command ```cd..```
13. Once you made all your changes execute the Terraform code with following commands:
    1.  ```terraform init```.
    2.  ```terraform plan```.
    3.  ```terraform apply``` once you get the prompet type ```yes```

**Important!** The complete deployment will take up to 30 Minutes after the completing the Terraform Apply. It is a good time for a break

<details>
  <summary style="color:black">Expand For Details</summary>

  **Terraform Init**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/init.png)

  **Terraform Plan**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/plan.png)

  **Terraform Apply**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/apply.png)

</details>
<br/>

14.  Once the ```terraform apply``` is completed you will see the following output
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/Complete.png)

## Validate Deployment

### What You'll Do

- Login into Panorama
- Validate Deployment

15. Login into Panorama Public IP
    1.  Instructor will Panorama IP 
    2.  Instructor will Username
    3.  Instructor will Password

16. Once you logged into the Panorama Navigate to the **Panorama** tab validate you can see your newly deployed Firewalls **(The deployment and bootstrapping process can take up to 30-45 minutes)**. If the Deployment was succesful you will see the following output in **Panorama -> Managed Devices -> Summary**
   
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/panoramacomplete.png)

17. You succesfull deployed your Environment if you can the above output


# Deploy Spoke Ressource

In this Lab part you will create a dedicated spoke ressource group with an Webserver in it to test inbound/outbound traffic flows

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
</br>
</br>
</br>