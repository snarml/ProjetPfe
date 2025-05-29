import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/messageModel.dart';
import '../../models/userModel.dart';
import '../../models/contact.dart';
import '../../widgets/suggested_contacts.dart';
import 'conversation_detail_screen.dart';
import '../../widgets/recent_search_contacts.dart';

class MessageSearchScreen extends StatefulWidget {
  const MessageSearchScreen({super.key});

  @override
  State<MessageSearchScreen> createState() => _MessageSearchScreenState();
}

class _MessageSearchScreenState extends State<MessageSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text("المحادثات", textDirection: TextDirection.rtl),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            color: Colors.green,
            child: Form(
              child: TextFormField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  suffixIcon: Icon(
                    Icons.search,
                    color: const Color(0xFF1D1D35).withOpacity(0.64),
                  ),
                  hintText: "ابحث...",
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: TextStyle(
                    color: const Color(0xFF1D1D35).withOpacity(0.64),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0 * 1.5, vertical: 16.0),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: const [
                  RecentSearchContacts(),
                  SizedBox(height: 16.0),
                  SuggestedContacts(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}