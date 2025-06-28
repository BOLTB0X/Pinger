class GeneratedImageMetadata {
  final String id;
  final String prompt;
  final String filename;
  final DateTime timestamp;

  GeneratedImageMetadata({
    required this.id,
    required this.prompt,
    required this.filename,
    required this.timestamp,
  }); // init

  factory GeneratedImageMetadata.fromJson(Map<String, dynamic> json) {
    return GeneratedImageMetadata(
      id: json['id'],
      prompt: json['prompt'],
      filename: json['filename'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  } // GeneratedImageMetadata.fromJson
} // GeneratedImageMetadata
