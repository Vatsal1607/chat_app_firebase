import 'package:chat_app_firebase/components/custom_textfield.dart';
import 'package:chat_app_firebase/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;

  ChatPage({required this.receiverUserEmail, required this.receiverUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserId, _messageController.text);
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 2.0,
        ),
        child: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  // build msg list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserId, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            padding: EdgeInsets.only(top: 10.0),
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  // build msg item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the message to the right if sender is current user, otherwise to the left.
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.topRight
        : Alignment.topLeft;

    return Container(
      alignment: alignment,
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.tealAccent,
            borderRadius: BorderRadius.only(
              topRight: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? Radius.circular(0.0)
                  : Radius.circular(18.0),
              topLeft: (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? Radius.circular(18.0)
                  : Radius.circular(0.0),
              bottomRight: Radius.circular(18.0),
              bottomLeft: Radius.circular(18.0),
            )),
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              data['senderEmail'],
            ),
            Text(
              data['message'],
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  // build msg input
  _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        children: [
          //textfield
          Expanded(
            child: SizedBox(
              height: 60.0,
              child: CustomTextField(
                controller: _messageController,
                hintText: 'Enter message',
                obscureText: false,
              ),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: Icon(
              Icons.arrow_upward_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
