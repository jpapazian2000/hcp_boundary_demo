# GOAL OF THIS DEMO
The intent of the following scripts is ultimatelly to showcase the ease of installation, configuration and usage of HCP Boundary.
To do so, the following will be created:
 - 1 Vault Cluster
 - 1 Boundary Cluster
 - 1 Postgresql db on GCP with 2 roles (dba and analyst)
 Next the dynamic secrets management from the postgresql db will be all configured in the Vault Cluster
 Finally we will integrate the Vault and Boundary clusters and demo how a user requesting access to the postgresql db gets the dynamic credential from Vault.

## HCP Vault Cluster - dev 

The Configuration in this directroy will create the following objects:

- 1 - Vault Dev Cluster
- 1 - HCP HVN Network `[172.25.16.0/20]`
- 1 - Vault Admin Token


This example creates a simple Vault cluster and generates a Vault token in the `admin` namespace and outputs it for use. Please note that this cluster is exposed to the internet

## Pre-Requisites:
- AWS Account Credentials with the proper permissions (not sure for the begining)
- HCP Account Credentials with the proper permissions (CLIENT_ID and CLIENT_SECRET with contributor role)
- Google Credentials
- TFCB account

## DEMO STEPS
 # copy the github repo
 From that local copy, make a local clone (in my case github.com/jpapazian2000/terraform-vault-hcp)
 # create a tfcb workspace
  - use the same name (ie terraform-vault-hcp)
  - execution mode 'remote'
  - VCS Driven : make a link to your own fork of the github repo
  - on my side, I use 'manual apply' (instead of automatic) at the beginning to allow for better control of what happens
  - fill in the variables with the required values
 