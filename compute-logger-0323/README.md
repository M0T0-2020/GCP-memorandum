```sh
export TF_VAR_project_id=<gcp project id>
cd terraform
terraform init
terraform apply
```

```
curl -X POST <deploy endpoint url> \
-H "Authorization: bearer $(gcloud auth print-identity-token)" \
-H "Content-Type: application/json"
```

```
curl -X POST https://my-function-663632280442.us-central1.run.app \
-H "Authorization: bearer $(gcloud auth print-identity-token)" \
-H "Content-Type: application/json"
```

```
terraform destroy -target=google_cloudfunctions2_function.function
```