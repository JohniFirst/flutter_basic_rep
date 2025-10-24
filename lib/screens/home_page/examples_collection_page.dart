import 'package:flutter/material.dart';
import 'responsive_design_page.dart';
import 'shared_element_animation_page.dart';
import 'form_page.dart';
import 'list_loading_page.dart';
import '../../app_localizations.dart';

class ExamplesCollectionPage extends StatefulWidget {
  const ExamplesCollectionPage({super.key});

  @override
  State<ExamplesCollectionPage> createState() => _ExamplesCollectionPageState();
}

class _ExamplesCollectionPageState extends State<ExamplesCollectionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).examplesCollection),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelStyle: TextStyle(fontSize: 12.0),
          // dividerHeight: 0,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: '列表加载'),
            Tab(icon: Icon(Icons.assignment), text: '表单示例'),
            Tab(icon: Icon(Icons.pageview), text: '响应式设计'),
            Tab(icon: Icon(Icons.animation), text: '共享元素动画'),
            Tab(icon: Icon(Icons.animation), text: '共享元素动画'),
            Tab(icon: Icon(Icons.animation), text: '共享元素动画'),
            Tab(icon: Icon(Icons.animation), text: '共享元素动画'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ListLoadingPage(),
          FormPage(),
          ResponsiveDesignPage(),
          SharedElementAnimationPage(),
          ResponsiveDesignPage(),
          SharedElementAnimationPage(),
          ResponsiveDesignPage(),
        ],
      ),
    );
  }
}
