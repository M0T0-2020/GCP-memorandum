# Cloud Run jobs を使ってみる

コンテナイメージのアップロード

```sh
cd docker
gcloud builds submit . -t us-central1-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME
```

terraformの実行

```sh
export TF_VAR_project=<GCP PROJECT ID>
export TF_VAR_image_path=<使用するコンテナイメージのパス>

cd terraform
terraform init
terraform apply
```

* エラー
    - Memory limit of 512 MiB exceeded with 512 MiB used. Consider increasing the memory limit, see https://cloud.google.com/run/docs/configuring/memory-limits
    - 2Giにして再挑戦。
