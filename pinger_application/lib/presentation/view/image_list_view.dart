import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/image_list_viewmodel.dart';

class ImageListView extends StatelessWidget {
  const ImageListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ImageListViewModel>();
    final images = viewModel.images;
    final isLoading = viewModel.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Images'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.loadImages(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : images.isEmpty
          ? const Center(child: Text("No images found"))
          : ListView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return ListTile(
                  leading: const Icon(Icons.image),
                  title: Text(image.filename),
                  subtitle: Text(image.prompt),
                  onTap: () {
                    // TODO: 상세화면 이동
                  },
                );
              },
            ),
    );
  } // build
} // ImageListView
