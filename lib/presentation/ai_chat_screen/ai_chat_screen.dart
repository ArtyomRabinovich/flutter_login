import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

import '../../widgets/shared/glass_container.dart';
import '../../widgets/shared/neon_button.dart';
import '../../widgets/shared/custom_text_field.dart';

// Enum for message types
enum MessageType { user, ai, proposal, system }

// Base class for chat messages
abstract class ChatMessage {
  final String id;
  final MessageType type;
  ChatMessage({required this.id, required this.type});
}

class UserMessage extends ChatMessage {
  final String text;
  UserMessage({required String id, required this.text})
      : super(id: id, type: MessageType.user);
}

class AiMessage extends ChatMessage {
  final String text;
  AiMessage({required String id, required this.text})
      : super(id: id, type: MessageType.ai);
}

class ProposalMessage extends ChatMessage {
  final String title;
  final String summary;
  ProposalMessage({required String id, required this.title, required this.summary})
      : super(id: id, type: MessageType.proposal);
}

class SystemMessage extends ChatMessage {
  final String text;
  SystemMessage({required String id, required this.text})
      : super(id: id, type: MessageType.system);
}

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({Key? key}) : super(key: key);

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _messages.add(AiMessage(id: '1', text: "Welcome! How can I help you edit your project today? You can ask me to 'add captions', 'find best takes', or 'remove silence'."));
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    final text = _controller.text;
    setState(() {
      _messages.add(UserMessage(id: Random().toString(), text: text));
      _controller.clear();
      _isGenerating = true;
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        if (text.toLowerCase().contains("caption")) {
            _messages.add(ProposalMessage(id: Random().toString(), title: 'Add Animated Captions', summary: 'Analyzed audio and generated 42 caption segments. Style: Pop-up.'));
        } else {
            _messages.add(AiMessage(id: Random().toString(), text: "I've processed your request for '$text'. Here are the results."));
        }
        _isGenerating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14141D),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildComposer(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1E293B),
      elevation: 0,
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      title: Text('Project Video Edit', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.ios_share_outlined)),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
      ],
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      padding: EdgeInsets.all(3.w),
      reverse: true,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages.reversed.toList()[index];
        switch (message.type) {
          case MessageType.user:
            return UserMessageBubble(message: message as UserMessage);
          case MessageType.ai:
            return AiMessageBubble(message: message as AiMessage);
          case MessageType.proposal:
            return ProposalCard(message: message as ProposalMessage);
          case MessageType.system:
            return SystemMessageBubble(message: message as SystemMessage);
        }
      },
    );
  }

  Widget _buildComposer() {
    return GlassContainer(
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.white70),
            onPressed: () {},
          ),
          Expanded(
            child: CustomTextField(
              controller: _controller,
              hintText: 'Describe your edit...',
            ),
          ),
          SizedBox(width: 2.w),
          _isGenerating
              ? IconButton(
                  icon: Icon(Icons.stop_circle_outlined, color: Colors.red.shade400),
                  onPressed: () => setState(() => _isGenerating = false),
                )
              : NeonButton(
                  text: 'Send',
                  onPressed: _sendMessage,
                  width: 20.w,
                  height: 45,
                  fontSize: 14,
                ),
        ],
      ),
    );
  }
}

class UserMessageBubble extends StatelessWidget {
  final UserMessage message;
  const UserMessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h, left: 20.w),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: const Color(0xFF5A67F8),
          borderRadius: BorderRadius.circular(20).copyWith(bottomRight: Radius.circular(5)),
        ),
        child: Text(message.text, style: GoogleFonts.inter(color: Colors.white)),
      ),
    );
  }
}

class AiMessageBubble extends StatelessWidget {
  final AiMessage message;
  const AiMessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h, right: 20.w),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: const Color(0xFF334155),
          borderRadius: BorderRadius.circular(20).copyWith(bottomLeft: Radius.circular(5)),
        ),
        child: Text(message.text, style: GoogleFonts.inter(color: Colors.white)),
      ),
    );
  }
}

class SystemMessageBubble extends StatelessWidget {
  final SystemMessage message;
  const SystemMessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha((255 * 0.3).round()),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(message.text, style: GoogleFonts.inter(color: Colors.white70, fontSize: 11.sp)),
      ),
    );
  }
}


class ProposalCard extends StatelessWidget {
  final ProposalMessage message;
  const ProposalCard({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: EdgeInsets.only(bottom: 2.h, right: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.white)),
          SizedBox(height: 1.h),
          Text(message.summary, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12.sp)),
          SizedBox(height: 2.h),
          NeonButton(text: '▶️ Preview', onPressed: () {}, isPrimary: false, height: 40),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(child: NeonButton(text: '✅ Accept', onPressed: () {}, height: 40, fontSize: 14)),
              SizedBox(width: 2.w),
              Expanded(child: NeonButton(text: '✏️ Modify', onPressed: () {}, isPrimary: false, height: 40, fontSize: 14)),
              SizedBox(width: 2.w),
              IconButton(icon: Icon(Icons.close, color: Colors.red.shade400), onPressed: () {})
            ],
          )
        ],
      ),
    );
  }
}
