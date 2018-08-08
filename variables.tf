#-------------------------------------------------------------------------------
 #  Variables for Rancher V2
 #  created by Graham Cann 29/05/2018
 # GC 31/05/2018  added the docker switch to supported version commands   
 # gc 12/06/2018 add comments and network variables
 #-------------------------------------------------------------------------------
 
 
 #-------------------------------------------------------------------------------
 # aws variables for Rancher V2.0.0 HA Server environment
 # the keys are input and not stored in the configuration for security reasons.
 #-------------------------------------------------------------------------------
 variable "access_key" {}
 variable "secret_key" {}
 variable "region" {
  default = "eu-central-1"
				}
  variable "my_ip_address" {}   # the ip address of your PC 
 #-------------------------------------------------------------------------------
 #aws variables for Rancher V2.* HA Server environment
 #-------------------------------------------------------------------------------
 variable "rancher-name" {default = "rancherv4"}       # name for the setup change for new cluster
 
 variable "rancher-environment" {default = "Development"}     # developement or production

 variable "label-az1" {default = "rancherv2-test-os-ha-tf-1a"}    # labels for nodes (ec2 instances)
 variable "label-az2" {default = "rancherv2-test-os-ha-tf-1b"}
 variable "label-az3" {default = "rancherv2-test-os-ha-tf-1c"}
 
 variable "rancher-ami" {default = "ami-bc386557"}
 

 variable "rancher-type" {default = "t2.medium"}                # aws instance type
 variable "rancher-key" {default = "rancherv2"}                 # access key name for *.pem file
 variable "rancher-key-path" {default = "C:\\Jenkins-Workspace\\Rancher-V2-AWS\\"}                 # access key path 
 
 variable "rancher-sg-name" {default = "rancherv4-nodes"}       # storage group id
 
 variable "rancher-iam" {default = "EC2-S3"}                   # IAM role to use for access
 
 variable "rancher-vpc" {default = "vpc-0c89f45aff5a957e8"}                   # VPC ID
 
 #-------------------------------------------------------------------------------
 #network variables 
 #-------------------------------------------------------------------------------
 variable "route53-zone" {default = "Z149YK45V1ZSHX"}             # *.greensill.cloud route id Z149YK45V1ZSHX private
 variable "route53-hosted-zone" {default = "Z215JYRZR1TBD5"}      # entries under the greensill.cloud have this hosted zone id
 variable "route53-name" {default = "rancherv4.greensill.cloud"}  # route53 a record name
 variable "lb-name" {default = "rancherv4-alb"} 				  # load balancer a record name
 
 variable "az1" {default = "eu-central-1a"} 	# az for subnet a 
 variable "az2" {default = "eu-central-1b"} 	# az for subnet b 
 variable "az3" {default = "eu-central-1c"} 	# az for subnet c 
 
 variable "cidr-az1" {default = "172.20.41.0/24"}  # cird for the subnet in az 1a give 4096 addresses
 variable "cidr-az2" {default = "172.20.42.0/24"}  # cird for the subnet in az 1b
 variable "cidr-az3" {default = "172.20.43.0/24"}  # cird for the subnet in az 1c
 
 variable "sub-az1-name" {default = "rancher-v4-1a"}  # az 1a
 variable "sub-az2-name" {default = "rancher-v4-1b"}  # az 1b
 variable "sub-az3-name" {default = "rancher-v4-1c"}  # az 1c
 
 variable "internet-gateway" {default = "igw-043cd75c30653787e"}  # internet gateway id for the vpc
 variable "virtual-gateway" {default = "vgw-0169ca7cd3773efe4"}  # viryual gateway id for the vpc
 
 #-------------------------------------------------------------------------------
 #aws variables to change docker to a supported version for rancher
 #-------------------------------------------------------------------------------
 variable "rancher-docker" {default = "sudo ros engine switch docker-17.03.2-ce "}  
 variable "rancher-user" {default = "rancher"}  
 variable "rancher-ssh-key" {default = "rancherv2.pem"}  
 #-------------------------------------------------------------------------------
 # logging variables 
 #-------------------------------------------------------------------------------
 variable "rancher-lb-log" {default = "rancher-v2-logs-greensill.cloud"}      # bucket for the load balancer log files


 #------------------
 # end of variables
 #------------------

