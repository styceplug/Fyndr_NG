import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/app_constants.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:get/get.dart';

import '../../controllers/notification_controller.dart';
import '../../model/notification_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/notification_tile.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final c = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.fetchInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppbar(
          leadingIcon: BackButton(
            onPressed: () async {
              await c.refreshUnreadCount();
              Get.back();
            },
          ),
          title: 'Notifications',
          actionIcon: IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () => c.markAllAsRead(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          child: Column(
            children: [
              TabBar(
                indicatorColor: AppColors.color1,
                labelColor: Colors.black,
                unselectedLabelColor: AppColors.grey4,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 4,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'JOBS'),
                  Tab(text: 'MESSAGES'),
                ],
              ),
              SizedBox(height: Dimensions.height20),
              Expanded(
                child: Obx(() {
                  return TabBarView(
                    children: [
                      _NotificationList(items: c.allTab, controller: c),
                      _NotificationList(items: c.jobsTab, controller: c),
                      _NotificationList(items: c.messagesTab, controller: c),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationList extends StatefulWidget {
  final List<AppNotification> items;
  final NotificationController controller;

  const _NotificationList({required this.items, required this.controller});

  @override
  State<_NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<_NotificationList> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 250) {
        widget.controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Center(child: Text("No notifications yet"));
    }

    return ListView.separated(
      controller: _scroll,
      itemCount: widget.items.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        if (i == widget.items.length) {
          return Obx(
            () =>
                widget.controller.isLoadingMore.value
                    ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                    : const SizedBox.shrink(),
          );
        }

        final n = widget.items[i];
        return NotificationTile(
          n: n,
          onTap: () => widget.controller.handleTap(n),
        );
      },
    );
  }
}
