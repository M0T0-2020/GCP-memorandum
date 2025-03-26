import os
import dotenv
from pathlib import Path

import pandas as pd
from google.cloud import storage

dotenv.load_dotenv()

BUCKET_NAME = os.environ.get("BUCKET_NAME") 

LOCAL_PATH = Path(__file__).parent
SAVE_DIR = LOCAL_PATH / "data"
SAVE_DIR.mkdir(exist_ok=True, parents=True)


def upload_csv_to_gcs(bucket_name: str, local_file_path: Path, gcs_file_path: str):
    """
    ローカルのCSVファイルを指定されたGCSバケットにアップロードします。

    Args:
      bucket_name: GCSバケットの名前 (例: "your-bucket-name").
      local_file_path: ローカルのCSVファイルのパス (例: "test1.csv").
      gcs_file_path: GCS上のファイルパス (例: "test_bucket/id=1/test1.csv").
    """

    try:
        # GCSクライアントを初期化します。
        storage_client = storage.Client()

        # バケットを取得します。
        bucket = storage_client.bucket(bucket_name)

        # アップロード先のGCS上のBlobオブジェクトを作成します。
        blob = bucket.blob(gcs_file_path)

        # ファイルをアップロードします。
        blob.upload_from_filename(local_file_path)

        print(
            f"ファイル {local_file_path} を {bucket_name}/{gcs_file_path} にアップロードしました。"
        )

    except Exception as e:
        print(f"ファイルのアップロードに失敗しました: {e}")


def main(_id:int, df: pd.DataFrame, file_name: str):
    df.to_csv(SAVE_DIR / file_name, index=False)
    local_file_path = SAVE_DIR / file_name
    gcs_file_path = f"id={_id}/{file_name}"
    upload_csv_to_gcs(BUCKET_NAME, local_file_path, gcs_file_path)
    return local_file_path


if __name__ == "__main__":
    df = pd.DataFrame(
        {
            "name": ["Alice", "Bob", "Charlie"],
            "age": [25, 30, 35],
            "meta": ["A", "B", "C"],
        }
    )
    main(1, df, "test1.csv")

    df = pd.DataFrame(
        {
            "name": ["Alice", "Bob", "Charlie"],
            "age": [25, 30, 35],
            "meta": ["A", "B", "C"],
            "meta2": ["D", "E", "F"],
        }
    )
    main(2, df, "test2.csv")

    df = pd.DataFrame(
        {
            "name": ["Alice", "Bob", "Charlie"],
            "age": [25, 30, 35],
            "meta": ["A", "B", "C"],
            "meta2": ["D", "E", "F"],
            "meta3": ["G", "H", "I"],
        }
    )
    main(3, df, "test3.csv")
