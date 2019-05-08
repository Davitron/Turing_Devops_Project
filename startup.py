#!/usr/bin/env python3

import os
import env
import sys
import subprocess

variables = env.env_variables
image_details = env.image_details
variables_count = len(variables)
variables_store = {}
main_file = './main.tf'


def exit_process(err_code):
    switcher = {
        'VAR_ERR': "Incomplete deployment variables",
        'TERRAFORM_ERR': "Failed terraform deployment",
    }
    print("ERROR: "+switcher.get(err_code, "Global Error"))
    sys.exit()


def get_image_version(path):
    cmd = 'gsutil cp gs://'+path+' . && cat current_version'
    os.system(cmd)
    version = open('current_version', 'r').read()
    return version.replace('\n', '')

def prep_full_image_names():
    for index in range(len(image_details)):
        image_path = image_details[index]['image_path']
        image_name = image_details[index]['image_name']
        current_version = get_image_version(os.getenv(image_path))
        full_image_name = os.getenv(image_name)+":"+str(current_version)
        os.environ[image_name] = full_image_name

def get_env():
    for index in range(len(variables)):
        env_value = os.environ.get(variables[index])
        if env_value == None:
            print("variable " + variables[index] +" has no vakue")
            break
        print(env_value)
        variables_store[variables[index].lower()] = env_value
    if variables_count != len(variables_store):
        exit_process("VAR_ERR")

def prepare_secrets():
    os.system('mkdir secrets')
    os.system('echo $GOOGLE_CREDENTIALS | base64 --decode > secrets/google-creds-staging.json')

def generate_main_file():
    # remove esisting main file
    main_file_exists = os.path.isfile(main_file)
    if main_file_exists == True:
        os.remove(main_file)
    # read content of template file
    main_file_content = open('./main.tf.tmpl', 'r').read()
    print(main_file_content.format(**variables_store))
    # render template with substituted data in main.tf file
    rendered_main_file = open(main_file, 'w')
    rendered_main_file.write(main_file_content.format(**variables_store))
    rendered_main_file.close()

def run_terraform_commands():
    os.system('gsutil cp gs://'+os.getenv('BUCKET')+'/'+os.getenv('PREFIX')+'/default.tfstate terraform.tfstate')
    os.system('chmod +x ./run_terraform.sh')
    run_terrsform = subprocess.call('./run_terraform.sh')
    if run_terrsform == 0:
        print('deployment successful')
        os.system('gsutil cp terraform.tfstate gs://'+os.getenv('BUCKET')+'/'+os.getenv('PREFIX')+'/default.tfstate')
    else:
        exit_process("TERRAFORM_ERR")

def main():
    prepare_secrets()
    prep_full_image_names()
    get_env()
    generate_main_file()
    run_terraform_commands()

main();