import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import '../widget/floating_function_button.dart';
import '../viewmodel/result_viewmodel.dart';

class ResultView extends StatelessWidget {
  final Uint8List imageBytes;
  final String prompt;

  const ResultView({super.key, required this.imageBytes, required this.prompt});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResultViewModel>();
    final filename = viewModel.titleController.text.isNotEmpty
        ? viewModel.titleController.text
        : "image_${DateTime.now().millisecondsSinceEpoch}";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.black),
        title: GestureDetector(
          onTap: () => viewModel.toggleTitleField(),
          child: const Text("Generated Image"),
        ),
        bottom: viewModel.showTitleField
            ? PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: viewModel.titleController,
                    decoration: const InputDecoration(
                      hintText: "Enter image filename",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(imageBytes),
        ),
      ),
      floatingActionButton: FloatingFunctionButton(
        icon: Icons.save,
        heroTag: 'save',
        tooltip: 'save',
        onPressed: () {
          viewModel.requestSave(
            imageBytes,
            prompt,
            filename,
            () => _onSuccess(context),
            () => _onFailure(context),
          );
        },
        foregroundColor: Colors.black,
        backgroundColor: Colors.blue,
      ),
    );
  } // build

  void _onSuccess(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Save success")));
  } // _onSuccess

  void _onFailure(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Save fail")));
  } // _onFailure
} // ResultView
