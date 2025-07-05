import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sdp/modals/chat.dart';
import 'package:sdp/providers/chat_provider.dart';
import 'package:sdp/providers/user_provider.dart';
// import 'package:sdp/repo/chat_repo.dart';
// import 'package:sdp/screens/welcome_screen.dart';
import 'package:uuid/uuid.dart';

/// Main home page for the plant health analysis application
///
/// This screen provides a chat interface where users can communicate with the
/// plant disease detection model, send images, and view responses in markdown format.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // Chat and UI state management
  List<Map<String, dynamic>> chats = [];
  var chatState;
  final FocusNode _focusNode = FocusNode();

  // Image handling properties
  File? _selectedImage;
  String _imageString = '';
  String _imagebase64Code = '';
  Map<String?, Uint8List> decodedImages = {};

  @override
  Widget build(BuildContext context) {
    // Access providers for chat and user data
    var chats = ref.watch(chatProviderNotifier);
    var users = ref.watch(userNotifierProvider.notifier);
    final chatNotifier = ref.read(chatProviderNotifier.notifier);

    // Get the text input controller from the chat provider
    TextEditingController chatController =
        ref.read(chatProviderNotifier.notifier).controller;

    return GestureDetector(
      // Dismiss keyboard when tapping outside the text field
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(236, 230, 240, 1),
            toolbarHeight: MediaQuery.of(context).size.height * 0.1,
            title: Row(
              children: [
                // App title with styled Plant Health+ text
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Plant Health ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "+",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Button to start a new chat
                IconButton(
                  onPressed: () {
                    ref.read(chatProviderNotifier.notifier).removeAll();
                    ref.read(chatProviderNotifier.notifier).startNewChat();
                  },
                  icon: const Icon(
                    Icons.post_add,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
              ],
            )),
        // Side drawer containing user info and chat history
        drawer: Drawer(
          child: Scaffold(
            // Logout button at the bottom of the drawer
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextButton(
                onPressed: () {
                  users.signOut();
                  users.goolgeSignOut();
                  Navigator.of(context).pushReplacementNamed("/");
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded),
                    SizedBox(width: 8),
                    Text(
                      "Log Out",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Drawer body with user info and chat history
            body: Padding(
              padding: const EdgeInsets.only(top: 70, right: 10, left: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display logged-in user's name
                    Center(
                      child: Text(
                        users.loggedInUser!.getName ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Chat History",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Fetch and display chat history
                    FutureBuilder<List<dynamic>>(
                      future:
                          ref.watch(chatProviderNotifier.notifier).fetchChat(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child:
                                Center(child: Text('No conversations found')),
                          );
                        }

                        // List of previous conversations
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final convo = snapshot.data![index];
                              return ListTile(
                                leading: const Icon(Icons.chat_bubble_outline),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        key: const Key("chat"),
                                        convo['title'] ??
                                            'Conversation ${index + 1}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    // Delete chat button
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          confirmDeleteRequest(convo['chatId']);
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                                // Load selected chat
                                onTap: () {
                                  ref
                                      .read(chatProviderNotifier.notifier)
                                      .loadChats(convo['chatId']);
                                  ref
                                      .read(chatProviderNotifier.notifier)
                                      .chatId = convo['chatId'];
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(236, 230, 240, 1),
        // Main chat interface
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Chat messages display area
            Expanded(
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  // Background with watermark effect
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage("assets/images/bg.png"),
                      colorFilter: ColorFilter.mode(
                        const Color.fromRGBO(236, 230, 240, 1).withOpacity(0.5),
                        BlendMode.dstATop,
                      ),
                      fit: BoxFit.contain,
                      invertColors: false,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.76,
                  // Chat messages list
                  child: ListView.builder(
                      reverse: true,
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        // Render model (AI) messages
                        if (chats[index].senderId == "model") {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // AI avatar
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  color: Colors.black,
                                ),
                                height: 30,
                                width: 30,
                                child: Image.asset("assets/images/bg.png"),
                              ),
                              // AI message bubble with conditional styling for errors
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: chats[index].message ==
                                            "Error processing request, Please try again or start new chat."
                                        ? Colors.red[200]
                                        : Colors.green[200],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: chats[index].message ==
                                              "Error processing request, Please try again or start new chat."
                                          ? Colors.red
                                          : Colors.green,
                                      width: 2,
                                    ),
                                  ),
                                  margin: const EdgeInsets.all(10),
                                  // Render AI responses as markdown
                                  child:
                                      MarkdownBody(data: chats[index].message),
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Render user messages
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User message bubble
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Display image if present in the message
                                      chats[index].imageString != ''
                                          ? decodedImages[chats[index]
                                                      .imageString] !=
                                                  null
                                              // Show cached image if available
                                              ? Image.memory(decodedImages[
                                                  chats[index].imageString]!)
                                              // Otherwise fetch and display image
                                              : FutureBuilder<String?>(
                                                  future: Future.delayed(
                                                    const Duration(seconds: 3),
                                                    () => chatNotifier
                                                        .fetchImage(chats[index]
                                                            .imageString!),
                                                  ),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator();
                                                    } else if (snapshot
                                                            .hasData &&
                                                        snapshot.data != null) {
                                                      // Decode and cache image data
                                                      final decodedBytes =
                                                          base64Decode(
                                                              snapshot.data!);
                                                      decodedImages[chats[index]
                                                              .imageString] =
                                                          decodedBytes;
                                                      return Image.memory(
                                                          decodedBytes);
                                                    } else {
                                                      return const Text(
                                                          'Loading image...');
                                                    }
                                                  },
                                                )
                                          : const SizedBox(),
                                      // Display message text
                                      Text(chats[index].message),
                                    ],
                                  ),
                                ),
                              ),
                              // User avatar
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    color: Colors.black),
                                height: 30,
                                width: 30,
                                child: const Icon(
                                  Icons.account_circle,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                ),
              ),
            ),
            // Input area section
            Column(
              children: [
                // Image preview area (only visible when image is selected)
                if (_selectedImage != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    color: const Color.fromRGBO(236, 230, 240, 1),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              // Selected image preview
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.file(
                                  _selectedImage!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Remove image button
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImage = null;
                                    _imageString = '';
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                // Message input area
                Container(
                  padding: const EdgeInsets.all(14),
                  height: MediaQuery.of(context).size.height * 0.11,
                  color: const Color.fromRGBO(236, 230, 240, 1),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Row(
                      children: [
                        // Image attachment options button
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'Option 1') {
                              await takeOrUploadPicture(ImageSource.camera);
                            } else if (value == 'Option 2') {
                              await takeOrUploadPicture(ImageSource.gallery);
                            }
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Option 1',
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.camera),
                                  Text("  Take Picture")
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Option 2',
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.photo),
                                  Text("Upload Picture")
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Text input field
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Expanded(
                            child: TextField(
                              key: const Key("chat_input"),
                              controller: chatController,
                              onSubmitted: (value) {
                                // Store image if one is selected
                                if (_imageString != '' &&
                                    _imagebase64Code != '') {
                                  chatNotifier.storeImage(
                                      _imageString, _imagebase64Code);
                                }
                                // Create chat message
                                Chat chat = Chat(
                                  sender: "user",
                                  msg: value,
                                  imageString: _imageString,
                                );
                                // Add message to chat provider
                                chatNotifier.addChat(
                                    chat,
                                    users.loggedInUser!.getId,
                                    _imagebase64Code);

                                // Reset image state and clear input
                                setState(() {
                                  _imageString = '';
                                  _selectedImage = null;
                                  _imagebase64Code = '';
                                });
                                chatController.clear();
                              },
                              focusNode: _focusNode,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up resources
    _focusNode.dispose();
    super.dispose();
  }

  /// Displays a confirmation dialog before deleting a chat
  ///
  /// @param chatId - The ID of the chat to be deleted
  Future confirmDeleteRequest(var chatId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content:
              const Text("Are you sure you want to delete this chat session?"),
          actions: [
            // Cancel button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(chatProviderNotifier.notifier).loadChats(chatId);
              },
              child: const Text("Cancel"),
            ),
            // Delete button with action
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close drawer

                // Execute delete action and clear cache
                ref.watch(chatProviderNotifier.notifier).deleteChat(chatId);
                decodedImages.clear();
                ref.read(chatProviderNotifier.notifier).removeAll();
                ref.watch(chatProviderNotifier.notifier).fetchChat();
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// Generates a shortened UUID for image identification
  ///
  /// @returns A 12-character unique identifier for images
  String getShortUUID() {
    var uuid = const Uuid().v4();
    var bytes = utf8.encode(uuid);
    var short = base64UrlEncode(bytes).replaceAll('=', '');
    return short.substring(0, 12); // Limited to 12 characters for efficiency
  }

  /// Takes or selects a picture from camera or gallery
  ///
  /// @param source - The image source (camera or gallery)
  Future<void> takeOrUploadPicture(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        // Update UI with selected image
        setState(() {
          _selectedImage = File(image.path);
        });

        // Encode image to base64 and generate a unique ID
        List<int> imageBase64 = _selectedImage!.readAsBytesSync();
        _imagebase64Code = base64Encode(imageBase64);
        _imageString = getShortUUID();
      }
    } catch (e) {
      // Display error if image picking fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
