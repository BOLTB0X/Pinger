//import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/canvas_viewmodel.dart';
import '../extension/canvas_dialog_buildContext.dart';
import '../../domain/draw/drawing_canvas.dart';

class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
} // CanvasView

class _CanvasViewState extends State<CanvasView> {
  final GlobalKey _canvasKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CanvasViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleStatus(viewModel);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pinger Sketch'),
        backgroundColor: Colors.blue,
        actions: _buildAppbarActions(viewModel),
        bottom: viewModel.showPrompt ? _buildAppbarBottom(viewModel) : null,
      ),
      body: DrawingCanvas(repaintKey: _canvasKey),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildFloatingActionButton(viewModel),
    ); // Scaffold
  } // build

  void _handleStatus(CanvasViewModel viewModel) {
    switch (viewModel.status) {
      case CanvasStatus.loading:
        context.showLoadingDialog();
        break;
      case CanvasStatus.error:
        Navigator.popUntil(context, (route) => route.isFirst);
        context.showErrorDialog(() {
          viewModel.resetStatus();
          Navigator.pop(context);
        });
        break;
      case CanvasStatus.success:
        viewModel.resetStatus();
        Navigator.popUntil(context, (route) => route.isFirst);
        if (viewModel.resultImage case final img?) {
          context.showGeneratedImageBottomSheet(img, () {
            viewModel.resetStatus();
            Navigator.pop(context);
          });
        }
        break;
      case CanvasStatus.idle:
      default:
        break;
    } // switch
  } // _handleStatus

  List<Widget> _buildAppbarActions(CanvasViewModel viewModel) {
    return [
      IconButton(
        icon: Icon(viewModel.showPrompt ? Icons.check : Icons.keyboard),
        tooltip: '프롬프트 입력',
        onPressed: () => viewModel.togglePromptField(),
      ),
      IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: '실행 취소',
        onPressed: () => viewModel.undo(),
      ),
      IconButton(
        icon: const Icon(Icons.arrow_forward),
        tooltip: '다시 실행',
        onPressed: () => viewModel.redo(),
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        tooltip: '전체 삭제',
        onPressed: () => viewModel.clear(),
      ),
    ];
  } // _buildAppbarActions

  PreferredSize _buildAppbarBottom(CanvasViewModel viewModel) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          controller: viewModel.promptController,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: viewModel.prompt,
            hintText: "Enter your prompt",
            labelStyle: const TextStyle(color: Colors.black),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                width: 1,
                color: viewModel.isPromptEmpty ? Colors.redAccent : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                width: 1,
                color: viewModel.isPromptEmpty ? Colors.redAccent : Colors.grey,
              ),
            ),
            errorText: viewModel.isPromptEmpty ? 'prompt is empty' : null,
          ),
          onChanged: viewModel.updatePrompt,
        ),
      ),
    );
  } // _buildAppbarBottom

  Widget _buildFloatingActionButton(CanvasViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'generate',
            tooltip: 'Generate',
            onPressed: () async {
              await viewModel.fetchGeneratedImage(_canvasKey, "/generate");
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.check),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'save',
            tooltip: 'save',
            onPressed: () {},
            backgroundColor: Colors.blue,
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  } // _buildFloatingActionButton
} // _CanvasViewState
