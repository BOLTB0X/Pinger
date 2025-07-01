import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/canvas_viewmodel.dart';
import '../extension/canvas_dialog_buildContext.dart';
import '../widget/icon_action_button.dart';
import '../widget/input_textfield.dart';
import '../widget/stroke_slider.dart';
import '../../domain/entities/drawing_canvas.dart';
import 'result_view.dart';
import 'image_list_view.dart';

class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
} // CanvasView

class _CanvasViewState extends State<CanvasView>
    with SingleTickerProviderStateMixin {
  final GlobalKey _canvasKey = GlobalKey();

  late final AnimationController _slideController;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
  } // initState

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  } // dispose

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
      body: Stack(
        children: [
          DrawingCanvas(repaintKey: _canvasKey),
          _buildEditBar(viewModel),
        ],
      ),
    );
  } // build

  void _handleStatus(CanvasViewModel viewModel) {
    switch (viewModel.status) {
      case CanvasStatus.loading:
        context.showLoadingDialog("Creating image...");
        break;
      case CanvasStatus.error:
        Navigator.popUntil(context, (route) => route.isFirst);
        context.showStateDialog("Fail", "AI image creation failed", () {
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
              builder: (_) => ResultView(
                imageBytes: img,
                prompt: viewModel.prompt,
                sketches: viewModel.drawingManager.sketches,
              ),
            ),
          );
        } // if
        break;

      case CanvasStatus.my:
        viewModel.resetStatus();
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ImageListView()),
        );
        break;
      default:
        break;
    } // switch
  } // _handleStatus

  List<Widget> _editActions(CanvasViewModel viewModel) {
    return [
      IconActionButton(
        icon: viewModel.showEditBar ? Icons.close : Icons.settings,
        tooltip: '편집 모드',
        onPressed: () {
          setState(() {
            viewModel.toggleEditBar();
            if (viewModel.showEditBar) {
              _slideController.forward();
            } else {
              _slideController.reverse();
            }
          });
        },
        isEnabled: true,
      ),

      IconActionButton(
        icon: Icons.list,
        tooltip: '리스트',
        onPressed: () {
          viewModel.moveToMyList();
        },
        isEnabled: true,
      ),

      IconActionButton(
        icon: Icons.input,
        tooltip: '이미지 생성',
        onPressed: () async {
          await viewModel.fetchGeneratedImage(_canvasKey);
        },
        isEnabled: !viewModel.showEditBar,
      ),
    ];
  } // _editActions

  PreferredSizeWidget? _stateBottom(CanvasViewModel viewModel) {
    if (viewModel.showPrompt) {
      return InputTextField(
        controller: viewModel.promptController,
        inputString: viewModel.prompt,
        hintText: "Enter your prompt",
        errorText: "prompt is empty",
        isInputEmpty: viewModel.isPromptEmpty,
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

  Widget _buildEditBar(CanvasViewModel viewModel) {
    final isInputModeActive = viewModel.isInputModeActive;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black26,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconActionButton(
                  icon: viewModel.showPrompt ? Icons.check : Icons.keyboard,
                  tooltip: '프롬프트 입력',
                  onPressed: viewModel.togglePromptField,
                  isEnabled: !viewModel.showSlider,
                ),
                IconActionButton(
                  icon: viewModel.showSlider ? Icons.check : Icons.edit,
                  tooltip: '팬 굵기',
                  onPressed: viewModel.toggleSlider,
                  isEnabled: !viewModel.showPrompt,
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
              ],
            ),
          ),
        ),
      ),
    );
  } // _buildEditBar
} // _CanvasViewState
