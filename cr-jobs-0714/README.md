# Cloud Run jobs を使ってみる

コンテナイメージのアップロード

```sh
cd jobs
gcloud builds submit . -t us-central1-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME
```

terraformの実行

```sh
export TF_VAR_project_id=<GCP PROJECT ID>
export TF_VAR_container_path=<使用するコンテナイメージのパス>
export TF_VAR_message='Hello, World!'
export TF_VAR_number="5"

cd terraform
terraform init
terraform apply
```
