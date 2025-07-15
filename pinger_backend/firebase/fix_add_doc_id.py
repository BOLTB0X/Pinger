import os
import firebase_admin
from firebase_admin import credentials, firestore

# Firebase 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate(os.getenv("FIREBASE_KEY_PATH"))
    firebase_admin.initialize_app(cred)

db = firestore.client()

def fix_doc_ids():
    collection_ref = db.collection("generated_images")
    docs = collection_ref.stream()

    fixed_count = 0
    for doc in docs:
        doc_id = doc.id
        data = doc.to_dict()

        if "doc_id" not in data:
            print(f"Updating doc_id for document: {doc_id}")
            collection_ref.document(doc_id).update({"doc_id": doc_id})
            fixed_count += 1

    print(f"총 {fixed_count}개 문서 업데이트 완료")

if __name__ == "__main__":
    fix_doc_ids()
