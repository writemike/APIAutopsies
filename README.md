# **API Autopsies Livestream Demo**
## By Rajesh Bavanantham and Mike Holland

### Thanks for attending!
---

This Repository contains the code used in the API Autopsies Livestream Demos held on Feburary 2, 9, 16, and 23 of 2021. Please review the variable files (.var, .tf, .tfvars) to see which variables need to be changed for your lab environment. This demo was done using the Google Cloud Environment, but the Terraform Provider can be updated to support any cloud environment. The automated NGINX Controller and NGINX Plus install is started by using the main.tf scripts in the Terraform and NGINX+ folders.

You will need to create 
1. Create your own SSH key pair to access your Google Cloud Environment (GCE) VMs
2. Request a free NGINX Controller and NGINX Plus Trial license (This will include NGINX App Protect) via your [MyF5 Portal Login](https://www.f5.com/myf5)
3. Install gcloud to access your GCE account
