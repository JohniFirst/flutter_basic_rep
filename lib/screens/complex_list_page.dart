import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'project_detail_page.dart';

class ComplexListPage extends StatefulWidget {
  const ComplexListPage({super.key});

  @override
  State<ComplexListPage> createState() => _ComplexListPageState();
}

class ProjectItem {
  final int id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final String priority;
  final Author author;
  final Metadata metadata;
  final Content content;
  final Statistics statistics;
  final List<RelatedItem> relatedItems;

  ProjectItem({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.priority,
    required this.author,
    required this.metadata,
    required this.content,
    required this.statistics,
    required this.relatedItems,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      status: json['status'],
      priority: json['priority'],
      author: Author.fromJson(json['author']),
      metadata: Metadata.fromJson(json['metadata']),
      content: Content.fromJson(json['content']),
      statistics: Statistics.fromJson(json['statistics']),
      relatedItems: List<RelatedItem>.from(
        json['relatedItems'].map((item) => RelatedItem.fromJson(item)),
      ),
    );
  }
}

class Author {
  final int id;
  final String name;
  final String avatar;
  final String role;
  final Contact contact;

  Author({
    required this.id,
    required this.name,
    required this.avatar,
    required this.role,
    required this.contact,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      role: json['role'],
      contact: Contact.fromJson(json['contact']),
    );
  }
}

class Contact {
  final String email;
  final String phone;

  Contact({required this.email, required this.phone});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      email: json['email'],
      phone: json['phone'],
    );
  }
}

class Metadata {
  final List<String> tags;
  final int viewCount;
  final int commentCount;
  final int shareCount;

  Metadata({
    required this.tags,
    required this.viewCount,
    required this.commentCount,
    required this.shareCount,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      tags: List<String>.from(json['tags']),
      viewCount: json['viewCount'],
      commentCount: json['commentCount'],
      shareCount: json['shareCount'],
    );
  }
}

class Content {
  final List<Section> sections;
  final List<Attachment> attachments;

  Content({required this.sections, required this.attachments});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      sections: List<Section>.from(
        json['sections'].map((section) => Section.fromJson(section)),
      ),
      attachments: List<Attachment>.from(
        json['attachments'].map((attachment) => Attachment.fromJson(attachment)),
      ),
    );
  }
}

class Section {
  final String id;
  final String type;
  final String title;
  final dynamic content;

  Section({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      content: json['content'],
    );
  }
}

class Attachment {
  final String id;
  final String name;
  final String type;
  final String size;
  final String url;

  Attachment({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.url,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      size: json['size'],
      url: json['url'],
    );
  }
}

class Statistics {
  final int progress;
  final String completionRate;
  final Performance performance;

  Statistics({
    required this.progress,
    required this.completionRate,
    required this.performance,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      progress: json['progress'],
      completionRate: json['completionRate'],
      performance: Performance.fromJson(json['performance']),
    );
  }
}

class Performance {
  final String speed;
  final String efficiency;
  final String resourceUsage;

  Performance({
    required this.speed,
    required this.efficiency,
    required this.resourceUsage,
  });

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      speed: json['speed'],
      efficiency: json['efficiency'],
      resourceUsage: json['resourceUsage'],
    );
  }
}

class RelatedItem {
  final int id;
  final String title;
  final String relationType;

  RelatedItem({
    required this.id,
    required this.title,
    required this.relationType,
  });

  factory RelatedItem.fromJson(Map<String, dynamic> json) {
    return RelatedItem(
      id: json['id'],
      title: json['title'],
      relationType: json['relationType'],
    );
  }
}

class _ComplexListPageState extends State<ComplexListPage> {
  List<ProjectItem> _projectItems = [];
  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 调用真实API - 适配Android设备
      // 对于Android模拟器，使用10.0.2.2访问主机上的localhost
      // 对于真机测试，需要使用计算机的实际IP地址
      final apiUrl = 'http://192.168.122.184:3001/complex-list'; // 模拟器地址
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> projectsList = data['data'];
        
        setState(() {
          _projectItems = projectsList
              .map((item) => ProjectItem.fromJson(item))
              .toList();
          _isLoading = false;
          _isRefreshing = false;
        });
      } else {
        throw Exception('服务器错误: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载数据失败: $error')),
      );
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    await _fetchData();
  }

  // 模拟数据生成方法已移除，现在使用真实API数据

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
        title: const Text('复杂列表'),
        titleTextStyle: const TextStyle(fontSize: 18), // 减小字体大小
        toolbarHeight: 50, // 减小高度
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading && !_isRefreshing
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: _projectItems.length,
                itemBuilder: (context, index) {
                  final item = _projectItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 项目标题和状态
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(item.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.status,
                                  style: TextStyle(
                                    color: _getStatusColor(item.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          // 描述
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              item.description,
                              style: TextStyle(color: Colors.grey[600]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          
                          // 作者信息
                          Row(
                            children: [
                              CircleAvatar(
                                child: Text(item.author.name.substring(0, 1)),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.author.name),
                                  Text(
                                    item.author.role,
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                DateFormat('yyyy-MM-dd').format(item.createdAt),
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(),
                          ),
                          
                          // 元数据和标签
                          Row(
                            children: [
                              Expanded(
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: item.metadata.tags.map((tag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        tag,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(item.priority).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.priority,
                                  style: TextStyle(
                                    color: _getPriorityColor(item.priority),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          // 统计信息
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.visibility, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${item.metadata.viewCount}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.comment, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${item.metadata.commentCount}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.share, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${item.metadata.shareCount}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.pie_chart, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${item.statistics.progress}%',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // 查看详情按钮
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // 导航到详情页
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProjectDetailPage(
                                      projectId: item.id,
                                      projectItem: item, // 传递完整项目数据以提高性能
                                    ),
                                  ),
                                );
                              },
                              child: const Text('查看详情'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}