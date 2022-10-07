# STRUCTURE OF THIS README
The organisation of this readme is the following:
 - Goal of the deme
 - repo architecture
 - deployment guide
 - demo

# GOAL OF THIS DEMO
The intent of the following scripts is ultimatelly to showcase the ease of installation, configuration and usage of HCP Boundary.
To do so, the following will be created:
 - 1 Vault Cluster
 - 1 Boundary Cluster
 - 1 Postgresql db on GCP with 2 roles (dba and analyst)
 Next the dynamic secrets management from the postgresql db will be all configured in the Vault Cluster
 Finally we will integrate the Vault and Boundary clusters and demo how a user requesting access to the postgresql db gets the dynamic credential from Vault.


# REPO ARCHITECTURE
This repo is organised in 3 sub directories:
 - infra_build
 All code needed to build the underlying infrastructure for the demo
 - infra_conf
 All code needed to configure the infrastructure for the demo
 - tfcb_workspaces
 The above 2 directories will be linked to Terraform Cloud for Business Workspaces.
 In order to speed up the deployement, this subdirectory will automate the deployment, configuration and variable setting of those workspaces in TFCB


# DEPLOYEMENT GUIDE
## Pre-Requisites:
- AWS Account Credentials with the proper permissions (not sure for the begining)
- HCP Account Credentials with the proper permissions (CLIENT_ID and CLIENT_SECRET with contributor role)
- Google Credentials
- TFCB token with privileges in your organisation : `tfe_token` variable
- github oauth token :`vcs_token` variable (for github starts with `ghp_xxx`)
  - Follow this [link](https://www.terraform.io/docs/cloud/api/oauth-clients.html?&_ga=2.231907487.1225499417.1664975183-1693872711.1655195363#create-an-oauth-client) for more details on getting this token.
## Deployment
1. fork and clone the repo
2. cd to `tfcb_workspaces`
3. check your variables in `tfcb.tfvars`
 - `aws_credentials` : name of the tfcb variable set that defines all aws credentials information
 - `google_credentials` : name of the tfcb variable set that defines all google credentials information
 - `hcp_credentials` : name of the tfcb variable set that defines all hcp credentials information
 - `Mandatory_Tags`: name of the tfcb variable set that defines all mandatory tags you want to apply to your resources in your cloud environments
 - other variables names are indicating their purposes
 - export `tfe_token`and `vcs_token`as terraform env variables:
  ````
  export TFE_TOKEN=${tfe_token}
  export TF_VAR_vcs_token=${vcs_token}
  ````




## HCP Vault Cluster - dev 

The Configuration in this directroy will create the following objects:

- 1 - Vault Dev Cluster
- 1 - HCP HVN Network `[172.25.16.0/20]`
- 1 - Vault Admin Token


This example creates a simple Vault cluster and generates a Vault token in the `admin` namespace and outputs it for use. Please note that this cluster is exposed to the internet


## DEMO STEPS
 # copy the github repo
 From that local copy, make a local clone (in my case github.com/jpapazian2000/terraform-vault-hcp)
 # create a tfcb workspace
  - use the same name (ie terraform-vault-hcp)
  - execution mode 'remote'
  - VCS Driven : make a link to your own fork of the github repo
  - on my side, I use 'manual apply' (instead of automatic) at the beginning to allow for better control of what happens
  - fill in the variables with the required values
 