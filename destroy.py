#!/usr/bin/env python3

import os

def pull_current_terraform_state():
    os.system('gsutil cp gs://'+os.getenv('BUCKET')+'/'+os.getenv('PREFIX')+'/default.tfstate terraform.tfstate')
    os.system('terraform destroy -target module.deployments -auto-approve')
    os.system('terraform destroy -target module.cluster -auto-approve')

pull_current_terraform_state()
