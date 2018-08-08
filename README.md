Synopsis
---------
---------


Detailed information on the setup: http://confluence.greensill.cloud/x/SwGh
Project Information :http://confluence.greensill.cloud/x/PQGh

What is Rancher 
---------------

Rancher V2 is an application that manages applications within a Kubernettes environemnt based on AWS EC2 instances.
The rancher documents are avaiable on:
http://confluence.greensill.cloud/x/SwGh


This repo is to setup Rancher V2.* within a Kubernettes high availability environment.
The Kubernettes environment is setup on 3 AWS EC2 instances configured in 3 different availability zones.
The environment must have 3 nodes for the failover to work correctly.




Motivation
-----------
The Rancher V2.* application will replace the current Rancher V1.* application


Installation
------------

Setting up The local PC Environment
--------------------------
--------------------------

Downloads
---------
Download the RKE application from: https://github.com/rancher/rke
Use the Windows version and install this an update the path information to access the RKE application.

Install Terraform : https://www.terraform.io/downloads.html

ensure scripts can run on your PC:
List the execution policy for your machine:
Get-ExecutionPolicy -List

Set the policy for your account:
Set-ExecutionPolicy  Unrestricted -Scope CurrentUser


Setup The Environment Variables 
-------------------------------
Edit the variables.tf file and alter the configuration so that does not impact on any currently running environment.

Running the Setup
------------------
Clone the repo into a directory. 
Ensure terraform and RKE are installed.
Run the following commands from a CMD window:

terraform init
terraform plan
terraform apply

The setup will ask for the aws access keys for your account.

Access the application from a browser:
https://rancher.greensil.cloud

API Reference
-------------

Access the application from a browser eg:
https://rancher.greensil.cloud

use the DNS name used in the TF Variables file.

Monitoring
----------
----------

Enable the helm-stable catalog under the Catalogs tab on the global menu.

Prometheus should be deployed from the catalog app menu will provide performance stats
to a grafana dashboard showing the cluster status.
Grafana deploy the grafana applications from the catalog app menu.

The URL's for the Grafana application are under the load balancer tab.
log into grafana
set the data source to be Prometheus.
import dashboard 3320 "Kubernetes Node Exporter Full" 
which gives a good overview of the cluster.

Full setup details are in the Rancher V2 configuration guide on sharepoint
doc: 


Tests
-----
log onto https://rancher.greensil.cloud and check the status is green for all displays in the cluster.

Contributors
------------


License
-------
Rancher open source rancher.com