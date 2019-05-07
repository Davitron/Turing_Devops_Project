module "cluster" {
    source              = "./modules/cluster"
    project             = "learning-map-app"
    region              = "europe-west1"
    location            = "europe-west1-b" 
    credentials         = "./secrets/google-creds-staging.json"
    bucket              = "turing_apps"
    prefix              = "infrastructure/terraform_state"
}

module "deployments" {
  source                      = "./modules/deployments"
  credentials_file            = "./secrets/google-creds-staging.json"
  namespace                   = "production"
  react_app_name              = "react-app"
  react_app_image             = "gcr.io/learning-map-app/react-app:100bedb"
  react_app_container_port    = "3000"
}
