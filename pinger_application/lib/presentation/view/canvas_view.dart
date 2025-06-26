import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/canvas_viewmodel.dart';
import '../extension/canvas_dialog_buildContext.dart';
import '../widget/icon_action_button.dart';
import '../widget/floating_function_button.dart';
import '../widget/prompt_textfield.dart';
import '../widget/stroke_slider.dart';
import '../../domain/draw/drawing_canvas.dart';
import 'result_view.dart';

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
        actions: _editActions(viewModel),
        bottom: _stateBottom(viewModel),
      ),
      body: DrawingCanvas(repaintKey: _canvasKey),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _networkActions(viewModel),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ResultView(imageBytes: img, prompt: viewModel.prompt),
            ),
          );
        } // if
        break;
      case CanvasStatus.idle:
      default:
        break;
    } // switch
  } // _handleStatus

  List<Widget> _editActions(CanvasViewModel viewModel) {
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
  } // _editActions

  PreferredSizeWidget? _stateBottom(CanvasViewModel viewModel) {
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
  } // _stateBottom

  Widget _networkActions(CanvasViewModel viewModel) {
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
              await viewModel.fetchGeneratedImage(_canvasKey);
            },
            foregroundColor: Colors.black,
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  } // _networkActions
} // _CanvasViewState
