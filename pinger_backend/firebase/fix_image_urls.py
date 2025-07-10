import os
import firebase_admin
from firebase_admin import credentials, firestore

# 초기화
if not firebase_admin._apps:
    cred = credentials.Certificate(os.getenv("FIREBASE_KEY_PATH"))
    firebase_admin.initialize_app(cred)

db = firestore.client()
IMAGE_DIR = "images"

def fix_image_urls():
    docs = db.collection("generated_images").stream()
    updated = 0
    skipped = 0

    for doc in docs:
        data = doc.to_dict()
        filename = data.get("filename")
        if not filename:
            skipped += 1
            continue

        image_path = os.path.join(IMAGE_DIR, filename)
        if os.path.exists(image_path):
            new_url = f"images/{filename}"
            if data.get("image_url") != new_url:
                doc.reference.update({"image_url": new_url})
                updated += 1
        else:
            skipped += 1

    print(f"Updated: {updated}, Skipped: {skipped}")
## fix_image_urls

if __name__ == "__main__":
    fix_image_urls()
