import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'project_detail_page.dart';
import '../../services/http_service.dart';

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
    return Contact(email: json['email'], phone: json['phone']);
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
        json['attachments'].map(
          (attachment) => Attachment.fromJson(attachment),
        ),
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
  final List<ProjectItem> _projectItems = [];
  bool _isLoading = true;

  bool _hasMore = true;
  int _currentPage = 0;
  final int _pageSize = 20;
  final ScrollController _scrollController = ScrollController();
  // 使用统一的HttpService
  final HttpService _httpService = HttpService();
  // 缓存格式化器以避免重复创建
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 创建默认模拟数据的方法
  List<ProjectItem> _getDefaultProjects() {
    return [
      ProjectItem(
        id: 1,
        title: '智能办公系统开发',
        description: '基于Flutter的跨平台智能办公系统，包含日程管理、文档协作等功能',
        createdAt: DateTime(2023, 9, 15),
        updatedAt: DateTime(2023, 10, 5),
        status: 'active',
        priority: 'high',
        author: Author(
          id: 1,
          name: '张明',
          avatar: '',
          role: '产品经理',
          contact: Contact(email: 'zhangming@example.com', phone: '13800138001'),
        ),
        metadata: Metadata(
          tags: ['Flutter', '办公系统', '产品开发'],
          viewCount: 156,
          commentCount: 23,
          shareCount: 8,
        ),
        content: Content(
          sections: [
            Section(id: 's1', type: 'text', title: '项目概述', content: '项目基本信息'),
          ],
          attachments: [
            Attachment(id: 'a1', name: '需求文档.pdf', type: 'pdf', size: '2.5MB', url: ''),
          ],
        ),
        statistics: Statistics(
          progress: 65,
          completionRate: '65%',
          performance: Performance(speed: '良好', efficiency: '高', resourceUsage: '中等'),
        ),
        relatedItems: [
          RelatedItem(id: 2, title: 'UI设计稿', relationType: '相关文档'),
        ],
      ),
      ProjectItem(
        id: 2,
        title: '电商移动端优化',
        description: '优化现有电商APP的性能和用户体验，提升转化率',
        createdAt: DateTime(2023, 8, 20),
        updatedAt: DateTime(2023, 10, 1),
        status: 'pending',
        priority: 'medium',
        author: Author(
          id: 2,
          name: '李华',
          avatar: '',
          role: '技术负责人',
          contact: Contact(email: 'lihua@example.com', phone: '13900139002'),
        ),
        metadata: Metadata(
          tags: ['电商', '性能优化', '用户体验'],
          viewCount: 203,
          commentCount: 45,
          shareCount: 12,
        ),
        content: Content(
          sections: [
            Section(id: 's2', type: 'text', title: '优化方案', content: '性能优化详细计划'),
          ],
          attachments: [
            Attachment(id: 'a2', name: '性能分析报告.xlsx', type: 'excel', size: '1.8MB', url: ''),
          ],
        ),
        statistics: Statistics(
          progress: 40,
          completionRate: '40%',
          performance: Performance(speed: '待提升', efficiency: '中等', resourceUsage: '较高'),
        ),
        relatedItems: [
          RelatedItem(id: 3, title: '竞品分析', relationType: '参考资料'),
        ],
      ),
      ProjectItem(
        id: 3,
        title: '企业数据分析平台',
        description: '基于大数据技术的企业数据分析和可视化平台',
        createdAt: DateTime(2023, 7, 10),
        updatedAt: DateTime(2023, 9, 28),
        status: 'completed',
        priority: 'high',
        author: Author(
          id: 3,
          name: '王静',
          avatar: '',
          role: '数据分析师',
          contact: Contact(email: 'wangjing@example.com', phone: '13700137003'),
        ),
        metadata: Metadata(
          tags: ['数据分析', '可视化', '大数据'],
          viewCount: 289,
          commentCount: 67,
          shareCount: 15,
        ),
        content: Content(
          sections: [
            Section(id: 's3', type: 'chart', title: '数据指标', content: '关键业务指标'),
          ],
          attachments: [
            Attachment(id: 'a3', name: '数据模型设计.pptx', type: 'ppt', size: '3.2MB', url: ''),
          ],
        ),
        statistics: Statistics(
          progress: 100,
          completionRate: '100%',
          performance: Performance(speed: '优秀', efficiency: '优秀', resourceUsage: '低'),
        ),
        relatedItems: [
          RelatedItem(id: 4, title: '用户反馈汇总', relationType: '项目总结'),
        ],
      ),
    ];
  }

  Future<void> _loadInitialData() async {
    // 首先加载默认数据，让用户立即看到内容
    setState(() {
      _projectItems.addAll(_getDefaultProjects());
      _isLoading = true; // 保持加载状态，API完成后会更新
    });
    
    try {
      // 同时请求API数据
      await _fetchData(0);
      // API请求成功后，会在_fetchData中更新数据
    } catch (e) {
      // API请求失败时，保留默认数据
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchData(int page) async {
    try {
      // 使用统一的HttpService发送请求
      final response = await _httpService.get(
        '/complex-list',
        queryParameters: {
          'page': page.toString(),
          'pageSize': _pageSize.toString(),
        },
      );

      if (response['success']) {
        final data = response['data'];

        // 确保数据是列表类型
        final List<dynamic> projectsList = data is List
            ? data
            : (data is Map && data.containsKey('data') ? data['data'] : []);

        setState(() {
          if (page == 0) {
            _projectItems.clear(); // 清除默认数据，替换为真实数据
            _currentPage = 0;
          }

          if (projectsList.isNotEmpty) {
            _projectItems.addAll(
              projectsList.map((item) => ProjectItem.fromJson(item)).toList(),
            );
          }

          _currentPage = page;

          // 检查是否还有更多数据
          if (projectsList.length < _pageSize) {
            _hasMore = false;
          }

          _isLoading = false;
        });
      } else {
        final errorMessage = response['message'] ?? '请求失败';
        throw Exception(errorMessage);
      }
    } catch (error) {
      // API请求失败时，保留已显示的默认数据
      setState(() {
        _isLoading = false;
        _hasMore = false; // 默认数据不需要分页
      });
      
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载数据失败，显示默认数据: $error')));
      }
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _hasMore = true;
    });
    await _fetchData(0);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMore) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchData(_currentPage + 1);
    setState(() {
      _isLoading = false;
    });
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

  // 创建可重用的常量样式
  static const _titleStyle = TextStyle(
    fontSize: 16, // 略微减小字体
    fontWeight: FontWeight.bold,
  );

  static const _smallTextStyle = TextStyle(fontSize: 12, color: Colors.grey);

  static const _tagTextStyle = TextStyle(fontSize: 12);

  // 优化列表项构建
  Widget _buildProjectItem(ProjectItem item) {
    // 预先计算常用值
    final statusColor = _getStatusColor(item.status);
    final priorityColor = _getPriorityColor(item.priority);
    final formattedDate = _dateFormat.format(item.createdAt);
    final authorInitial = item.author.name.isNotEmpty
        ? item.author.name.substring(0, 1)
        : '?';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2, // 减少阴影深度
      child: Padding(
        padding: const EdgeInsets.all(12), // 略微减小内边距
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
                    style: _titleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            // 描述 - 仅在有足够空间时显示
            if (item.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  item.description,
                  style: _smallTextStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // 作者信息和日期
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  radius: 16,
                  child: Text(authorInitial), // 减小头像大小
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.author.name,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(item.author.role, style: _smallTextStyle),
                  ],
                ),
                const Spacer(),
                Text(formattedDate, style: _smallTextStyle),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(),
            ),

            // 元数据和标签 - 简化显示
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children:
                        (item.metadata.tags.take(3).map((tag) {
                          // 限制显示的标签数量
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(tag, style: _tagTextStyle),
                          );
                        }).toList()..addAll(
                          item.metadata.tags.length > 3
                              ? [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '+${item.metadata.tags.length - 3}',
                                      style: _tagTextStyle,
                                    ),
                                  ),
                                ]
                              : [],
                        )),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.priority,
                    style: TextStyle(
                      color: priorityColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            // 简化统计信息
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem(
                    Icons.visibility,
                    '${item.metadata.viewCount}',
                  ),
                  _buildStatItem(
                    Icons.pie_chart,
                    '${item.statistics.progress}%',
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
  }

  // 可重用的统计项组件
  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: _smallTextStyle),
      ],
    );
  }

  // 加载更多项
  Widget _buildLoadingItem() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: _isLoading
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('加载更多...'),
                ],
              )
            : const Text('没有更多数据了'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('复杂列表'),
        titleTextStyle: const TextStyle(fontSize: 18),
        toolbarHeight: 50,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _projectItems.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _projectItems.length) {
                    return _buildProjectItem(_projectItems[index]);
                  } else {
                    return _buildLoadingItem();
                  }
                },
              ),
            ),
    );
  }
}
