import os
from dotenv import load_dotenv
import firebase_admin
from firebase_admin import credentials, firestore

# .env 파일에서 환경 변수를 로드
load_dotenv()

# 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate(os.getenv("FIREBASE_KEY_PATH"))
    firebase_admin.initialize_app(cred)

db = firestore.client()

# 폴더 경로
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
UPLOAD_FOLDER = os.path.join(BASE_DIR, "images")

def remove_missing_images_from_firestore():
    if not os.path.exists(UPLOAD_FOLDER):
        print(f"오류: 이미지 폴더 '{UPLOAD_FOLDER}'를 찾을 수 없습니다.")
        return

    # 로컬 이미지 폴더의 파일 목록 가져오기
    local_filenames = {f for f in os.listdir(UPLOAD_FOLDER) if f.endswith(".png")}
    print(f"로컬 이미지 폴더에서 {len(local_filenames)}개의 이미지 파일 발견")

    # Firestore의 모든 문서 가져오기
    firestore_docs = db.collection("generated_images").stream()

    deleted_count = 0
    
    # Firestore 문서와 로컬 파일 목록을 비교하여 삭제
    for doc in firestore_docs:
        doc_data = doc.to_dict()
        filename = doc_data.get("filename")

        if filename and filename not in local_filenames:
            print(f"Firestore에 존재하지만 로컬에 없는 파일 발견: '{filename}'. 문서를 삭제합니다.")
            try:
                db.collection("generated_images").document(doc.id).delete()
                print(f">> Firestore에서 '{filename}' 문서 삭제 완료")
                deleted_count += 1
            except Exception as e:
                print(f"오류: '{filename}' 문서 삭제 실패 - {e}")

    print("-" * 30)
    print(f"총 {deleted_count}개의 Firestore 문서가 삭제되었습니다.")
    print("-" * 30)

if __name__ == "__main__":
    remove_missing_images_from_firestore()