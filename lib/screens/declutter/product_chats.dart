import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/chat_controller.dart';
import '../../model/chat_model.dart';
import '../../model/user_model.dart';
import '../../routes/routes.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class ProductChats extends StatefulWidget {
  const ProductChats({super.key});

  @override
  State<ProductChats> createState() => _ProductChatsState();
}

class _ProductChatsState extends State<ProductChats> {
  final ChatController chatController = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.getChatLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Messages",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.font20,
            ),
          ),
          bottom: TabBar(
            labelColor: AppColors.color1,
            unselectedLabelColor: AppColors.grey4,
            indicatorColor: AppColors.color1,
            tabs: const [Tab(text: "Buying"), Tab(text: "Selling")],
          ),
        ),
        body: GetBuilder<ChatController>(
          builder: (ctrl) {
            return TabBarView(
              children: [
                // --- TAB 1: BUYING (Customer Chats) ---
                _buildChatList(ctrl.customerChats, isBuying: true),

                // --- TAB 2: SELLING (Vendor Chats) ---
                _buildChatList(ctrl.vendorChats, isBuying: false),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChatList(List<ChatModel> allChats, {required bool isBuying}) {
    // 1. 🔍 FILTER: Only show 'product-chat'
    List<ChatModel> chats =
        allChats.where((chat) => chat.type == 'product-chat').toList();

    if (chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              isBuying
                  ? "No active product chats with sellers"
                  : "No active product chats with buyers",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(Dimensions.width20),
      itemCount: chats.length,
      separatorBuilder: (_, __) => Divider(color: AppColors.grey2),
      itemBuilder: (context, index) {
        ChatModel chat = chats[index];

        // Determine who we are talking TO
        UserModel? otherUser = isBuying ? chat.vendor : chat.customer;

        // Product Name (Safe check)
        String productName = chat.product?.name ?? "Product Item";

        // Unread Count logic
        int unreadCount =
            isBuying
                ? (chat.customerUnreadCount ?? 0)
                : (chat.vendorUnreadCount ?? 0);

        return InkWell(
          onTap: () {
            // 2. Use the controller's enter method to ensure proper loading
            chatController.enterChatRoom(chatArg: chat);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.grey3,
                  backgroundImage:
                      (otherUser?.profilePicture != null)
                          ? NetworkImage(otherUser!.profilePicture!)
                          : null,
                  child:
                      (otherUser?.profilePicture == null)
                          ? Icon(Icons.person, color: AppColors.grey5)
                          : null,
                ),
                SizedBox(width: 15),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              otherUser?.name ?? "Unknown User",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.font16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chat.lastMessageData?.createdAt != null)
                            Text(
                              _formatTime(chat.lastMessageData!.createdAt!),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.grey4,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 5),

                      // Product Tag
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grey2,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          productName,
                          style: TextStyle(fontSize: 10, color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 5),

                      // Message Preview
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.lastMessageData?.text ?? "Start chatting...",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                    unreadCount > 0
                                        ? Colors.black
                                        : AppColors.grey4,
                                fontWeight:
                                    unreadCount > 0
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (unreadCount > 0)
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.color1,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                unreadCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(String timestamp) {
    // Simple helper to format time
    DateTime date = DateTime.parse(timestamp).toLocal();
    DateTime now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return DateFormat.jm().format(date); // 10:30 AM
    } else if (now.difference(date).inDays < 7) {
      return DateFormat.E().format(date); // Mon
    } else {
      return DateFormat.MMMd().format(date); // Jan 15
    }
  }
}
