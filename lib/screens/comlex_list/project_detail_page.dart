import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../services/utility_services.dart';
import 'package:intl/intl.dart';
import 'complex_list_page.dart'; // 导入数据模型

class ProjectDetailPage extends StatefulWidget {
  final int projectId;
  final ProjectItem? projectItem; // 可选的预加载数据

  const ProjectDetailPage({
    super.key,
    required this.projectId,
    this.projectItem,
  });

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  ProjectItem? _project;
  bool _isLoading = false;
  String? _error;
  // 缓存DateFormat实例避免重复创建
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  void initState() {
    super.initState();
    if (widget.projectItem != null) {
      _project = widget.projectItem;
    } else {
      _fetchProjectDetails();
    }
  }

  Future<void> _fetchProjectDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 调用真实API - 适配Android设备
      // 对于Android模拟器，使用10.0.2.2访问主机上的localhost
      // 对于真机测试，需要使用计算机的实际IP地址
      final apiUrl = 'http://192.168.11.94:3001/complex-list'; // 模拟器地址

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> projectsList = data['data'];

        // 过滤出匹配ID的项目
        final projectData = projectsList.firstWhere(
          (item) => item['id'] == widget.projectId,
          orElse: () => null,
        );

        if (projectData != null) {
          setState(() {
            _project = ProjectItem.fromJson(projectData);
            _isLoading = false;
          });
        } else {
          throw Exception('项目不存在');
        }
      } else {
        throw Exception('服务器错误: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _error = error.toString();
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('项目详情'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('加载失败: $_error'),
                  ElevatedButton(
                    onPressed: _fetchProjectDetails,
                    child: const Text('重试'),
                  ),
                ],
              ),
            )
          : _project == null
          ? const Center(child: Text('项目不存在'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 项目标题和状态
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _project!.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            _project!.status,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _project!.status,
                          style: TextStyle(
                            color: _getStatusColor(_project!.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 优先级
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(
                          _project!.priority,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _project!.priority,
                        style: TextStyle(
                          color: _getPriorityColor(_project!.priority),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // 描述
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      _project!.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),

                  const Divider(),

                  // 作者信息
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      '作者信息',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                child: Text(
                                  _project!.author.name.substring(0, 1),
                                  style: const TextStyle(fontSize: 32),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _project!.author.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _project!.author.role,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 4),
                                  InkWell(
                                    onTap: () {
                                      UtilityServices.launchEmailApp(
                                        _project!.author.contact.email,
                                        context,
                                      );
                                    },
                                    child: Text(
                                      _project!.author.contact.email,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      UtilityServices.launchPhoneApp(
                                        _project!.author.contact.phone,
                                        context,
                                      );
                                    },
                                    child: Text(
                                      _project!.author.contact.phone,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      UtilityServices.launchBrowser(
                                        'http://www.baidu.com',
                                        context,
                                      );
                                    },
                                    child: Text(
                                      'http://www.baidu.com',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(),

                  // 时间信息
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.create,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '创建时间: ${_dateFormat.format(_project!.createdAt)}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.update,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '更新时间: ${_dateFormat.format(_project!.updatedAt)}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  // 标签
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      '标签',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: _project!.metadata.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey[300] ?? Colors.grey,
                          ),
                        ),
                        child: Text(tag, style: TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                  ),

                  const Divider(),

                  // 统计信息
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      '统计信息',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // 进度条
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('完成进度'),
                                  Text('${_project!.statistics.progress}%'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: _project!.statistics.progress / 100,
                                backgroundColor: Colors.grey[200],
                                color: Colors.blue,
                                minHeight: 10,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '完成率: ${_project!.statistics.completionRate}',
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),

                          // 性能指标
                          const Text(
                            '性能指标',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Icon(
                                    Icons.speed,
                                    size: 32,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '响应速度',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  Text(
                                    _project!.statistics.performance.speed,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.trending_up,
                                    size: 32,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '效率',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  Text(
                                    _project!.statistics.performance.efficiency,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.storage,
                                    size: 32,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '资源占用',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  Text(
                                    _project!
                                        .statistics
                                        .performance
                                        .resourceUsage,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),

                          // 交互统计
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.visibility,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${_project!.metadata.viewCount}次浏览'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.comment,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${_project!.metadata.commentCount}条评论'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.share,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${_project!.metadata.shareCount}次分享'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(),

                  // 内容部分
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      '项目内容',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // 缓存样式对象
                  ..._project!.content.sections.map((section) {
                    final sectionTitleStyle = const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    );
                    final sectionTextStyle = TextStyle(
                      color: Colors.grey[700],
                      height: 1.5,
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(section.title, style: sectionTitleStyle),
                            const SizedBox(height: 12),
                            if (section.type == 'text')
                              Text(section.content, style: sectionTextStyle),
                            if (section.type == 'image' &&
                                section.content is List)
                              // 使用Wrap替代嵌套的GridView以提高性能
                              _buildImageGrid(section.content as List),
                          ],
                        ),
                      ),
                    );
                  }),

                  // 附件
                  if (_project!.content.attachments.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            '附件',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ..._project!.content.attachments.map((attachment) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            elevation: 1,
                            child: ListTile(
                              leading: const Icon(Icons.attach_file, size: 32),
                              title: Text(attachment.name),
                              subtitle: Text(
                                '${attachment.type.toUpperCase()} • ${attachment.size}',
                              ),
                              trailing: TextButton(
                                onPressed: () {
                                  // 处理下载逻辑
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('正在下载 ${attachment.name}'),
                                    ),
                                  );
                                },
                                child: const Text('下载'),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),

                  // 相关项目
                  if (_project!.relatedItems.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            '相关项目',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ..._project!.relatedItems.map((relatedItem) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            elevation: 1,
                            child: ListTile(
                              leading: const Icon(
                                Icons.link,
                                color: Colors.blue,
                              ),
                              title: Text(relatedItem.title),
                              subtitle: Text(
                                '关系类型: ${_getRelationTypeName(relatedItem.relationType)}',
                              ),
                              onTap: () {
                                // 导航到相关项目详情
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProjectDetailPage(
                                      projectId: relatedItem.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),

                  // 底部间距
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  String _getRelationTypeName(String relationType) {
    switch (relationType) {
      case 'similar':
        return '相似';
      case 'dependency':
        return '依赖';
      case 'recommended':
        return '推荐';
      default:
        return relationType;
    }
  }

  // 优化的图片网格构建方法 - 使用Wrap替代嵌套的GridView
  Widget _buildImageGrid(List images) {
    // 预计算网格项宽度
    final screenWidth = MediaQuery.of(context).size.width - 64; // 考虑padding和间距
    final itemWidth = (screenWidth - 10) / 2; // 2列布局，考虑间距

    // 缓存常用样式
    final containerDecoration = BoxDecoration(
      color: Colors.grey[200] ?? Colors.grey,
      borderRadius: BorderRadius.circular(8),
    );
    final iconWidget = const Icon(Icons.image, size: 40, color: Colors.grey);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: images.map((image) {
        return SizedBox(
          width: itemWidth,
          height: itemWidth * 1.5, // 保持1.5的宽高比
          child: Container(
            decoration: containerDecoration,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [iconWidget, Text(image['alt'])],
            ),
          ),
        );
      }).toList(),
    );
  }
}
