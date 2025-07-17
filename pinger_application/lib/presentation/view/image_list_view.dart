import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/models/generated_image.dart';
import '../viewmodel/image_list_viewmodel.dart';
import '../extension/canvas_dialog_buildContext.dart';

class ImageListView extends StatefulWidget {
  const ImageListView({super.key});

  @override
  State<ImageListView> createState() => _ImageListViewState();
} // ImageListView

class _ImageListViewState extends State<ImageListView> {
  Widget build(BuildContext context) {
    final viewModel = context.watch<ImageListViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Generated Images")),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: viewModel.loadImages,
              child: ListView.builder(
                itemCount: viewModel.images.length,
                itemBuilder: (context, index) {
                  final image = viewModel.images[index];
                  final isEditing = viewModel.editingDocId == image.docId;
                  return isEditing
                      ? _buildEditingTile(context, viewModel, image)
                      : _buildImageTile(context, viewModel, image);
                },
              ),
            ),
    );
  } // build

  Widget _buildListView(ImageListViewModel viewModel) {
    final images = viewModel.images;
    final isLoading = viewModel.isLoading;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (images.isEmpty) {
      return const Center(child: Text("No images found"));
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.loadImages(),
      child: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return _buildImageTile(context, viewModel, images[index]);
        },
      ),
    );
  } // _buildListView

  Widget _buildImageTile(
    BuildContext context,
    ImageListViewModel viewModel,
    GeneratedImage image,
  ) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: '${viewModel.url}/${image.imageUrl}',
        placeholder: (context, url) =>
            const CircularProgressIndicator(strokeWidth: 2),
        errorWidget: (context, url, error) {
          CachedNetworkImage.evictFromCache(url);
          return const Icon(Icons.error);
        },
        width: 48,
        height: 48,
        fit: BoxFit.cover,
      ),
      title: Text(image.filename),
      subtitle: Text(image.prompt),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.blue),
        onPressed: () => _confirmDelete(context, viewModel, image),
      ),
    );
  } // _buildImageTile

  Future<void> _confirmDelete(
    BuildContext context,
    ImageListViewModel viewModel,
    GeneratedImage image,
  ) async {
    final confirm = await context.showConfirmDialog(
      title: 'Confirm deletion',
      content: 'Are you sure you want to delete "${image.filename}"?',
      confirmText: "Delete",
    );

    if (confirm == true) {
      final success = await viewModel.deleteImage(image.docId);
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('success')));
      } else {
        context.showStateDialog(
          "Delete failed",
          "Failed to delete the image. Please try again later.",
          () => Navigator.pop(context),
        );
      }
    } // if
  } // _confirmDelete

  Widget _buildEditingTile(
    BuildContext context,
    ImageListViewModel viewModel,
    GeneratedImage image,
  ) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: '${viewModel.url}/${image.imageUrl}',
        width: 48,
        height: 48,
        fit: BoxFit.cover,
      ),
      title: Row(
        children: [
          Expanded(
            child: TextField(
              controller: viewModel.editingController,
              autofocus: true,
              decoration: const InputDecoration(border: InputBorder.none),
              onSubmitted: (_) => viewModel.saveFileName(image),
            ),
          ),
          const Text('.png'),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.check, color: Colors.blue),
        onPressed: () => viewModel.saveFileName(image),
      ),
    );
  } // _buildEditingTile
} // _ImageListViewState
