```sh
export TF_VAR_project_id=<GCP PROJECT ID>
export TF_VAR_container_path=<使用するコンテナイメージのパス>
export TF_VAR_message='Hello, World!'
export TF_VAR_number="5"

cd terraform
terraform init
terraform apply
```