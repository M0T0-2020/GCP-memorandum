```sh
export TF_VAR_project_id=<GCP PROJECT ID>
export TF_VAR_image_path=<使用するコンテナイメージのパス>

cd terraform
terraform init
terraform plan
terraform apply
```

コンテナイメージのアップロード

```sh
cd src
gcloud builds submit . -t us-central1-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME
```
