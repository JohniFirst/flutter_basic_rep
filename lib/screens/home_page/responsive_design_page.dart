import 'package:flutter/material.dart';
import '../../app_localizations.dart';

class ResponsiveDesignPage extends StatelessWidget {
  const ResponsiveDesignPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 根据屏幕宽度判断设备类型
    String deviceType;
    if (screenWidth < 600) {
      deviceType = AppLocalizations.of(context).smallScreen;
    } else if (screenWidth < 1200) {
      deviceType = AppLocalizations.of(context).mediumScreen;
    } else {
      deviceType = AppLocalizations.of(context).largeScreen;
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 根据屏幕宽度决定布局
          if (constraints.maxWidth < 600) {
            // 小屏幕布局 - 单列
            return _buildSmallScreenLayout(
              context,
              screenWidth,
              screenHeight,
              deviceType,
            );
          } else if (constraints.maxWidth < 1200) {
            // 中等屏幕布局 - 两列
            return _buildMediumScreenLayout(
              context,
              screenWidth,
              screenHeight,
              deviceType,
            );
          } else {
            // 大屏幕布局 - 三列
            return _buildLargeScreenLayout(
              context,
              screenWidth,
              screenHeight,
              deviceType,
            );
          }
        },
      ),
    );
  }

  Widget _buildSmallScreenLayout(
    BuildContext context,
    double width,
    double height,
    String deviceType,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context, width, height, deviceType),
          const SizedBox(height: 16),
          _buildContentCard(
            context,
            'Card 1',
            Colors.blue,
            Icons.phone_android,
          ),
          const SizedBox(height: 16),
          _buildContentCard(context, 'Card 2', Colors.green, Icons.tablet),
          const SizedBox(height: 16),
          _buildContentCard(context, 'Card 3', Colors.orange, Icons.computer),
        ],
      ),
    );
  }

  Widget _buildMediumScreenLayout(
    BuildContext context,
    double width,
    double height,
    String deviceType,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context, width, height, deviceType),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildContentCard(
                  context,
                  'Card 1',
                  Colors.blue,
                  Icons.phone_android,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildContentCard(
                  context,
                  'Card 2',
                  Colors.green,
                  Icons.tablet,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildContentCard(context, 'Card 3', Colors.orange, Icons.computer),
        ],
      ),
    );
  }

  Widget _buildLargeScreenLayout(
    BuildContext context,
    double width,
    double height,
    String deviceType,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context, width, height, deviceType),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildContentCard(
                  context,
                  'Card 1',
                  Colors.blue,
                  Icons.phone_android,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildContentCard(
                  context,
                  'Card 2',
                  Colors.green,
                  Icons.tablet,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildContentCard(
                  context,
                  'Card 3',
                  Colors.orange,
                  Icons.computer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    double width,
    double height,
    String deviceType,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).responsiveDesignDescription,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(
                    context,
                  ).screenSize(width.toInt(), height.toInt()),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.devices,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).deviceType(deviceType),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(
    BuildContext context,
    String title,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'This is a sample content card that demonstrates responsive design principles. The layout adapts based on screen size.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('$title tapped!')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tap Me'),
            ),
          ],
        ),
      ),
    );
  }
}
