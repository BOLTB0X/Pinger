import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodel/image_list_viewmodel.dart';

class ImageListView extends StatefulWidget {
  const ImageListView({super.key});

  @override
  State<ImageListView> createState() => _ImageListViewState();
} // ImageListView

class _ImageListViewState extends State<ImageListView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ImageListViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: _listView(viewModel),
    );
  } // build

  Widget _listView(ImageListViewModel viewModel) {
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
          final image = images[index];
          return ListTile(
            leading: CachedNetworkImage(
              imageUrl: '${image.imageUrl}',
              placeholder: (context, url) =>
                  const CircularProgressIndicator(strokeWidth: 2),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
            title: Text(image.filename),
            subtitle: Text(image.prompt),
            onTap: () {
              // TODO: 상세 페이지 이동
              print('${viewModel.url}${image.imageUrl}');
            },
          );
        },
      ),
    );
  } // _listView
} // _ImageListViewState
