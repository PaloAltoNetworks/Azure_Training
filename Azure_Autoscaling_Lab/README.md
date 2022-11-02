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
<p align="center">
<img src="https://github.com/PaloAltoNetworks/Azure_Training/blob/main/Azure_Autoscaling_Lab/Images/webapp.png">
</p>

## What You'll Do

- Deploy the Spoke Ressource Group with ARM Template
- Configure VNET peering between spoke and hub VNET
- Create a Route Table / UDR to overwrite the default behaviour and redirect the traffic to the ILB Frontend IP

### Deploy the Spoke Ressource Group
1. To deploy the Spoke Ressource make a right click (open in new tab) on the following button [<img src="https://github.com/PaloAltoNetworks/Azure_Training/blob/main/Azure_Autoscaling_Lab/Images/deploybutton.png"/>](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FPaloAltoNetworks%2FAzure_Training%2Fmain%2FAzure_Autoscaling_Lab%2Fspokedeployment.json)
2. In the new tab you see the following
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/arm.png)
3. Change the following paramaters in the:
    
  ```
    Subscription - Leave default
    Resource group - Click on Create new with the following value <StudenName>-Workshop
    Region - change it to the region where your other ressources are deployed
    Admin Username - Chose an Admin name.
    Admin Password - chose a password
    VNET Option - Don't change
    VNET Ressource Group - Don't change
    Vm Name - change it to <StudentName>-Webserver
    Virtual Network Name - change it to <StudentName>-vnet
    Adress Prefix - Don't change
    Subnet Name - change it to <StudentName>-vnet-subnet
    Subnet Prefix - Don't change

  ```
4. After changing the paramater click on **Review + create**
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/armreview.png)
5. If the Validation passed click on **Create**                                                        
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/armcreate.png)
6. After the deployment is completed click on **Go to resource group**                                                      
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/armcomplete.png)
7. In the spoke resource group you should see the following resources deployed into it                                                      
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/spokerg.png)

### Configure VNET peering

1. On the Azure Portal select your Student Ressource Group
2. In the Resource Group select the Virtual Network. In the example is the Ressource Group called **TorstenStern-RG** and the VNET TorstenStern-vnet
   ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/studentrg.png)
3. In the VNET ressource click on top right **JSON view**
   ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/vnetjson1.png)
4. In the JSON view click on **copy to clipboard** and save it
   ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/vnetjson2.png)
5. As next go to your spoke ressource group and select the VNET inside the Resource Group
6. In the spoke VNET select on the left panel **Peerings** and then **Add**
   ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/spokevnet.png)
7. Create now the peering
   1. Peering link name - Use the same
   2. Select I know my ressource ID
   3. Enter in Ressource ID the previous copy ID from the JSON view
   4. Leave all other values as it is
   5. Click Add
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/peering.png)
8. After the peering is completed you should see the following
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/peeringcomplete.png)

### Deploy Route Table

1. Create a Route Table in your Spoke Ressource Group. Make sure you deploy it into the same Region
2. Associate the route table with Webserver Subnet
3. Create a UDR 0.0.0.0/0 that points to the ILB Frontend IP where your Firewalls behind

# Congratulations!!!

Congratulations,  you have successfully completed the following steps:
- Automated Deployment of your Hub Ressource Group with Terraform
- Deployment of your Spoke Ressource Group with ARM Template
- Redirect Traffic of your Spoke Ressource Group to the Internal Load Balancer in the Hub Ressource Group

# Lab Activity 2: Configure Firewalls and Azure 

## What You'll Do

- Configure Panorama Security Policies, NAT Policies, etc...
- Configure Webserver
- **TROUBLESHOOTING!!!!**
- **TROUBLESHOOTING!!!!**
- **TROUBLESHOOTING!!!!**
- Validate Traffic flow

### Configure Panorama

1. Login into the Panorama with your Student Account
2. In the Panorama go to the Policies tab and make sure your Student Device Group is select. Under Security Policies you should see the following rules:
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/policies.png)
3. In the Secuirty -> Pre Rules create the following rules
   1. Allow Inbound HTTP Traffic from your Public IP
   2. Allow Inbound SSH Traffic from your Public IP
   3. Deny all other traffic
4. Under the NAT section, create the following NAT Rules
   1. Inbound NAT, HTTP to the Webserver IP
   2. Inbound NAT, SSH to the Webserver IP
   3. Outbound NAT, all traffice from Trust to Untrust.



<details>
  <summary style="color:black">Expand For Details</summary>

  **Security Policies**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/security.png)

  **NAT Policies**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/nat.png)

</details>
<br/>