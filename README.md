# Pinger

![초수위화](https://3.gall-gif.com/tdgall/files/attach/images/82/310/776/057/a1fdf49a195cd1851c2472dedf2f0a6c.gif)

## 기술스택

```
Flutter(Client)
   → Base64 Encoded Sketch
      → Flask API (/create)
          → ControlNet (Colab / API(generate))
              → Generated Image
                  → Firebase Storage Upload
                      → Firestore Metadata 저장
                          → Flutter 리스트뷰에서 표시  

```

| 구성 요소       | 기술 스택                                | 설명                                      |
|----------------|------------------------------------------|-------------------------------------------|
| Client (App)   | Flutter                                  | 사용자 UI 및 앱 동작                      |
| Server   | Python + Flask (로컬 서버)               | 이미지 저장, 메타데이터 저장, API 제공    |
| AI 모델 서버   | Google Colab + Hugging Face              | 스케치 기반 이미지 생성 (`ControlNet`)     |
| DB             | Firebase Firestore                       | 이미지 메타데이터 관리                    |
| 이미지 저장소  | 로컬 디렉토리 (`/images`), Google Drive | 생성 이미지 저장소                        |


---


## [Drawing](https://github.com/BOLTB0X/Pinger/tree/main/pinger_application/lib/domain/entities)

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EB%8B%88%EC%B2%B4%20%EB%93%9C%EB%A1%9C%EC%9E%89.gif?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EC%96%B8%EB%8D%94%EB%8D%94%EB%B6%80%EC%B2%98-%EB%93%9C%EB%A1%9C%EC%9E%89.gif?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EC%9D%BC%EB%B0%98-draw.gif?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        ex 그리기 1
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        ex 그리기 2
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        ex 그리기 3
      </p>
      </td>
    </tr>
  </table>
</p>

<details>
<summary> DrawingCanvas </summary>

```dart
class DrawingCanvas extends StatelessWidget {
  final GlobalKey repaintKey;
  final bool isDrawingEnabled;

  const DrawingCanvas({
    super.key,
    required this.repaintKey,
    this.isDrawingEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<DrawingManager>();

    return RepaintBoundary(
      key: repaintKey,
      child: GestureDetector(
        onPanStart: (details) {
          RenderBox box = context.findRenderObject() as RenderBox;
          Offset point = box.globalToLocal(details.globalPosition);
          isDrawingEnabled ? manager.startSketch(point) : null;
        },
        onPanUpdate: (details) {
          RenderBox box = context.findRenderObject() as RenderBox;
          Offset point = box.globalToLocal(details.globalPosition);
          isDrawingEnabled ? manager.addPoint(point) : null;
        },
        onPanEnd: (_) => isDrawingEnabled ? manager.endSketch() : null,
        child: Container(
          color: Colors.white,
          child: CustomPaint(
            painter: DrawingPainter(
              manager.sketches,
              currentPoint: manager.currentDrawingPoint,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  } // build
} // DrawingCanvas
```

</details>


<details>
<summary> DrawingPainter </summary>

```dart
class DrawingPainter extends CustomPainter {
  final List<Sketch> sketches;
  final Offset? currentPoint;

  DrawingPainter(this.sketches, {this.currentPoint});

  // Methods
  // ...

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());

    for (final sketch in sketches) {
      canvas.drawPath(sketch.path, sketch.paint);
    }

    if (currentPoint != null) {
      final glowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(currentPoint!, 16, glowPaint);
    }

    canvas.restore();
  } // paint

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate.sketches != sketches ||
        oldDelegate.currentPoint != currentPoint;
  } // shouldRepaint
} // DrawingPainter
```
</details>


---

## Edit

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EA%B7%B8%EB%A6%BC%20%ED%9B%84%20%ED%85%8D%EC%8A%A4%ED%8A%B8%ED%95%84%EB%93%9C%20%ED%99%95%EC%9D%B8.gif?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://raw.githubusercontent.com/BOLTB0X/Pinger/refs/heads/main/Img/%ED%8E%AD%EA%B7%84%20-%201.gif" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%ED%8E%9C-%EA%B5%B5%EA%B8%B0-%EC%A1%B0%EC%A0%95.gif?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        프롬프트 입력 1
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        프롬프트 입력 2
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        펜 굵기
      </p>
      </td>
    </tr>
  </table>
</p>

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/undo.gif?raw=true" 
             alt="image 1" 
             style="width:180px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/redo.gif?raw=true" 
             alt="image 2" 
             style="width:180px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EC%A7%80%EC%9A%B0%EA%B0%9C.gif?raw=true" 
             alt="image 2" 
             style="width:180px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EC%A0%84%EC%B2%B4%EC%82%AD%EC%A0%9C.gif?raw=true" 
             alt="image 2" 
             style="width:180px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        ⬅
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        ➡
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        지우개
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        전체삭제
      </p>
      </td>
    </tr>
  </table>
</p>

<details>
<summary> PathHistory </summary>

```dart
class PathHistory {
  final List<Sketch> _sketches = [];
  final List<Sketch> _undone = [];

  List<Sketch> get sketches => List.unmodifiable(_sketches);

  // 새로운 스케치 추가
  void add(Sketch sketch) {
    _sketches.add(sketch);
    _undone.clear();
  }

  // 전체 삭제
  void clear() {
    _sketches.clear();
    _undone.clear();
  }

  // 실행 취소 (undo)
  void undo() {
    if (_sketches.isNotEmpty) {
      _undone.add(_sketches.removeLast());
    }
  }

  // 다시 실행 (redo)
  void redo() {
    if (_undone.isNotEmpty) {
      _sketches.add(_undone.removeLast());
    }
  }
} // PathHistory
```

</details>

<details>
<summary> DrawingManager </summary>

```dart
class DrawingManager extends ChangeNotifier {
  final PathHistory _history = PathHistory();
  Sketch? _currentSketch;
  bool _eraseMode = false;
  double _strokeWidth = 4.0;

  List<Sketch> get sketches {
    if (_currentSketch == null) return _history.sketches;
    return [..._history.sketches, _currentSketch!];
  } // sketches

  Offset? get currentDrawingPoint {
    final metrics = _currentSketch?.path.computeMetrics().toList();
    if (metrics == null || metrics.isEmpty) return null;

    final lastMetric = metrics.last;
    final lastTangent = lastMetric.getTangentForOffset(lastMetric.length);
    return lastTangent?.position;
  } // currentDrawingPoint

  set eraseMode(bool val) {
    _eraseMode = val;
  } // eraseMode

  set strokeWidth(double val) {
    _strokeWidth = val;
  } // strokeWidth

  // Methods
  // ....

  void startSketch(Offset point, {Color color = Colors.black}) {
    final paint = Paint()
      ..color = _eraseMode ? const Color(0x00000000) : color
      ..blendMode = _eraseMode ? BlendMode.clear : BlendMode.srcOver
      ..strokeWidth = _eraseMode ? _strokeWidth * 5.0 : _strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(point.dx, point.dy);
    _currentSketch = Sketch(path: path, paint: paint);
  } // startSketch

  void addPoint(Offset point) {
    _currentSketch?.path.lineTo(point.dx, point.dy);
    notifyListeners();
  } // addPoint

  void endSketch() {
    if (_currentSketch != null) {
      _history.add(_currentSketch!);
      _currentSketch = null;
      notifyListeners();
    }
  } // endSketch

  void clear() {
    _history.clear();
    _currentSketch = null;
  } // clear

  void undo() {
    _history.undo();
  } // undo

  void redo() {
    _history.redo();
  } // undo
} // DrawingManager
```

</details>

---

## Generate

<p align="center">
  <table style="width:100%; text-align:center; border-spacing:20px;">
    <tr>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EB%8B%88%EC%B2%B4%20%EB%B3%80%ED%99%98%20%EB%B0%8F%20%EC%A0%80%EC%9E%A5.gif?raw=true" 
             alt="image 1" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EC%96%B8%EB%8D%94%EB%8D%94%EB%B6%80%EC%B2%98-%EA%B2%B0%EA%B3%BC%20%EB%B0%8F%20%EC%A0%80%EC%9E%A5.gif?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
      <td style="text-align:center; vertical-align:middle;">
        <p align="center">
        <img src="https://github.com/BOLTB0X/Pinger/blob/main/Img/%EB%A6%AC%EC%8A%A4%ED%8A%B8%EB%B7%B0.jpg?raw=true" 
             alt="image 2" 
             style="width:200px; height:400px; object-fit:contain; border:1px solid #ddd; border-radius:4px;"/>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        결과 반환 및 저장 1
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        결과 반환 및 저장 2
      </p>
      </td>
      <td style="text-align:center; font-size:14px; font-weight:bold;">
      <p align="center">
        list
      </p>
      </td>
    </tr>
  </table>
</p>

<details>
<summary> AI Code </summary>

```py
class ImageAI:
    def __init__(self):
        self.hed = HEDdetector.from_pretrained('lllyasviel/Annotators')

        # ControlNet Scribble 모델 로드
        self.controlnet = ControlNetModel.from_pretrained(
            "lllyasviel/sd-controlnet-scribble",
            torch_dtype=torch.float16
        )

        # Stable Diffusion 파이프라인 설정
        self.pipe = StableDiffusionControlNetPipeline.from_pretrained(
            "runwayml/stable-diffusion-v1-5",
            controlnet=self.controlnet,
            safety_checker=None,
            torch_dtype=torch.float16
        )

        self.pipe.scheduler = UniPCMultistepScheduler.from_config(self.pipe.scheduler.config)
        self.pipe.enable_model_cpu_offload()
    ## __init__(self)

    def generate_from_sketch(self, b64_string: str, prompt: str) -> str:
        init_image = self.__base64_to_pil(b64_string)

        detected_scribble = self.hed(init_image) # 선 감지

        output_image = self.pipe(
            prompt=prompt,
            image=detected_scribble,
            guidance_scale=7.5,
            num_inference_steps=30
        ).images[0]

        self.__save_to_drive(output_image, prompt)

        return self.__pil_to_base64(output_image)
    ## generate_from_sketch(self, b64_string: str, prompt: str)

    @staticmethod
    def __save_to_drive(img: Image.Image, prompt: str):
        save_dir = "/content/drive/MyDrive/"
        os.makedirs(save_dir, exist_ok=True)

        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"{timestamp}.png"
        save_path = os.path.join(save_dir, filename)
        img.save(save_path)
        print(f"이미지가 Google Drive에 저장되었습니다: {save_path}")
    ## __save_to_drive(img: Image.Image, prompt: str)

    @staticmethod
    def __base64_to_pil(b64_string: str) -> Image.Image:
        img_bytes = base64.b64decode(b64_string)
        img = Image.open(io.BytesIO(img_bytes)).convert("RGB")
        return img
    ## __base64_to_pil(b64_string: str)

    @staticmethod
    def __pil_to_base64(img: Image.Image) -> str:
        buffered = io.BytesIO()
        img.save(buffered, format="PNG")
        return base64.b64encode(buffered.getvalue()).decode()
    ## __pil_to_base64(img: Image.Image)
## class ImageAI
```

```py
@app.route("/generate", methods=["POST"])
def generate():
    data = request.json
    base64_image = data.get("image")
    prompt = data.get("prompt")

    if not base64_image or not prompt:
        return jsonify({"error": "Missing image or prompt"}), 400

    try:
        result_base64 = image_ai.generate_from_sketch(base64_image, prompt)
        return jsonify({"image": result_base64})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
## generate
```

</details>


<details>
<summary> generate (REST API) </summary>

```py
@app.route("/generate", methods=["POST"])
def generate():
    data = request.json
    base64_image = data.get("image")
    prompt = data.get("prompt")

    if not base64_image or not prompt:
        return jsonify({"error": "Missing image or prompt"}), 400

    try:
        result_base64 = image_ai.generate_from_sketch(base64_image, prompt)
        return jsonify({"image": result_base64})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
## generate
```
</details>

<details>
<summary> CRUD </summary>

```py
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
        base_name = filename
        extension = ".png"
        full_name = base_name + extension
        image_path = os.path.join(UPLOAD_FOLDER, full_name)

        count = 1
        while os.path.exists(image_path):
            full_name = f"{base_name}_{count}{extension}"
            image_path = os.path.join(UPLOAD_FOLDER, full_name)
            count += 1

        # 이미지 저장
        image.save(image_path)

        image_url = f"images/{full_name}"

        doc_ref = db.collection("generated_images").document()
        doc_ref.set({
            "doc_id": doc_ref.id,
            "prompt": prompt,
            "filename": full_name,
            "image_url": image_url,
            "timestamp": datetime.now().isoformat()
        })

        return jsonify({
            "message": "Saved successfully",
            "doc_id": doc_ref.id,
            "image_url": image_url
        }), 201

    except Exception as e:
        print(f"Error in create function: {e}")
        return jsonify({"error": str(e)}), 500
## create
```

```py
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
```

```py
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
```

```py
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
```

</details>


<details>
<summary> Maintenance Script </summary>

firebase(NoSQL) DB 수정, 데이터 정리, 백업 등 코드

- [fix_add_doc_id.py](https://github.com/BOLTB0X/Pinger/blob/main/pinger_backend/firebase/fix_add_doc_id.py)

- [fix_image_urls.py](https://github.com/BOLTB0X/Pinger/blob/main/pinger_backend/firebase/fix_image_urls.py)

- [remove_images_to_firebase.py](https://github.com/BOLTB0X/Pinger/blob/main/pinger_backend/firebase/remove_images_to_firebase.py)

- [sync_images_to_firestore.py](https://github.com/BOLTB0X/Pinger/blob/main/pinger_backend/firebase/sync_images_to_firestore.py)

</details>


## 참고

- [Hugging face](https://huggingface.co/)

    - [control_v11p_sd15_lineart](https://huggingface.co/lllyasviel/control_v11p_sd15_lineart)

    - [Stable Diffusion v1-5 ](https://huggingface.co/lllyasviel/sd-controlnet-scribble)

    - [ControlNet](https://huggingface.co/lllyasviel/ControlNet?source=post_page-----5f67979ea9a---------------------------------------)

    - [Interrogator](https://huggingface.co/spaces/pharmapsychotic/CLIP-Interrogator)

    - [AutoPipelineForImage2Image](https://huggingface.co/docs/diffusers/main/using-diffusers/img2img)

- [블로그 참조 - Hugging Face 회원가입, 토큰 발급, APIKEY 발급 방법, 개발 환경 설정](https://hunseop2772.tistory.com/372)

- [flutter dev - RenderRepaintBoundary](https://api.flutter.dev/flutter/rendering/RenderRepaintBoundary-class.html)

- [flutter dev - toImage](https://api.flutter.dev/flutter/rendering/RenderRepaintBoundary/toImage.html)

- [블로그 참고 - 뇌님 참고(HandshakeException: Handshake error in client (OS Error: CERTIFICATE_VERIFY_FAILED))](https://brain-nim.tistory.com/138)

- [Stackoverflow - Flutter HTTPS Handshake error in client (OS Error: CERTIFICATE_VERIFY_FAILED: ok(handshake.cc:363))](https://stackoverflow.com/questions/54928080/flutter-https-handshake-error-in-client-os-error-certificate-verify-failed-ok)

- [블로그 참고 - .env 파일 적용](https://velog.io/@marksen/Flutter-.env-%ED%8C%8C%EC%9D%BC-%EC%A0%81%EC%9A%A9)

- [블로그 참조 - tkayyoo(위젯으로 이미지 찍어내기)](https://tkayyoo.tistory.com/85)

- [블로그 참조 - Studying ITs(리눅스에서 파이썬 개발환경 구축)](https://authentic-information.tistory.com/35)

- [블로그 참조 - 고은별의 기술 공유 연구소(Flutter - 내가 만든 앱, 내 휴대폰으로 디버깅 하기)](https://luvris2.tistory.com/715#google_vignette)

- [블로그 참조 - 까사파파(FloatingActionButton 여러개 사용시 에러및 오류 해결 하는 법)](https://casapapa.tistory.com/40)

- [블로그 참조 - 영로그(클린 아키텍처 쉽게 이해하기)](https://heui-yong.github.io/flutter/post-flutter-clean-architecture/)

- [Flutter pub - painter](https://pub.dev/packages/painter)

- [블로그 참고 - 마느아의 전산 공부 블로그(AppBar 총정리(flutter))](https://learncom1234.tistory.com/17)

- [오픈 소스 - 플라스크 REST API 튜토리얼](https://colab.research.google.com/github/PyTorchKorea/tutorials-kr/blob/master/docs/_downloads/786469bd4d28fe2528b92a6d12fb189e/flask_rest_api_tutorial.ipynb)

- [블로그 참고 - dev-nam(키보드가 열렸는지 닫혔는지 확인하는 방법)](https://dev-nam.tistory.com/30)

- [블로그 참고 - 참깨빵위에참깨빵_(BottomSheet 사용법)](https://onlyfor-me-blog.tistory.com/1088)

- [Medium - Flutter Community(Build a Custom Bottom Navigation Bar in Flutter with Animated Icons from Rive)](https://medium.com/flutter-community/build-a-custom-bottom-navigation-bar-in-flutter-with-animated-icons-from-rive-13651bc80629)

- [블로그 참고 - day0404(Flutter Animation 만들기 (with Provider))](https://day0404.tistory.com/51)

