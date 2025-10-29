import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String itemName;

  const DetailPage({super.key, required this.itemName});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _selectedButtonIndex = 0; // 当前选中的按钮索引
  final List<String> _buttonLabels = ['详情', '评论'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemName),
        // 在AppBar的bottom中放置居中的按钮组
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              // 让容器只包裹按钮组
              width: null,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade100
                      : Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _buttonLabels.asMap().entries.map((entry) {
                    final index = entry.key;
                    final label = entry.value;
                    final isSelected = index == _selectedButtonIndex;

                    return TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedButtonIndex = index;
                        });
                      },
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(
                          isSelected ? Colors.white : Colors.grey,
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          isSelected ? Colors.red : Colors.transparent,
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: isSelected
                                ? BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  )
                                : BorderSide.none,
                          ),
                        ),
                        minimumSize: WidgetStateProperty.all(Size.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(label),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('您正在查看: ${widget.itemName}'),
            const SizedBox(height: 20),
            Text('当前选中的选项卡: ${_buttonLabels[_selectedButtonIndex]}'),
          ],
        ),
      ),
    );
  }
}
