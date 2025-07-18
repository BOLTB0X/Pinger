import os
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime

# Firebase 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate(os.getenv("FIREBASE_KEY_PATH"))
    firebase_admin.initialize_app(cred)

db = firestore.client()

# 폴더 경로
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
UPLOAD_FOLDER = os.path.join(BASE_DIR, "images")

def sync_images_to_firestore():
    existing_docs = db.collection("generated_images").stream()
    existing_filenames = {doc.to_dict().get("filename") for doc in existing_docs}

    for filename in os.listdir(UPLOAD_FOLDER):
        if not filename.endswith(".png"):
            continue

        if filename in existing_filenames:
            continue

        print(f"Firestore에 존재하지 않는 이미지 발견: {filename}")

        doc_ref = db.collection("generated_images").document()
        image_url = f"{UPLOAD_FOLDER}/{filename}"

        doc_ref.set({
            "doc_id": doc_ref.id,
            "filename": filename,
            "prompt": "Unknown",
            "image_url": image_url,
            "timestamp": datetime.now().isoformat()
        })

        print(f">> Firestore에 '{filename}' 추가 완료")

if __name__ == "__main__":
    sync_images_to_firestore()
