import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'detail_page.dart';

class ListLoadingPage extends StatefulWidget {
  const ListLoadingPage({super.key});

  @override
  State<ListLoadingPage> createState() => _ListLoadingPageState();
}

class _ListLoadingPageState extends State<ListLoadingPage> {
  final List<String> _items = [];
  // Measured item extent (height) for ListView.itemExtent optimization.
  double? _measuredItemExtent;
  // Key to measure the first item once it's built.
  final GlobalKey _firstItemKey = GlobalKey();
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _pageSize = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Defer loading until after first frame to avoid delaying initial render
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
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
    // 将列表项生成放到后台 isolate（compute）中，避免在主线程分配大量对象
    final startIndex = page * _pageSize;
    final List<String> newItems = await compute(_generateItems, {
      'start': startIndex,
      'pageSize': _pageSize,
    });

    // 更新状态在主线程中一次性完成
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

    // Try to measure the first item's height after it has been inserted
    // into the tree. This allows us to set itemExtent for better
    // ListView performance when items are uniform height.
    _maybeMeasureItem();
  }

  void _maybeMeasureItem() {
    if (_measuredItemExtent != null) return;
    if (_items.isEmpty) return;

    // Schedule a post-frame callback so the item has been laid out.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _firstItemKey.currentContext;
      if (ctx == null) return;
      final size = ctx.size;
      if (size == null) return;
      final h = size.height;
      if (h > 0 && mounted) {
        setState(() {
          _measuredItemExtent = h;
        });
      }
    });
  }

  Future<void> _onRefresh() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading && _items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                controller: _scrollController,
                // If we've measured an item height, provide it to avoid
                // per-item layout work. Otherwise fall back to variable
                // sizing until measurement completes.
                itemExtent: _measuredItemExtent,
                itemCount: _items.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _items.length) {
                    // Use a GlobalKey for the first item so we can measure
                    // its height once it's rendered.
                    final key = index == 0
                        ? _firstItemKey
                        : ValueKey(_items[index]);
                    return ListItemWidget(key: key, itemName: _items[index]);
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

// Top-level function for compute (must be a top-level or static function)
List<String> _generateItems(Map<String, int> params) {
  final start = params['start'] ?? 0;
  final pageSize = params['pageSize'] ?? 20;
  return List.generate(pageSize, (index) => '列表项 ${start + index + 1}');
}

/// A lightweight, const-friendly widget representing a single list item.
class ListItemWidget extends StatelessWidget {
  final String itemName;

  const ListItemWidget({super.key, required this.itemName});

  @override
  Widget build(BuildContext context) {
    // Use a simple decorated Container instead of a Material Card with
    // elevation to avoid raster-costly shadows. Keep a border and
    // rounded corners for a similar visual appearance.
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(itemName, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('子项1', style: TextStyle(fontSize: 14)),
                      SizedBox(height: 8),
                      Text('子项描述', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('子项1', style: TextStyle(fontSize: 14)),
                      SizedBox(height: 8),
                      Text('子项描述', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('子项1', style: TextStyle(fontSize: 14)),
                      SizedBox(height: 8),
                      Text('子项描述', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(itemName: itemName),
                        ),
                      );
                    },
                    child: const Text('按钮1'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.blueAccent,
                      ),
                    ),
                    child: const Text('按钮2'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red),
                    ),
                    child: const Text('按钮3'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
