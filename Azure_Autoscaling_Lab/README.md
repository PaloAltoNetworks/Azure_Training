![](https://lh4.googleusercontent.com/18oAPNp1uzZ6qY6bJxg2fWYWUEV-pQzNa_dSAqSp2lEjdg4hlEyLlQYc1OAowXxSqrp5Bk9iXRYOu-mECiqSr-gzo56d8QAh97VrfTbwX4uYN2ABB8BKM9XZK2mSzSXDN3qeHzp8xRsNHmALdeNEPiw)

![](https://lh3.googleusercontent.com/_-_DS9VDmI1QhI68JOiMchoWH7Bo1fqYn0qbD9Y24KH1T1zAG272HQy7cetrLxw3buJYbJEcj7TMjxv0CeWt-z1p4a3hl1FrNKPMROVo6L42XLIWFkjw_yPGlVTzhcPz1v2IB2JCUXMrAl4p2n9kbnY) 

- [1. Palo Alto Networks Azure Autoscaling Lab Guide](#1-palo-alto-networks-azure-autoscaling-lab-guide)
- [2. Overview](#2-overview)
- [3. Environment Overview](#3-environment-overview)
  - [3.1. What You'll Do](#31-what-youll-do)
- [4. Activity 1: Lab Setup](#4-activity-1-lab-setup)
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
  - [7.1. What You'll Do](#71-what-youll-do)
    - [7.1.1. Configure Panorama](#711-configure-panorama)
    - [7.1.2. Configure Webserver](#712-configure-webserver)
    - [7.1.3. Troubleshooting 1](#713-troubleshooting-1)
    - [7.1.4. Traffic Validation](#714-traffic-validation)
    - [7.1.5. Autoscaling Test](#715-autoscaling-test)
- [8. Congratulations!!!](#8-congratulations)
- [9. Useful information](#9-useful-information)
  - [9.1. Firewall Password/Username](#91-firewall-passwordusername)
  - [9.2. Firewall IP Information](#92-firewall-ip-information)
- [10. Cheating Section](#10-cheating-section)
  - [10.1. Troubleshooting](#101-troubleshooting)

# 1. Palo Alto Networks Azure Autoscaling Lab Guide

<br/><br/>

# 2. Overview

The goal of this Lab is to take you through the experience of deploying the Palo Alto Networks VM-Series on Microsoft Azure to protect your Cloud Native Applications. This workshop will take you through the three step process of using the service - Automate, Deploy and Secure.

As part of the workshop you will learn to deploy the VM-Series on a Common model with Autoscaling.

<br/><br/>

# 3. Environment Overview

**ADD PICTURE**

For this workshop we have automated the deployment of the lab environment and you will using an existing Panorama. The credentials to the Panorama will be provided during the Workshop. This is achieved via Terraform, that you will be launching as part of the lab over the Azure CLI.

<br/>

## 3.1. What You'll Do

- Login into your Azure Account
- Download GitHub Reposetority into you Azure Environment
- Modifying Terraform code
- Deploy the Azure resources required for the lab using Terraform
- Configure Panorama
- Deploy Spoke Ressource and configure Traffic routing
- **TROUBLESHOOTING!!!!**
- Create/Update Panorama Security Policies, NAT Policies, etc...

<br/><br/>

# 4. Activity 1: Lab Setup

## 4.1. What you'll need

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

## 4.2. Validate Deployment

### 4.2.1. What You'll Do

- Login into Panorama
- Validate Deployment

15. Login into Panorama Public IP
    1.  Instructor will Panorama IP 
    2.  Instructor will Username
    3.  Instructor will Password

16. Once you logged into the Panorama Navigate to the **Panorama** tab validate you can see your newly deployed Firewalls **(The deployment and bootstrapping process can take up to 30-45 minutes)**. If the Deployment was succesful you will see the following output in **Panorama -> Managed Devices -> Summary**
   
![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/panoramacomplete.png)

17. You succesfull deployed your Environment if you can the above output


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
- Automated Deployment of your Hub Ressource Group with Terraform
- Deployment of your Spoke Ressource Group with ARM Template
- Redirect Traffic of your Spoke Ressource Group to the Internal Load Balancer in the Hub Ressource Group

<br/>

# 7. Lab Activity 2: Configure Panorama, Firewalls and Azure 

## 7.1. What You'll Do

- Configure Panorama Security Policies, NAT Policies, etc...
- Configure Webserver
- **TROUBLESHOOTING!!!!**
- Validate Traffic flow
- **TROUBLESHOOTING!!!!**
- Autoscaling Test
- **TROUBLESHOOTING!!!!**

<br/>

### 7.1.1. Configure Panorama

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
5. Commit your changes to the Panorama
6. Push your changes to your Firewalls



<details>
  <summary style="color:black">Expand If you need Help</summary>

  **Security Policies**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/security.png)

  **NAT Policies**
  ![](https://raw.githubusercontent.com/PaloAltoNetworks/Azure_Training/main/Azure_Autoscaling_Lab/Images/nat.png)

</details>
<br/>

### 7.1.2. Configure Webserver

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

### 7.1.3. Troubleshooting 1

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

### 7.1.4. Traffic Validation

If you got the all traffic working you can now start with testing of the environment.

1. Test inbound HTTP to your Webserver http://<Public Load Balancer FIP>
2. Test inbound SSH to your Webserver. You can use Putty (Windows) Terminal (Mac)
   1. ssh <username>@Public Load Balancer FIP

<br/>

### 7.1.5. Autoscaling Test
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
<br/>
<br/>
<br/>
<br/>

# 9. Useful information
## 9.1. Firewall Password/Username
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

## 9.2. Firewall IP Information
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


# 10. Cheating Section 

Use it only in case you don't find a solution

## 10.1. Troubleshooting

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