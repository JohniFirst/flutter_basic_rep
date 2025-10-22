import 'package:flutter/material.dart';

class ListLoadingPage extends StatefulWidget {
  const ListLoadingPage({super.key});

  @override
  State<ListLoadingPage> createState() => _ListLoadingPageState();
}

class _ListLoadingPageState extends State<ListLoadingPage> {
  final List<String> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _pageSize = 20;
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

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

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchData(0);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchData(int page) async {
    // 模拟网络请求延迟
    await Future.delayed(const Duration(seconds: 1));

    // 模拟数据生成
    final startIndex = page * _pageSize;
    final List<String> newItems = List.generate(
      _pageSize,
      (index) => '列表项 ${startIndex + index + 1}',
    );

    setState(() {
      if (page == 0) {
        _items.clear();
        _currentPage = 0;
      }
      _items.addAll(newItems);
      _currentPage = page;

      // 模拟只有100条数据
      if (_items.length >= 100) {
        _hasMore = false;
      }
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    await _fetchData(0);
    setState(() {
      _isRefreshing = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('列表加载示例'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading && _items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _items.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _items.length) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _items[index],
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Divider(height: 1, thickness: 2),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text('子项1', style: TextStyle(fontSize: 14)),
                                    const SizedBox(height: 12),
                                    Text(
                                      '子项描述',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('子项1', style: TextStyle(fontSize: 14)),
                                    const SizedBox(height: 12),
                                    Text(
                                      '子项描述',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('子项1', style: TextStyle(fontSize: 14)),
                                    const SizedBox(height: 12),
                                    Text(
                                      '子项描述',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},

                                  child: Text('按钮1'),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.blueAccent,
                                    ),
                                  ),
                                  child: Text('按钮2'),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.red,
                                    ),
                                  ),
                                  child: Text('按钮3'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return _buildLoadingItem();
                  }
                },
              ),
            ),
    );
  }

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
}
