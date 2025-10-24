import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  // 文本输入
  String _textInput = ''; // 用于保存姓名输入
  String _passwordInput = ''; // 用于保存密码输入
  String _emailInput = ''; // 用于保存邮箱输入
  String _multilineText = ''; // 用于保存个人简介

  // 选择控件
  String? _selectedDropdownValue;
  bool _isChecked = false;
  bool _isSwitched = false;

  // 单选按钮组
  String? _selectedRadioValue;

  // 滑块和范围滑块
  double _sliderValue = 50.0;
  RangeValues _rangeSliderValues = const RangeValues(20.0, 80.0);

  // 日期和时间
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // 颜色选择
  Color _selectedColor = Colors.blue;

  // 文件选择（模拟）
  String? _selectedFile;

  // 表单提交
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // 使用保存的字段值
      String formData =
          '表单数据:\n'
          '姓名: $_textInput\n'
          '邮箱: $_emailInput\n'
          '密码长度: ${_passwordInput.length} 位\n'
          '协议同意: $_isChecked\n'
          '通知设置: $_isSwitched\n'
          '性别: $_selectedRadioValue\n'
          '年龄: ${_sliderValue.round()}\n'
          '个人简介: $_multilineText';

      // 显示提交成功的对话框，包含表单数据
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('提交成功'),
          content: SingleChildScrollView(child: Text(formData)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        ),
      );
    }
  }

  // 选择日期
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 选择时间
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // 选择颜色
  void _selectColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择颜色'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              for (var color in [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.purple,
                Colors.orange,
              ])
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(
                          color: _selectedColor == color
                              ? Colors.black
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              const Text(
                '各种表单输入控件示例',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 文本输入
              const Text(
                '文本输入',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '姓名',
                  border: OutlineInputBorder(),
                  hintText: '请输入您的姓名',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入姓名';
                  }
                  return null;
                },
                onSaved: (value) {
                  _textInput = value!;
                },
              ),
              const SizedBox(height: 16),

              // 密码输入
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '密码',
                  border: OutlineInputBorder(),
                  hintText: '请输入密码',
                  suffixIcon: Icon(Icons.visibility),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入密码';
                  }
                  if (value.length < 6) {
                    return '密码长度至少为6位';
                  }
                  return null;
                },
                onSaved: (value) {
                  _passwordInput = value!;
                },
              ),
              const SizedBox(height: 16),

              // 邮箱输入
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '邮箱',
                  border: OutlineInputBorder(),
                  hintText: '请输入邮箱地址',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入邮箱';
                  }
                  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                  if (!emailRegex.hasMatch(value)) {
                    return '请输入有效的邮箱地址';
                  }
                  return null;
                },
                onSaved: (value) {
                  _emailInput = value!;
                },
              ),
              const SizedBox(height: 16),

              // 多行文本输入
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '个人简介',
                  border: OutlineInputBorder(),
                  hintText: '请输入您的个人简介',
                ),
                maxLines: 3,
                onSaved: (value) {
                  _multilineText = value ?? '';
                },
              ),
              const SizedBox(height: 24),

              // 选择控件
              const Text(
                '选择控件',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // 下拉菜单
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '选择城市',
                  border: OutlineInputBorder(),
                ),
                initialValue: _selectedDropdownValue,
                items: const [
                  DropdownMenuItem(value: 'beijing', child: Text('北京')),
                  DropdownMenuItem(value: 'shanghai', child: Text('上海')),
                  DropdownMenuItem(value: 'guangzhou', child: Text('广州')),
                  DropdownMenuItem(value: 'shenzhen', child: Text('深圳')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDropdownValue = value;
                  });
                },
                onSaved: (value) {
                  _selectedDropdownValue = value;
                },
              ),
              const SizedBox(height: 16),

              // 复选框
              CheckboxListTile(
                title: const Text('我已阅读并同意用户协议'),
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // 开关
              SwitchListTile(
                title: const Text('接收推送通知'),
                value: _isSwitched,
                onChanged: (value) {
                  setState(() {
                    _isSwitched = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // 单选按钮组
              const Text('性别：', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedRadioValue = 'male';
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedRadioValue == 'male'
                                    ? Colors.blue
                                    : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: _selectedRadioValue == 'male'
                                ? const Center(
                                    child: CircleAvatar(
                                      radius: 6,
                                      backgroundColor: Colors.blue,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          const Text('男'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedRadioValue = 'female';
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedRadioValue == 'female'
                                    ? Colors.blue
                                    : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: _selectedRadioValue == 'female'
                                ? const Center(
                                    child: CircleAvatar(
                                      radius: 6,
                                      backgroundColor: Colors.blue,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          const Text('女'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 滑块
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('年龄滑块：'),
                  Slider(
                    value: _sliderValue,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: _sliderValue.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 范围滑块
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('价格范围：'),
                  RangeSlider(
                    values: _rangeSliderValues,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    labels: RangeLabels(
                      _rangeSliderValues.start.round().toString(),
                      _rangeSliderValues.end.round().toString(),
                    ),
                    onChanged: (values) {
                      setState(() {
                        _rangeSliderValues = values;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 日期和时间选择
              const Text(
                '日期和时间',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // 日期选择器
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  _selectedDate == null
                      ? '选择日期'
                      : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                ),
              ),
              const SizedBox(height: 16),

              // 时间选择器
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text(
                  _selectedTime == null
                      ? '选择时间'
                      : _selectedTime!.format(context),
                ),
              ),
              const SizedBox(height: 16),

              // 颜色选择
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('选择颜色：'),
                  ElevatedButton(
                    onPressed: _selectColor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedColor,
                    ),
                    child: const Text('选择颜色'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 文件选择（模拟）
              ElevatedButton(
                onPressed: () {
                  // 模拟文件选择
                  setState(() {
                    _selectedFile = 'sample_file.pdf';
                  });
                },
                child: _selectedFile == null
                    ? const Text('选择文件')
                    : Text('已选择：$_selectedFile'),
              ),
              const SizedBox(height: 32),

              // 提交按钮
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('提交表单'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
