import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import '../widget/floating_function_button.dart';
import '../widget/input_textfield.dart';
import '../viewmodel/result_viewmodel.dart';
import '../extension/canvas_dialog_buildContext.dart';
import '../../domain/models/sketch.dart';

class ResultView extends StatefulWidget {
  final Uint8List imageBytes;
  final String prompt;
  final List<Sketch> sketches;

  const ResultView({
    super.key,
    required this.imageBytes,
    required this.prompt,
    required this.sketches,
  });

  @override
  State<ResultView> createState() => _ResultViewState();
} // ResultView

class _ResultViewState extends State<ResultView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResultViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleStatus(viewModel);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.black),
        title: GestureDetector(
          onTap: viewModel.toggleTitleField,
          child: const Text("Generated Image"),
        ),
        bottom: _stateBottom(viewModel),
      ),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(widget.imageBytes),
        ),
      ),
      floatingActionButton: _networkActions(viewModel),
    );
  } // _build

  void _handleStatus(ResultViewModel viewModel) {
    switch (viewModel.status) {
      case SaveStatus.saving:
        if (ModalRoute.of(context)?.isCurrent == true) {
          context.showLoadingDialog("Saving image...");
        }
        break;

      case SaveStatus.success:
        Navigator.pop(context); // 다이얼로그 닫기
        context.showStateDialog(
          "Complete",
          "The image was saved successfully",
          () {
            viewModel.resetStatus();
            Navigator.pop(context); // 화면 나가기
          },
        );
        break;

      case SaveStatus.error:
        Navigator.pop(context); // 다이얼로그 닫기
        context.showStateDialog("Fail", "AI image save failed.", () {
          viewModel.resetStatus();
          Navigator.pop(context); // 화면 나가기
        });
        break;

      default:
        break;
    }
  } // _handleStatus

  PreferredSizeWidget? _stateBottom(ResultViewModel viewModel) {
    if (viewModel.showTitleField) {
      return InputTextField(
        controller: viewModel.titleController,
        inputString: viewModel.fileName,
        hintText: "Enter image filename",
        errorText: "filename is empty",
        isInputEmpty: viewModel.isFileNameEmpty,
        onChanged: viewModel.updateFileName,
      );
    }
    return null;
  } // _stateBottom

  Widget _networkActions(ResultViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingFunctionButton(
            icon: Icons.save,
            heroTag: 'save',
            tooltip: 'save',
            onPressed: () {
              viewModel.requestSave(
                widget.imageBytes,
                widget.prompt,
                viewModel.fileName,
                widget.sketches,
              );
            },
            foregroundColor: Colors.black,
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  } // _networkActions
} // _ResultViewState
