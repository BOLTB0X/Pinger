//import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/canvas_viewmodel.dart';
import '../extension/canvas_dialog_buildContext.dart';
import '../../domain/draw/drawing_canvas.dart';
import '../widget/icon_action_button.dart';
import '../widget/floating_function_button.dart';
import '../widget/prompt_textfield.dart';
import '../widget/stroke_slider.dart';

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
        title: const Text('Pinger'),
        backgroundColor: Colors.blue,
        actions: _buildAppbarActions(viewModel),
        bottom: _buildAppbarBottom(viewModel),
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
    final isInputModeActive = viewModel.isInputModeActive;
    return [
      IconActionButton(
        icon: viewModel.showPrompt ? Icons.check : Icons.keyboard,
        tooltip: '프롬프트 입력',
        onPressed: viewModel.togglePromptField,
        isEnabled: !viewModel.showSlider,
      ),
      IconActionButton(
        icon: Icons.arrow_back,
        tooltip: '실행 취소',
        onPressed: viewModel.undo,
        isEnabled: !isInputModeActive,
      ),
      IconActionButton(
        icon: Icons.arrow_forward,
        tooltip: '다시 실행',
        onPressed: viewModel.redo,
        isEnabled: !isInputModeActive,
      ),
      IconActionButton(
        icon: viewModel.showSlider ? Icons.check : Icons.line_style_rounded,
        tooltip: '팬 굵기',
        onPressed: viewModel.toggleSlider,
        isEnabled: !viewModel.showPrompt,
      ),
      IconActionButton(
        icon: viewModel.isErasing
            ? Icons.auto_fix_off_rounded
            : Icons.auto_fix_normal_rounded,
        tooltip: '지우기',
        onPressed: viewModel.toggleEraser,
        isEnabled: !isInputModeActive,
      ),
      IconActionButton(
        icon: Icons.delete,
        tooltip: '전체 삭제',
        onPressed: viewModel.clear,
        isEnabled: !isInputModeActive,
      ),
    ];
  } // _buildAppbarActions

  PreferredSizeWidget? _buildAppbarBottom(CanvasViewModel viewModel) {
    if (viewModel.showPrompt) {
      return PromptTextField(
        controller: viewModel.promptController,
        prompt: viewModel.prompt,
        isPromptEmpty: viewModel.isPromptEmpty,
        onChanged: viewModel.updatePrompt,
      );
    } else if (viewModel.showSlider) {
      return StrokeSlider(
        strokeWidth: viewModel.strokeWidth,
        onChanged: viewModel.updateStrokeWidth,
      );
    }
    return null;
  } // _buildAppbarBottom

  Widget _buildFloatingActionButton(CanvasViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingFunctionButton(
            icon: Icons.check,
            heroTag: 'generate',
            tooltip: 'Generate',
            onPressed: () async {
              await viewModel.fetchGeneratedImage(_canvasKey, "/generate");
            },
            foregroundColor: Colors.black,
            backgroundColor: Colors.blue,
          ),
          const SizedBox(width: 12),
          FloatingFunctionButton(
            icon: Icons.save,
            heroTag: 'save',
            tooltip: 'save',
            onPressed: () {},
            foregroundColor: Colors.black,
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  } // _buildFloatingActionButton
} // _CanvasViewState
