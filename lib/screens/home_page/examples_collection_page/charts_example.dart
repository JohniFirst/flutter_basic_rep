import 'package:flutter/material.dart';

class StepProgressWidget extends StatelessWidget {
  final List<StepItem> steps;

  const StepProgressWidget({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        return _buildStepRow(index);
      }),
    );
  }

  Widget _buildStepRow(int index) {
    final step = steps[index];
    final isLast = index == steps.length - 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 步骤指示器（圆形+状态）
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: step.isCompleted ? Colors.grey : Colors.grey.shade300,
              width: 2,
            ),
            color: step.isCompleted ? Colors.teal : Colors.grey.shade300,
          ),
          child: step.isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : null,
        ),
        const SizedBox(width: 8),
        // 步骤文字+垂直虚线
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 步骤标题和状态
            Row(
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: step.isCompleted ? Colors.black87 : Colors.black54,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  step.statusText,
                  style: TextStyle(
                    fontSize: 16,
                    color: step.isCompleted ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            // 自定义垂直虚线（替代VerticalDivider，兼容所有版本）
            if (!isLast)
              Container(
                margin: const EdgeInsets.only(left: 0, top: 4, bottom: 4),
                width: 1, // 线宽
                height: 40, // 线长
                child: CustomPaint(painter: DashedLinePainter()),
              ),
          ],
        ),
      ],
    );
  }
}

// 自定义虚线画笔
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors
          .grey // 虚线颜色
      ..strokeWidth = size
          .width // 线宽（和容器宽度一致）
      ..style = PaintingStyle.stroke;

    // 虚线样式：[线段长度, 间隔长度]
    const dashPattern = [4.0, 4.0];
    double distance = 0;
    final path = Path();
    path.moveTo(0, 0); // 起点（左侧顶部）

    while (distance < size.height) {
      // 绘制线段
      for (int i = 0; i < dashPattern.length; i++) {
        final length = dashPattern[i];
        if (distance + length > size.height) {
          // 超出总长度时，绘制剩余部分
          path.lineTo(0, size.height);
          distance = size.height;
          break;
        }
        if (i % 2 == 0) {
          // 实线部分
          path.lineTo(0, distance + length);
        } else {
          // 空白部分（移动画笔，不绘制）
          path.moveTo(0, distance + length);
        }
        distance += length;
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 步骤数据模型（不变）
class StepItem {
  final String title;
  final String statusText;
  final bool isCompleted;

  StepItem({
    required this.title,
    required this.statusText,
    required this.isCompleted,
  });
}

// 使用示例（不变）
class ChartsExample extends StatelessWidget {
  const ChartsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final List<StepItem> steps = [
      StepItem(title: "注册", statusText: "已完成", isCompleted: true),
      StepItem(title: "身份认证", statusText: "已完成", isCompleted: true),
      StepItem(title: "基础信息", statusText: "已完成", isCompleted: true),
      StepItem(title: "工作信息", statusText: "未完成", isCompleted: false),
      StepItem(title: "其他信息", statusText: "未完成", isCompleted: false),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StepProgressWidget(steps: steps),
      ),
    );
  }
}
