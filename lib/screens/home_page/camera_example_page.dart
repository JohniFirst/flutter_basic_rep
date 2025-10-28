import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CameraExamplePage extends StatefulWidget {
  const CameraExamplePage({super.key});

  @override
  State<CameraExamplePage> createState() => _CameraExamplePageState();
}

class _CameraExamplePageState extends State<CameraExamplePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() {
          _image = File(photo.path);
        });
      }
    } catch (e) {
      // 处理相机相关错误
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('相机调用失败: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('相机示例'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '拍摄照片示例',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // 相机预览或照片展示区域
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: _image != null
                    ? Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera, size: 80, color: Colors.grey),
                            SizedBox(height: 10),
                            Text('点击下方按钮拍照'),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 30),
              
              // 操作按钮区域
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('拍照'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  
                  if (_image != null)
                    const SizedBox(width: 20),
                  
                  if (_image != null)
                    ElevatedButton.icon(
                      onPressed: _resetImage,
                      icon: const Icon(Icons.refresh),
                      label: const Text('重拍'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              
              // 提示信息
              const Text(
                '点击拍照按钮将调用系统相机功能\n请确保已授予相机权限',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}