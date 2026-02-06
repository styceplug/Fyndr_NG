import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fyndr_ng/utils/dimensions.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';
import '../../controllers/chat_controller.dart';
import '../../model/chat_model.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_textfield.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  final ChatController controller = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (ctrl) {
        final otherUser =
            (ctrl.currentUserId == ctrl.currentChat?.vendor)
                ? ctrl.currentChat?.customerDetails
                : ctrl.currentChat?.vendorDetails;

        String lastSeenText = "Offline";
        if (ctrl.otherUserLastSeen != null) {
          try {
            // Parse the ISO string to DateTime
            DateTime date = DateTime.parse(ctrl.otherUserLastSeen!);
            // Now pass the DateTime object to GetTimeAgo
            lastSeenText = "Last seen ${GetTimeAgo.parse(date)}";
          } catch (e) {
            lastSeenText = "Offline";
          }
        }

        String? avatarUrl = otherUser?.avatar;
        if (avatarUrl != null &&
            avatarUrl.isNotEmpty &&
            !avatarUrl.startsWith('http')) {
          avatarUrl = '${AppConstants.BASE_URL}$avatarUrl';
        }

        return Scaffold(
          appBar: CustomAppbar(
            leadingIcon: const BackButton(),
            customTitle: Row(
              children: [
                // User Avatar
                Container(
                  height: Dimensions.height40,
                  width: Dimensions.width40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    image:
                        avatarUrl != null
                            ? DecorationImage(
                              image: NetworkImage(avatarUrl),
                              fit: BoxFit.cover,
                            )
                            : DecorationImage(
                              image: AssetImage(
                                AppConstants.getPngAsset('head-icon'),
                              ),
                            ),
                  ),
                ),
                SizedBox(width: Dimensions.width15),

                // User Name and Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        otherUser?.businessDetails?.businessName ??
                            otherUser?.name ??
                            'Chat',
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (ctrl.isRemoteUserTyping)
                        Text(
                          'Typing...',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.color2,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      else if (ctrl.isOtherUserOnline)
                        Row(
                          children: [
                            Icon(Icons.circle, size: 8, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              'Online',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          ctrl.otherUserLastSeen != null
                              ? 'Last seen ${lastSeenText}'
                              : 'Offline',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          body: Column(
            children: [

              if (ctrl.currentChat?.type == 'product-chat' && ctrl.currentChat?.productDetails != null)
                _buildProductInfo(ctrl.currentChat!.productDetails!),

              //warning
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10,
                  vertical: Dimensions.height10
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.color1),
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: AppColors.color5
                ),
                child: Text(
                  'Avoid Paying in advance, and remember this chat room is being monitored for moderation.',
                  style: TextStyle(
                    fontSize: Dimensions.font12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),



              // ==================== MESSAGE LIST ====================
              Expanded(
                child:
                    ctrl.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                          onRefresh: ctrl.refreshChat,
                          child: ListView.builder(
                            controller: ctrl.scrollCtrl,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            itemCount: ctrl.messages.length,
                            itemBuilder: (context, index) {
                              final msg = ctrl.messages[index];
                              final isMe = msg.sender == ctrl.currentUserId;

                              // --- DATE GROUPING LOGIC ---
                              bool showDateHeader = false;
                              if (index == 0) {
                                showDateHeader = true;
                              } else {
                                final prevMsg = ctrl.messages[index - 1];
                                if (!_isSameDay(
                                  msg.createdAt,
                                  prevMsg.createdAt,
                                )) {
                                  showDateHeader = true;
                                }
                              }

                              return Column(
                                children: [
                                  if (showDateHeader)
                                    _buildDateHeader(msg.createdAt),
                                  msg.isAudio
                                      ? _buildAudioBubble(msg, isMe)
                                      : _buildMessageBubble(msg, isMe),
                                ],
                              );
                            },
                          ),
                        ),
              ),

              // ==================== INPUT AREA ====================
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: EdgeInsets.only(bottom: Dimensions.height30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.grey3)),
                ),
                child: Row(
                  children: [
                    // Text Input Field
                    Expanded(
                      child: CustomTextField(
                        controller: ctrl.messageCtrl,
                        onChanged: (val) => ctrl.handleTyping(val),
                        hintText:
                            ctrl.isRecording
                                ? 'Recording audio...'
                                : 'Type a message...',
                        enabled: !ctrl.isRecording,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Send/Record Button
                    GestureDetector(
                      onTap:
                          ctrl.isMessageEmpty
                              ? ctrl.toggleRecording
                              : ctrl.sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              ctrl.isRecording ? Colors.red : AppColors.color2,
                          shape: BoxShape.circle,
                        ),
                        child:
                            ctrl.isSending
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Icon(
                                  ctrl.isRecording
                                      ? Icons.stop
                                      : (ctrl.isMessageEmpty
                                          ? Iconsax.microphone
                                          : Iconsax.send_1),
                                  color: Colors.white,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildProductInfo(Map<String, dynamic> product) {
    // 1. Extract Data safely
    String name = product['name'] ?? 'Product';

    // Price formatting
    var rawPrice = product['price'];
    String price = "N0.00";
    if (rawPrice != null) {
      final formatter = NumberFormat.currency(locale: 'en_NG', symbol: 'N');
      price = formatter.format(num.tryParse(rawPrice.toString()) ?? 0);
    }

    // Image Handling
    String? imageUrl;
    if (product['images'] != null && (product['images'] as List).isNotEmpty) {
      String rawImg = (product['images'] as List)[0];
      imageUrl = rawImg.startsWith('http') ? rawImg : '${AppConstants.BASE_URL}$rawImg';
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width20, vertical: Dimensions.height10),
      padding: EdgeInsets.all(Dimensions.width10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius10),
        border: Border.all(color: AppColors.grey3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.grey2,
              image: imageUrl != null
                  ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
                  : null,
            ),
            child: imageUrl == null ? Icon(Iconsax.box, color: AppColors.grey4) : null,
          ),
          SizedBox(width: Dimensions.width10),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: Dimensions.font14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  price,
                  style: TextStyle(
                      fontSize: Dimensions.font12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.color1
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildDateHeader(String? dateString) {
    if (dateString == null) return const SizedBox.shrink();
    DateTime date = DateTime.parse(dateString);
    String headerText;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final msgDate = DateTime(date.year, date.month, date.day);

    if (msgDate == today) {
      headerText = "Today";
    } else if (msgDate == yesterday) {
      headerText = "Yesterday";
    } else {
      headerText = DateFormat('MMMM dd, yyyy').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          headerText,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ==================== TEXT MESSAGE BUBBLE ====================

  Widget _buildMessageBubble(MessageModel msg, bool isMe) {
    String time =
        msg.createdAt != null
            ? DateFormat(
              'hh:mm a',
            ).format(DateTime.parse(msg.createdAt!).toLocal())
            : "";

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: Dimensions.screenWidth * 0.7),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.color2 : AppColors.grey2,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: isMe ? const Radius.circular(15) : Radius.zero,
                bottomRight: isMe ? Radius.zero : const Radius.circular(15),
              ),
            ),
            child: Text(
              msg.text ?? "",
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 15),
            child: Text(
              time,
              style: TextStyle(fontSize: 10, color: AppColors.grey4),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== AUDIO MESSAGE BUBBLE ====================

  Widget _buildAudioBubble(MessageModel msg, bool isMe) {
    String time =
        msg.createdAt != null
            ? DateFormat(
              'hh:mm a',
            ).format(DateTime.parse(msg.createdAt!).toLocal())
            : "";

    String audioUrl = msg.audio?.url ?? '';
    if (audioUrl.isNotEmpty && !audioUrl.startsWith('http')) {
      audioUrl = '${AppConstants.BASE_URL}$audioUrl';
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: Dimensions.screenWidth * 0.7),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.color2 : AppColors.grey2,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: isMe ? const Radius.circular(15) : Radius.zero,
                bottomRight: isMe ? Radius.zero : const Radius.circular(15),
              ),
            ),
            child: AudioPlayerWidget(
              audioUrl: audioUrl,
              duration: msg.audio?.formattedDuration ?? '0:00',
              isMe: isMe,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 15),
            child: Text(
              time,
              style: TextStyle(fontSize: 10, color: AppColors.grey4),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(String? date1, String? date2) {
    if (date1 == null || date2 == null) return false;
    DateTime d1 = DateTime.parse(date1);
    DateTime d2 = DateTime.parse(date2);
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}

// ==================== AUDIO PLAYER WIDGET ====================

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String duration;
  final bool isMe;

  const AudioPlayerWidget({
    Key? key,
    required this.audioUrl,
    required this.duration,
    this.isMe = false,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentPosition = Duration.zero;
        });
      }
    });
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.isMe ? Colors.white : AppColors.color2;
    final textColor = widget.isMe ? Colors.white : Colors.black;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Play/Pause Button
        GestureDetector(
          onTap: _togglePlayPause,
          child: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: iconColor,
            size: 28,
          ),
        ),
        SizedBox(width: Dimensions.width5),

        // Progress Bar
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Slider
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: iconColor,
                  inactiveTrackColor: iconColor.withOpacity(0.3),
                  thumbColor: iconColor,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                  trackHeight: 2,
                ),
                child: Slider(
                  value: _currentPosition.inSeconds.toDouble(),
                  max:
                      _totalDuration.inSeconds.toDouble() > 0
                          ? _totalDuration.inSeconds.toDouble()
                          : 1,
                  onChanged: (value) async {
                    await _audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),

              // Duration Text
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  _isPlaying
                      ? _formatDuration(_currentPosition)
                      : widget.duration,
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
