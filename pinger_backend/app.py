import os
from flask import Flask, request, jsonify, send_from_directory
from datetime import datetime

# python-dotenv 임포트
from dotenv import load_dotenv

# Firebase 관련 임포트
import firebase_admin
from firebase_admin import credentials, firestore, initialize_app

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
        return jsonify({"error": "Firebase is not initialized."}), 500
    image = request.files.get("image")
    prompt = request.form.get("prompt")
    filename = request.form.get("filename")

    if not image or not prompt or not filename:
        return jsonify({"error": "Missing data"}), 400

    try:
        image_path = os.path.join(UPLOAD_FOLDER, filename + ".png")
        image.save(image_path)

        doc_ref = db.collection("generated_images").document()
        doc_ref.set({
            "prompt": prompt,
            "filename": filename + ".png",
            "image_url": f"http://127.0.0.1:5000/images/{filename}.png",
            "timestamp": datetime.now().isoformat()
        })

        return jsonify({"message": "Saved successfully", "image_url": f"/images/{filename}.png"}), 201
    except Exception as e:
        print(f"Error in create function: {e}")
        return jsonify({"error": str(e)}), 500
## create

@app.route("/read", methods=["GET"])
def read():
    if not db:
        return jsonify({"error": "Firebase is not initialized."}), 500

    try:
        limit = int(request.args.get("limit", 10))
        docs = db.collection("generated_images") \
                 .limit(limit) \
                 .stream()

        result = []
        for doc in docs:
            data = doc.to_dict()
            data["id"] = doc.id
            data["image_url"] = f"/images/{data['filename']}"
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

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)