import os
from flask import Flask, request, jsonify, send_from_directory
from datetime import datetime

# python-dotenv 임포트
from dotenv import load_dotenv

# Firebase 관련 임포트
import firebase_admin
from firebase_admin import credentials, initialize_app
from firebase_admin import firestore
from google.cloud.firestore import Query

load_dotenv()
app = Flask(__name__)
UPLOAD_FOLDER = 'images'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# Firebase 초기화
firebase_key_path = os.getenv('FIREBASE_KEY_PATH')

if not firebase_admin._apps:
    if not firebase_key_path:
        print("에러: FIREBASE_KEY_PATH 환경 변수가 설정 X")
        db = None
    else:
        try:
            cred = credentials.Certificate(firebase_key_path)
            initialize_app(cred)
            db = firestore.client()
            print("Firebase init 성공")
        except Exception as e:
            print(f"Firebase 초기화 중 에러 발생: {e}")
            db = None
else:
    db = firestore.client()
    print("이미 됌")
## if not firebase_admin._apps:

@app.route("/")
def home():
    return "Flask 서버가 정상 작동 중!"

@app.route("/create", methods=["POST"])
def create():
    print(">>> /create 엔드포인트에 POST 요청 수신됨!")
    if not db:
        return jsonify({"error": "Firebase 초기화 실패"}), 500

    image = request.files.get("image")
    prompt = request.form.get("prompt")
    filename = request.form.get("filename")

    if not image or not prompt or not filename:
        return jsonify({"error": "Missing data"}), 400

    try:
        timestamp = int(datetime.now().timestamp() * 1000)
        fname = f"{filename}_{timestamp}.png"
        image_path = os.path.join(UPLOAD_FOLDER, fname + ".png")
        image.save(image_path)

        image_url = f"images/{fname}.png"

        doc_ref = db.collection("generated_images").document()
        doc_ref.set({
            "doc_id": doc_ref.id,
            "prompt": prompt,
            "filename": fname,
            "image_url": image_url,
            "timestamp": datetime.now().isoformat()
        })

        return jsonify({"message": "Saved successfully", "doc_id": doc_ref.id, "image_url": image_url}), 201
    except Exception as e:
        print(f"Error in create function: {e}")
        return jsonify({"error": str(e)}), 500
## create

@app.route("/read", methods=["GET"])
def read():
    print(">>> /read 엔드포인트에 GET 요청 수신됨!")

    if not db:
        return jsonify({"error": "Firebase is not initialized."}), 500

    try:
        limit = int(request.args.get("limit", 10))
        docs = db.collection("generated_images") \
                 .order_by("timestamp", direction=firestore.Query.DESCENDING) \
                 .limit(limit) \
                 .stream()

        base_url = request.host_url.rstrip('/')
        result = []

        for doc in docs:
            data = doc.to_dict()
            data["id"] = doc.id

            data["image_url"] = f"images/{data['filename']}"
            result.append(data)

        return jsonify(result), 200
    except Exception as e:
        print(f"Error in read function: {e}")
        return jsonify({"error": str(e)}), 500
## read

@app.route("/images/<path:filename>")
def serve_image(filename):
    return send_from_directory(UPLOAD_FOLDER, filename)
## serve_image

@app.route("/delete/<doc_id>", methods=["DELETE"])
def delete(doc_id):
    print(f">>> /delete/{doc_id} DELETE 요청 수신됨!")

    if not db:
        return jsonify({"error": "Firebase is not initialized."}), 500

    try:
        doc_ref = db.collection("generated_images").document(doc_id)
        doc = doc_ref.get()

        if not doc.exists:
            return jsonify({"message": "No document found with that doc_id"}), 404

        data = doc.to_dict()
        filename = data.get("filename")
        image_path = os.path.join(UPLOAD_FOLDER, filename)

        # 이미지 삭제
        if os.path.exists(image_path):
            os.remove(image_path)
            print(f"로컬 파일 삭제됨: {image_path}")
        else:
            print(f"파일 없음: {image_path}")

        # Firestore 삭제
        doc_ref.delete()

        return jsonify({"message": "Document and image deleted successfully"}), 200
    except Exception as e:
        print(f"Error in delete function: {e}")
        return jsonify({"error": str(e)}), 500
## delete

@app.route("/update/<doc_id>", methods=["PUT"])
def update(doc_id):
    print(f">>> /update/{doc_id} PUT 요청 수신됨!")
    if not db:
        return jsonify({"error": "Firebase is not initialized."}), 500

    try:
        doc_ref = db.collection("generated_images").document(doc_id)
        doc = doc_ref.get()

        if not doc.exists:
            return jsonify({"message": "No document found with that doc_id"}), 404

        data = doc.to_dict()

        new_filename = request.form.get("filename")
        if not new_filename:
            return jsonify({"error": "filename 필드가 필요합니다."}), 400

        # 기존 파일 경로
        old_filename = data["filename"]
        image_path_old = os.path.join(UPLOAD_FOLDER, old_filename)

        # 새 파일 경로
        new_filename_full = new_filename + ".png"
        image_path_new = os.path.join(UPLOAD_FOLDER, new_filename_full)

        # 로컬 파일 이름 변경
        if os.path.exists(image_path_old):
            os.rename(image_path_old, image_path_new)
            print(f"파일명 변경 완료: {old_filename} -> {new_filename_full}")
        else:
            print(f"기존 이미지 없음: {image_path_old}")
            return jsonify({"error": "로컬 이미지 파일이 존재하지 않습니다."}), 404

        # Firestore 필드 업데이트
        doc_ref.update({
            "filename": new_filename_full,
            "image_url": f"images/{new_filename_full}"
        })

        return jsonify({"message": "Filename updated successfully"}), 200

    except Exception as e:
        print(f"Error in update function: {e}")
        return jsonify({"error": str(e)}), 500
## update

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)