import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdp/modals/chat.dart';
import 'package:sdp/providers/user_provider.dart';
import 'package:sdp/repo/chat_repo.dart';
import 'package:sdp/repo/user_repo.dart';
import 'package:uuid/uuid.dart';

/// Manages chat state and operations for the application
///
/// This notifier handles all chat-related functionality including:
/// - Managing chat messages in state
/// - Sending messages to AI model and handling responses
/// - Loading and storing chat history
/// - Image handling for chat messages
class ChatProvider extends AutoDisposeNotifier<List<Chat>> {
  // Repositories for data access
  ChatRepo chatRepo = ChatRepo();
  UserRepo userRepo = UserRepo();

  // Current chat session identifier
  String _chatId = const Uuid().v4();

  // Text input controller for chat messages
  final TextEditingController _chatController = TextEditingController();

  /// Getter for the current chat ID
  String get chatId => _chatId;

  /// Setter for the chat ID (used when loading existing chats)
  set chatId(String chatId) {
    _chatId = chatId;
  }

  /// Getter for the text input controller
  TextEditingController get controller => _chatController;

  @override
  List<Chat> build() {
    // Clean up resources when the provider is disposed
    ref.onDispose(() {
      _chatController.dispose();
    });

    // Initialize with empty chat list
    return [];
  }

  //---------------------- CHAT SESSION MANAGEMENT ----------------------//

  /// Creates a new chat session
  ///
  /// Generates a new unique ID and clears any existing messages
  void startNewChat() {
    _chatId = const Uuid().v4();
    chatRepo.clearChatArray();
    state = [];
  }

  /// Removes all messages from the current chat
  void removeAll() {
    state = [];
  }

  //---------------------- MESSAGE OPERATIONS ----------------------//

  /// Adds a new user message and gets AI response
  ///
  /// This method:
  /// 1. Adds the user's message to the chat state
  /// 2. Stores the message in the database
  /// 3. Sends the message to the AI model for processing
  /// 4. Adds the AI's response to the chat state
  /// 5. Stores the AI response in the database
  ///
  /// @param chat User's chat message
  /// @param userId ID of the current user
  /// @param base64Code Base64-encoded image data if present
  Future<void> addChat(Chat chat, String? userId, base64Code) async {
    // Create a new chat object including any image
    Chat newChat =
        Chat(sender: chat.senderId, msg: chat.message, imageString: base64Code);

    // Add user message to state (UI updates immediately)
    state = [chat, ...state];

    // Store user message in database
    chatRepo.storeChat(chat, userId!, _chatId);

    // Get response from AI model
    String response = await chatRepo.postQuery(newChat);

    // Create chat object for model response
    Chat modelResponse = Chat(sender: "model", msg: response, imageString: '');

    // Store model response if valid
    if (response !=
        "Error processing request, Please try again or start new chat.") {
      await chatRepo.storeChat(modelResponse, userId, chatId);
    }

    // Add model response to state (UI updates with response)
    state = [modelResponse, ...state];
  }

  /// Loads an existing chat from the database
  ///
  /// @param chatId ID of the chat to load
  void loadChats(var chatId) async {
    var response = await chatRepo.loadChats(chatId);
    removeAll();
    List<dynamic> chatArray = [];

    try {
      // Parse each chat message from the response
      for (var chat in response[0]['chats']) {
        state = [Chat.fromJson(chat), ...state];
        chatArray.add(chat);
      }
      // Update chat repository with loaded messages
      chatRepo.chatArray = chatArray;
    } catch (e) {
      // Silent error handling - could be improved
    }
  }

  //---------------------- CHAT DATA OPERATIONS ----------------------//

  /// Fetches all chat sessions for the current user
  ///
  /// @returns List of chat sessions
  Future<List<dynamic>> fetchChat() async {
    var response = await chatRepo
        .fetchChats(ref.read(userNotifierProvider.notifier).loggedInUser!.id!);
    return response;
  }

  /// Deletes a chat session
  ///
  /// @param chatId ID of the chat to delete
  Future<void> deleteChat(var chatId) async {
    await chatRepo.deleteChat(chatId);
    startNewChat();
  }

  //---------------------- IMAGE HANDLING ----------------------//

  /// Retrieves an image by ID
  ///
  /// @param imageId ID of the image to fetch
  /// @returns Base64-encoded image data
  Future<String?> fetchImage(var imageId) async {
    var response = await chatRepo.fetchImage(imageId);
    return response;
  }

  /// Stores an image in the database
  ///
  /// @param imageId Unique ID for the image
  /// @param base64code Base64-encoded image data
  /// @returns Response from storage operation
  Future<String?> storeImage(var imageId, var base64code) async {
    var response = await chatRepo.storeImage(imageId, base64code);
    return response;
  }
}

/// Provider for fetching chats for a specific user
///
/// This provider creates a future that loads chat history for a given user ID
final chatFutureProvider =
    FutureProvider.family<List<dynamic>, String>((ref, userId) async {
  final chatRepo = ChatRepo();
  return await chatRepo.fetchChats(userId);
});

/// Main provider for accessing ChatProvider throughout the app
///
/// This auto-disposable provider manages the lifecycle of the ChatProvider
/// and makes it available to the widget tree
final chatProviderNotifier =
    NotifierProvider.autoDispose<ChatProvider, List<Chat>>(
        () => ChatProvider());
