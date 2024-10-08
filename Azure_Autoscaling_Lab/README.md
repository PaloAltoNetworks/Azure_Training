![](https://lh4.googleusercontent.com/18oAPNp1uzZ6qY6bJxg2fWYWUEV-pQzNa_dSAqSp2lEjdg4hlEyLlQYc1OAowXxSqrp5Bk9iXRYOu-mECiqSr-gzo56d8QAh97VrfTbwX4uYN2ABB8BKM9XZK2mSzSXDN3qeHzp8xRsNHmALdeNEPiw)

![](https://lh3.googleusercontent.com/_-_DS9VDmI1QhI68JOiMchoWH7Bo1fqYn0qbD9Y24KH1T1zAG272HQy7cetrLxw3buJYbJEcj7TMjxv0CeWt-z1p4a3hl1FrNKPMROVo6L42XLIWFkjw_yPGlVTzhcPz1v2IB2JCUXMrAl4p2n9kbnY) 

- [1. Palo Alto Networks Azure Autoscaling Lab Guide](#1-palo-alto-networks-azure-autoscaling-lab-guide)
- [2. Overview](#2-overview)
  - [2.1. Environment Overview](#21-environment-overview)
  - [2.2. What You'll do in the whole Lab](#22-what-youll-do-in-the-whole-lab)
- [3. Deploy Panorama](#3-deploy-panorama)
  - [3.1. What you'll do](#31-what-youll-do)
  - [3.2. Deploy via Azure Marketplace](#32-deploy-via-azure-marketplace)
  - [3.3 Create Deployment Profile in Customer Support Portal (CSP)](#33-create-deployment-profile-in-customer-support-portal-csp)
  - [3.4 Provision Panorama Serialnumber](#34-provision-panorama-serialnumber)
  - [3.5 License Panorama](#35-license-panorama)
  - [3.6 Configure Software License Plugin](#36-configure-software-license-plugin)
- [4. Deploy Azure environment](#4-deploy-azure-environment)
  - [4.1. What you'll need](#41-what-youll-need)
  - [4.2. Validate Deployment](#42-validate-deployment)
    - [4.2.1. What You'll Do](#421-what-youll-do)
- [5. Deploy Spoke Ressource](#5-deploy-spoke-ressource)
  - [5.1. What You'll Do](#51-what-youll-do)
    - [5.1.1. Deploy the Spoke Ressource Group](#511-deploy-the-spoke-ressource-group)
    - [5.1.2. Configure VNET peering](#512-configure-vnet-peering)
    - [5.1.3. Deploy Route Table](#513-deploy-route-table)
- [6. Congratulations!!!](#6-congratulations)
- [7. Lab Activity 2: Configure Panorama, Firewalls and Azure](#7-lab-activity-2-configure-panorama-firewalls-and-azure)
  - [7.1. Configure Panorama Template for VM-Series.](#71-configure-panorama-template-for-vm-series)
    - [7.1.1 Template / Interface Configuration](#711-template--interface-configuration)
    - [7.1.2 Template / Virtual Router Configuration](#712-template--virtual-router-configuration)
  - [7.2 Configure Panorama Device Group for VM-Series.](#72-configure-panorama-device-group-for-vm-series)
  - [7.3 Configure Webserver](#73-configure-webserver)
  - [7.4 Troubleshooting 1](#74-troubleshooting-1)
  - [7.5 Traffic Validation](#75-traffic-validation)
  - [7.6 Autoscaling Test](#76-autoscaling-test)
- [8. Congratulations!!!](#8-congratulations)
- [9. Proof Lab completion](#9-proof-lab-completion)
- [10. Useful information](#10-useful-information)
  - [10.1. Firewall Password/Username](#101-firewall-passwordusername)
  - [10.2. Firewall IP Information](#102-firewall-ip-information)
- [11. Cheating Section](#11-cheating-section)
  - [11.1. Troubleshooting](#111-troubleshooting)

# 1. Palo Alto Networks Azure Autoscaling Lab Guide

<br/><br/>

# 2. Overview

The goal of this Lab is to take you through the experience of deploying the Palo Alto Networks VM-Series on Microsoft Azure to protect your Cloud Native Applications. This workshop will take you through the three step process of using the service - Automate, Deploy and Secure.

As part of the workshop you will learn to deploy the VM-Series on a Common model with Autoscaling.

<br/><br/>

## 2.1. Environment Overview
![Azure Ref Arch - Copy of Transit Common](https://user-images.githubusercontent.com/30934288/233354360-357df77a-0acc-409f-89e8-cd8b7b692a33.png)

For this workshop we have automated the deployment of the lab environment and you will create a first a Panorama before we deploy the Environment. The Panorama will not be directly connected to the Azure Environment what you deploy in a later stage. This is achieved via Terraform, that you will be launching as part of the lab over the Azure CLI.

<br/>

## 2.2. What You'll do in the whole Lab

- Creat a Flex License Deployment profile in the CSP Portal
  - Standard CDSS
  - 3 x VM-300 with 4 vCPUs
  - Panorama Serial Number
- Deploy Panorama in any Public Cloud Provider.
  - Make sure it has Internet Conectivity
  - License the Panorama
  - Basic Configuration of the Panorama
    - Configure Software License Plugin
    - Create Template / Template Stack and Device Group
  - Validate the Deployment
- Login into Your Azure Portal
- Download GitHub Reposetority into you Azure Environment
- Modifying Terraform code
- Deploy the Azure resources required for the lab using Terraform
- Deploy Spoke Ressource and configure Traffic routing
- **TROUBLESHOOTING!!!!**
- Create/Update Panorama Security Policies, NAT Policies, etc...

<br/><br/>

# 3. Deploy Panorama
In this part you will deploy a single Panorama with a Public IP to guarantee internet connectivity and do a basic configuration of the Panorama. In the next step you will install the Software License plugin and configure it.

## 3.1. What you'll do
- Login to Azure
- Deploy Panorama via Azure Marketplace
- Configure Panorama
- Create Deployment Profile in CSP (if you have access)
- Configure Software License Plugin
- Troubleshooting Panorama connectivity


## 3.2. Deploy via Azure Marketplace
1. Login in to Azure Portal (https://portal.azure.com) 
![AzurePortal](https://user-images.githubusercontent.com/30934288/233334030-b7fb093a-5cec-4083-9779-3bf817b0c3ef.png)
2. In the Home screen click on "+ Create new ressource"
   ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/create.png)
3. In the Search the Marketplace box, enter **Palo Alto Networks Panorama**, and then click the Palo Alto Networks Panorama tile.
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/panomarketplace.png)
4. In the Settings page for the Panorama add the following
   1. Create a new Ressoure Group (Workshop-StudentNAME)
   2. Add a Panorama Name (Panorama-StudentNAME)
   3. Choose a region
   4. Change the instance type to Standard_D16s_v3
   5. Change it to Username/Password and provide a proper Username and Password
   6. Keep the all other settings for now as default
   7. Create a Public IP
   8. Click Next until "Review and Create"
   9. See below <br/>
![Panorma Marketplace](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/output.gif)
5. The Deployment can take up to 5-15 Minutes depends which region you choose. You should see the following if the deployemt was successful
   ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/panorama-success.png)
6. Click on "Go to Ressource"
<br/>
<details>
    <summary style="color:black">Expand For Details for Panorama troubleshooting</summary>
Did you check the Panorama NSG if it allows Panorama managment inbound traffic on the dedicated Panorama ports?
  </details>
<br/>
<br/>

## 3.3 Create Deployment Profile in Customer Support Portal (CSP)
Here you will create a dedicated Flex Credits Deployment Profile for Lab. 

<br/>
<div style="border: 1px solid #ddd; padding: 10px; border-radius: 5px; background-color: #f9f9f9;">
  <strong>Note:</strong> If you don't have access to the 132205 - Palo Alto Networks - Professional Services CSp Subscription will the Instructor provide you a Panorama Servial Number and a Auth Code for the Software Firewall
</div>
<br/>

1. Login with your PANW Credentials at the Customer Support Portal https://support.paloaltonetworks.com/
2. In the Support Portal Change the Account Seletor to 132205 - Palo Alto Networks - Professional Services
   ![Screenshot 2023-04-28 at 10 27 55](https://user-images.githubusercontent.com/30934288/235103488-dec40a3b-8b52-4e86-b47f-63a5ea94399e.png)
3. On the Support Portal Page on the left side go to Assets -> Software NGFW Credits
4. On the Prisma NFGW Credits Pool click on Create Deployment Profile
   ![Screenshot 2023-04-28 at 10 34 00](https://user-images.githubusercontent.com/30934288/235103582-e0457306-91e1-41f7-9810-89e2e684e9df.png)
5. Select the following as shown on the picture below and click Next<br/>
   ![Screenshot 2023-04-28 at 10 35 37](https://user-images.githubusercontent.com/30934288/235103668-d6dca65f-7ad0-420f-89dc-4fdb0adadc14.png)
6. In the Deployment Profile use the following and replace Instructor-Lab under "Profile Name" with "YourName-workshop"
   ![Screenshot 2023-04-28 at 10 37 12](https://user-images.githubusercontent.com/30934288/235103752-1f1c0959-87a5-4654-bb76-03d472fad2b6.png)
7. Click "Create Deployment Profile"
8. Verify that your Deployment Profile is successfully created
   ![Screenshot 2023-04-28 at 10 40 09](https://user-images.githubusercontent.com/30934288/235103850-9cd1b2d9-f585-436a-bb9a-97c1d21a9b39.png)

## 3.4 Provision Panorama Serialnumber

1. Login with your PANW Credentials at the Customer Support Portal https://support.paloaltonetworks.com/
2. On the Support Portal Page on the left side go to Assets -> Software NGFW Credits -> Details
   ![Screenshot 2023-05-08 at 13 57 29](https://user-images.githubusercontent.com/30934288/236821175-3277edbc-d472-4e9f-b428-1831ba25b73b.png)
3. Now Search for your previous created Azure Deployment Profile [here](##34-create-deployment-profile-in-customer-support-portal-csp)
4. Click on the 3 dots and on **Provision Panorama**
   ![Screenshot 2023-05-08 at 14 01 29](https://user-images.githubusercontent.com/30934288/236821233-4bd1203c-dfb7-4c7f-8a7b-6c332d5da645.png)
5. In the new window click on **Provision** <br/>
   ![Screenshot 2023-05-08 at 14 03 38](https://user-images.githubusercontent.com/30934288/236821269-23c45ffb-645d-4c3f-937a-22dff931cd8f.png)
6. Once the window is closed repeat the steps from step 3
   ![Screenshot 2023-05-08 at 14 01 29](https://user-images.githubusercontent.com/30934288/236821410-0e3495d1-2245-41ff-804c-6604ed03abe5.png)
7. Now you can see a Serialnumber in the Window. Copy and Paste the Serialnumber
   ![Screenshot 2023-05-08 at 14 06 13](https://user-images.githubusercontent.com/30934288/236821362-29f37909-874f-44ce-8f5a-8976f2d6c735.png)
8. You can close the window by clicking **Cancel**

## 3.5 License Panorama
As next you have to License the Panorama with the previous created Serialnumber from the Deployment Profile.

1. Login to your Panorama https://[Public-IP]
2. Copy the the Serialnummber you create on the CSP Portal and enter it under the Panorama Tab -> Setup -> Management -> General Settings
   ![Screenshot 2023-05-03 at 10 40 41](https://user-images.githubusercontent.com/30934288/235870102-b21ae1db-3df3-451e-b97d-177fb0aac110.png)
3. Hit OK and reload the UI. Check if a pending commit on the Panorama is needed. If yes, commit to Panorama.
4. In the Panorama check if you can see a Serialnummber is associated to it
   ![Screenshot 2023-04-28 at 10 42 49](https://user-images.githubusercontent.com/30934288/235103168-d62230df-38c1-43e4-862d-7fb8c52a9d1a.png)

<br/>

## 3.6 Configure Software License Plugin
Here you will configure the Software License Plugin in your Panorama to perform the next activities. For that you need your information from the CSP
Follow the following guide to configure your Plugin. https://docs.paloaltonetworks.com/vm-series/11-0/vm-series-deployment/license-the-vm-series-firewall/use-panorama-based-software-firewall-license-management

The Instructor will provide you during the Lab the API License Key.

<details>
    <summary style="color:black">Expand For Details</summary>

1. Bootstrap Definitions
   ![Screenshot 2023-04-28 at 10 50 19](https://user-images.githubusercontent.com/30934288/235103950-762c9686-da63-4eed-90c1-74b34de9f72d.png)
2. License Managers
   ![Screenshot 2023-04-28 at 10 50 30](https://user-images.githubusercontent.com/30934288/235104006-bf031287-b7e1-4595-ab60-380e0b3a7123.png)
  </details>

After you commited your changes your should see all information by selecting "Show Bootstrap Paramaters" under License Managers
![Screenshot 2023-04-28 at 10 52 55](https://user-images.githubusercontent.com/30934288/235104048-89b25d7b-b43c-4c8d-949b-241a0bf4b649.png)
<br/><br/>

# 4. Deploy Azure environment

## 4.1. What you'll need

To complete this lab, you'll need:

- Login to Azure Portal (https://portal.azure.com) and login with your Credentials
- Download Terraform Code from GitHub
- Modify Terraform Code
- Execute Terraform Code
- Validate Deployment in Azure Portal and Panorama

1. Login in to Azure Portal (https://portal.azure.com) 
![AzurePortal](https://user-images.githubusercontent.com/30934288/233334030-b7fb093a-5cec-4083-9779-3bf817b0c3ef.png)
2. Open Azure Cloud Shell
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/AzureCLI.png)
3. click on Create storage. In some case it will not create a Storage Account. In that case click in "Show advanced settings" and create your own storage account.
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
6. Now browse to the Azure Autoscaling folder
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
   1. Modify the following variables in the File.
   
   ```
   resource_group_name = <StudentName>-RG
   virtual_network_name = <StudentName>-vnet
   storage_account_name = "<studentname>azurelab" #Important only lowercase allowed
   ```

   ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/example.png)

9.  As next switch to the folder ```inbound_files``` and rename the ```init-cfg.sample.txt``` to ```init-cfg.txt``` using the ```mv``` command
10. Modify the ```init-cfg.txt``` inside Cloud shell with the ```vi``` command. Make sure you added the same name of the Device Group and Template Stack you created in your Panorama. 
    
  ```
    type=dhcp-client
    auth-key=[Information found in SoftwareNGFW Plugin]
    panorama-server=[PANORAMA PUBLIC IP]
    dgname=Student1   #[Information found in SoftwareNGFW Plugin]
    tplname=Workshop-Student1-ST   #[Information found in SoftwareNGFW Plugin]
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

14.  Once the ```terraform apply``` is completed you will see the following output<br/>
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/Complete.png)

15. To get the Firewall password and Username run the following commands and copy it to a notepad<br/>
    ```terraform outout username```<br/>
    ```terraform output password```

## 4.2. Validate Deployment

### 4.2.1. What You'll Do

- Login into Panorama
- Validate Deployment

15. Login into Panorama Public IP
16. Once you logged into the Panorama Navigate to the **Panorama** tab validate you can see your newly deployed Firewalls **(The deployment and bootstrapping process can take up to 30-45 minutes)**. If the Deployment was succesful you will see the following output in **Panorama -> Managed Devices -> Summary**
   
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/panoramacomplete.png)

17. You succesfull deployed your Environment if you can see the above output


# 5. Deploy Spoke Ressource

In this Lab part you will create a dedicated spoke ressource group with an Webserver in it to test inbound/outbound traffic flows
<p align="center">
<img src="https://github.com/PaloAltoNetworks/Azure_Training/blob/main/Azure_Autoscaling_Lab/Images/webapp.png">
</p>

## 5.1. What You'll Do

- Deploy the Spoke Ressource Group with ARM Template
- Configure VNET peering between spoke and hub VNET
- Create a Route Table / UDR to overwrite the default behaviour and redirect the traffic to the ILB Frontend IP

### 5.1.1. Deploy the Spoke Ressource Group
1. To deploy the Spoke Ressource make a right click (open in new tab) on the following button 
   [<img src="https://github.com/PaloAltoNetworks/Azure_Training/blob/main/Azure_Autoscaling_Lab/Images/deploybutton.png"/>](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FPaloAltoNetworks%2FAzure_Training%2Fmain%2FAzure_Autoscaling_Lab%2Fspokedeployment.json)
2. In the new tab you see the following
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/arm.png)
1. Change the following paramaters in the:
    
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

<br/>

### 5.1.2. Configure VNET peering

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
<br/>

![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/peering.png)
8. After the peering is completed you should see the following
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/peeringcomplete.png)

### 5.1.3. Deploy Route Table

1. Create a Route Table in your Spoke Ressource Group. Make sure you deploy it into the same Region
2. Associate the route table with Webserver Subnet
3. Create a UDR 0.0.0.0/0 that points to the ILB Frontend IP where your Firewalls behind

# 6. Congratulations!!!

Congratulations,  you have successfully completed the following steps:
- Deployed Panorama through Azure Marketplace
- Automated Deployment of your Hub Ressource Group with Terraform
- Deployment of your Spoke Ressource Group with ARM Template
- Redirect Traffic of your Spoke Ressource Group to the Internal Load Balancer in the Hub Ressource Group

<br/>

# 7. Lab Activity 2: Configure Panorama, Firewalls and Azure 
In this Lab activity you will configure on the Panorama the Device Group, Template to make sure the VM-Series is configured, setting up the Webserver, Traffic Validation, Autoscaling Test, and some Troubleshooting activities 

## 7.1. Configure Panorama Template for VM-Series.
Here you will configure the previous create Template on Panorama.

### 7.1.1 Template / Interface Configuration
1. Login to you Panorama and select in the Top bar under Templates "Network"
   ![Screenshot 2023-05-08 at 08 32 10](https://user-images.githubusercontent.com/30934288/236754423-41cc626e-4425-4f8d-9f18-36eb044050f1.png)
2. Select on left bar "Interfaces" and click "Add Interface"
3. Use the following seetings for the Untrust Interface (Ethernet1/1)
   1. Slot: Slot 1
   2. Interface Name: Ethernet1/1
   3. Interface Type: Layer3
   4. Config Tab
      1. Virtual Router: Untrust-VR (Create a new)
      2. Security Zone: Untrust (Create a new)
      ![Screenshot 2023-05-08 at 08 37 14](https://user-images.githubusercontent.com/30934288/236754504-1f4b2069-53ac-4c3b-a530-33dc0297edab.png)
   5. IPv4 Tab
      1. DHCP Client
      2. Unselect "Automatically create default route pointing to default gateway porivdd by server"
      ![Screenshot 2023-05-08 at 08 37 25](https://user-images.githubusercontent.com/30934288/236754556-53d8e98e-3c08-4360-881f-4ee75df617ad.png)
   6. Advanced Tab
      1. Management Profile (Create a new profile). See settings below
         ![Screenshot 2023-05-08 at 08 38 00](https://user-images.githubusercontent.com/30934288/236754603-e3614186-1842-4971-9f94-16434e7ea853.png)
4. Once you completed the steps cick Ok.
5. Use the following settings for the Trust Interface (Ethernet1/2)
   1. Slot: Slot 1
   2. Interface Name: Ethernet1/2
   3. Interface Type: Layer3
   4. Config Tab
      1. Virtual Router: Trust-VR (Create a new)
      2. Security Zone: Trust (Create a new)
      ![Screenshot 2023-05-08 at 08 56 54](https://user-images.githubusercontent.com/30934288/236756039-e82b9db5-2445-45c5-af5b-f3017274adec.png)
   5. IPv4 Tab
      1. DHCP Client
      2. Unselect "Automatically create default route pointing to default gateway porivdd by server"
      ![Screenshot 2023-05-08 at 08 57 03](https://user-images.githubusercontent.com/30934288/236756078-bce5fa4d-6c3a-496d-9fe7-e60cf7d98ba3.png)
   6. Advanced Tab
      1. Management Profile: Select the previous create the profile
      ![Screenshot 2023-05-08 at 08 57 17](https://user-images.githubusercontent.com/30934288/236756114-932b05c8-0e76-4dbc-9fe4-641ae870120d.png)
6. Once you completed the steps cick Ok.
7. You should see the following now on your Panorama
   ![Screenshot 2023-05-08 at 08 57 31](https://user-images.githubusercontent.com/30934288/236756139-85b68421-7c14-48b8-9dad-ed6bbeabdd3a.png)

### 7.1.2 Template / Virtual Router Configuration
1. Login to you Panorama and select in the Top bar under Templates "Network"
   ![Screenshot 2023-05-08 at 08 32 10](https://user-images.githubusercontent.com/30934288/236754423-41cc626e-4425-4f8d-9f18-36eb044050f1.png)
2. Select on left bar "Virtual Routers"
3. Select at first the previous created "Untrust-VR"
   1. Under "Static Routes" create the following routes. **Please make sure you provide the correct next hop IP Address and using the correct spoke vnet CIDR block. The values below are only examples and based on the Instructor Lab configuration**
   ![Screenshot 2023-05-08 at 09 20 12](https://user-images.githubusercontent.com/30934288/236762878-6b9997af-5949-47ff-b9ff-efca62627f9f.png)
   2. Once Completed the configuration click **OK**
4. As next select the the previous created "Trust-VR" 
   1. Under "Static Routes" create the following routes. **Please make sure you provide the correct next hop IP Address and using the correct spoke vnet CIDR block. The values below are only examples and based on the Instructor Lab configuration**
   ![Screenshot 2023-05-08 at 09 26 55](https://user-images.githubusercontent.com/30934288/236762921-a87f1f5e-091b-4872-accc-5b4c5b4f4e9d.png)
<br/>

## 7.2 Configure Panorama Device Group for VM-Series.
Here you will configure the previous create Device Group on Panorama.

1. In the Panorama go to the Policies tab and make sure your Student Device Group is select. Under Security Policies you should see the following rules:
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/policies.png)
2. In the Secuirty -> Pre Rules create the following rules
   1. Allow Inbound HTTP Traffic from your Public IP
   2. Allow Inbound SSH Traffic from your Public IP
   3. Deny all other traffic
3. Under the NAT section, create the following NAT Rules
   1. Inbound NAT, HTTP to the Webserver IP
   2. Inbound NAT, SSH to the Webserver IP
   3. Outbound NAT, all traffice from Trust to Untrust.
4. Commit your changes to the Panorama
5. Push your changes to your Firewalls

<details>
  <summary style="color:black">Expand If you need Help</summary>

  **Security Policies**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/security.png)

  **NAT Policies**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/nat.png)

</details>
<br/>

6. Once you completed all steps Push your changes to the Panorama and Firewalls. check if your Firewalls are all **In Sync**

## 7.3 Configure Webserver

1. Go to your Spoke ressource group
2. Enable Boot diagnostics on the Webserver
   1. Create new Storage account or use an existing
3. Go to the Serial console of your Webserver
   1. Use your Credentials you setup in the previous step
4. Please run the following commands to update the Webserver and to isntall Apache 2 Webserver
   1. ```sudo apt-get update```
   2. ```sudo apt-get install apache2 -y```
5. Are the commands working?
6. Can you see the trafic is flowing through the firewall? **NO? WHY?**

## 7.4 Troubleshooting 1

It looks like the no traffic is working! The question is now why it isn't working and which Troubleshooting steps you do, to find the root cause.

Here some thinkgs you should have a look now.

1. Can you see the Traffic in the Firewall?
2. Can you ping the Firewall from the Webserver and reverse?
3. Are the Healthprobes are working? Load Balancer Metrics
4. Is your routing on the spoke correctly setup?
5. Is your routing on the Virtual Router on the firewalls correct?
6. Is the the NSG's blocking your traffic?
7. Did you logged into your Firewalls/Panorama to validate traffic
   1. If you want to know how to find the password go to the section [Firewall Password](#firewall-passwordusername)
8. If you fixed all the issues in the Environment go to the [Traffic Validation](#traffic-validation) section

If you have fixed the traffic issue go back to [Configure Webserver](#configure-webserver) section.
If not review again your Config or go the [Cheating Section](#cheating-section)

## 7.5 Traffic Validation

If you got the all traffic working you can now start with testing of the environment.

1. Test inbound HTTP to your Webserver http://<Public Load Balancer FIP>
2. Test inbound SSH to your Webserver. You can use Putty (Windows) Terminal (Mac)
   1. ssh <username>@Public Load Balancer FIP

<br/>

## 7.6 Autoscaling Test
In this section we will test if the Scale out/in is working and how you can test it

1. Install a second spoke application. Use [Deploy Spoke ressource](#deploy-spoke-ressource) section
2. Create on the second spoke a route table and UDR pointing to the ILB FIP
3. Establish VNet peering between spoke2 and Hub VNet [VNet Peering](#configure-vnet-peering)
4. Login in your Panorama and Create a Security Poliy for East/West traffic. Activate all Security Profiles
5. Update your Virtual routers -> static routes to enable traffic flowing
6. Install on both spoke Server Iperf3
   1. ```sudo apt-get install iperf3```
7. Run iperf3 server on both servers in the background
   1. ```sudo iperf3 -s -D -p 5000```
8. Execute the following command on server 1
   1. ```sudo iperf3 -R -c <server ip 2> -i 1 -t 3000 -T s1 -P 100 -p 5000```
9. Execute the following command on server 2
   1. ```sudo iperf3 -R -c <server ip 1> -i 1 -t 3000 -T s1 -P 100 -p 5000```
10. Check on the Azure Portal your Application Insights
    ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/appinsights.png)
11. In Application Insights select **Metrics** on the left side. Keep **Scope** and **Metric Namespace** as it is and change the Metric field to **panSessionThroughputKbps**
    ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/appinsights2.png)
12. Your output should similiar like this. **If NOT WHY? Troubleshooting**
    ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/appinsights3.png)
13. After 2-3 minutes you can check VMSS your ressource if it scales out.
    1.  Scale Out
    ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/scaleout.png)
    1. Scale Out Complete
    ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/scaleout1.png)
14. When the Scale out completed you can go to your Panorama and check if a new Firewalls is added to your Device Group
    ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/panscale.png)

In case you don't find the reason why you didn't see any metrics or logs check the [Cheating Section](#cheating-section)
<br/>

# 8. Congratulations!!!

Congratulations,  you have successfully completed the following steps:
- Configure Panorama
- configure Azure Environment to allow traffic flow
- Troubleshooting
- Traffic Flow Validation
- Autoscaling Validation/Test
<br/>

# 9. Proof Lab completion

Please provide Screenshots of the Autoscaling events to your Course Instructor to proof the Lab completion.
You can upload the Screenshots to the following folder [Folder](https://drive.google.com/drive/folders/1Ngjki51VaVi_IsG7uJhybw2ftokVxsLt?usp=drive_link)

**NOTE** Please rename the file with **YOURNAME** 
<br/>
<br/>

# 10. Useful information
## 10.1. Firewall Password/Username
to obtain your password for the firewall you have to do the following steps

1. Open Azure Cloud Shell
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/AzureCLI.png)
2. In Cloud shell browse to the following directory
   ```
   cd ./Azure_Training/Azure_Autoscaling_Lab/vmseries_scaleset
   ```
3. As next type following commands to get the username/password from your firewalls
   1. ```terraform output password ```
   2. ```terraform output username ```
   ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/username_password.png)
4. After that you can login into your Firewalls over the Public IP attached to the instances (NOT over the Frontend IP of Public Load Balancer) If you don't know how to find the PIP of your firewall go please to the [Firewall IP Information](#firewall-ip-information) section

## 10.2. Firewall IP Information
In this section will show you how to find your IP Information in a Virtual Machine Scale Set (VMSS)
1. Go to your ressource group where your VMSS is deployed
2. In the ressource group select your VMSS object (example: inbound-VMSS)
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/vmss.png)
3. inside the VMSS click on Instances
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/vmss1.png)
4. Now you see all Instances inside the VMSS. As next you click on one the instances
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/vmss2.png)
5. In the Overview section of your instance you can see now the Private and Public IP of your Firewall
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/vmss3.png)
6. Repeat the steps for all other Firewalls to obtain the IP Information of your Firewalls.
<br/>

# 11. Cheating Section 

Use it only in case you don't find a solution

## 11.1. Troubleshooting

<details>
  <summary style="color:black">Secret for [Troubleshooting 1](#troubleshooting-1) :joy:</summary>

  **NSG sg_pub_inbound**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/sg_pub_inbound.png)

  **NSG sg_private**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/sg_private.png)

  **Would that help on NSG sg_private**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/sg_private_solution.png)

  **Would that help on NSG sg_pub_inbound**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/sg_pub_inbound_solution.png)

</details>
<br/>

<details>
  <summary style="color:black">Secret for [Autoscaling issue](#autoscaling-test) :joy:</summary>

  **Did you enabled Azure Application Insights on the VM-Series Firewall?**
  Follow the Link below add your App Insight Instrumatation key. Please configure it over the Panorama.
  https://docs.paloaltonetworks.com/vm-series/10-2/vm-series-deployment/set-up-the-vm-series-firewall-on-azure/enable-azure-application-insights-on-the-vm-series-firewall

</details>
