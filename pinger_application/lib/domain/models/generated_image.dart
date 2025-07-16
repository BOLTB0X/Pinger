import '../../data/models/generated_image_dto.dart';

class GeneratedImage {
  final String docId;
  final String prompt;
  final String filename;
  final String imageUrl;
  final DateTime timestamp;

  GeneratedImage({
    required this.docId,
    required this.prompt,
    required this.filename,
    required this.imageUrl,
    required this.timestamp,
  }); // init

  factory GeneratedImage.fromJson(Map<String, dynamic> json) {
    return GeneratedImage(
      docId: json['doc_id'],
      prompt: json['prompt'],
      filename: json['filename'],
      imageUrl: json['image_url'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  } // fromJson

  GeneratedImageDTO toDTO() {
    return GeneratedImageDTO(
      docId: docId,
      prompt: prompt,
      filename: filename,
      imageUrl: imageUrl,
      timestamp: timestamp,
    );
  } // toDTO
} // GeneratedImage
