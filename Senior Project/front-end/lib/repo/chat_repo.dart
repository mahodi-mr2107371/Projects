import 'package:dio/dio.dart';
import 'package:sdp/modals/chat.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

/// Repository for managing chat-related operations
///
/// Handles communication with the backend API and Supabase database for:
/// - Retrieving and storing chat messages
/// - Processing queries through the AI model
/// - Managing chat history
/// - Storing and retrieving images associated with chats
class ChatRepo {
  // HTTP client for API communication
  final _dio = Dio();

  // Backend server URL for API calls
  final _baseUrl = 'http://192.168.10.5:8080';
  // Alternative server URLs (commented out)
  // final _baseUrl = 'http://192.168.67.139:8080';
  // final _baseUrl = 'http://192.168.43.155:8080';

  // Supabase client for database operations
  final supabase = Supabase.instance.client;

  // In-memory storage for current chat messages
  List<dynamic> _chatArray = [];

  /// Updates the in-memory chat array
  set chatArray(List<dynamic> value) {
    _chatArray = value;
  }

  //---------------------- NETWORK UTILITIES ----------------------//

  /// Retrieves the device's local IP address
  ///
  /// Useful for dynamic backend URL configuration when testing locally
  ///
  /// @returns The device's IPv4 address as a string, or null if not found
  Future<String?> getLocalIpAddress() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          return addr.address;
        }
      }
    }
    return null;
  }

  //---------------------- CHAT RETRIEVAL ----------------------//

  /// Fetches all chat sessions for a specific user
  ///
  /// @param uid User ID to fetch chats for
  /// @returns List of chat sessions from the database
  Future<List<dynamic>> fetchChats(String uid) async {
    var response = await supabase.from("chat").select('*').eq('userId', uid);
    List list = [];
    for (var item in response) {
      list.add(item);
    }
    return list;
  }

  /// Loads messages from a specific chat session
  ///
  /// @param chatId Identifier for the chat session to load
  /// @returns List of messages from the specified chat
  Future<List<dynamic>> loadChats(var chatId) async {
    return await supabase.from('chat').select("*").eq('chatId', chatId);
  }

  //---------------------- MODEL INTERACTION ----------------------//

  /// Sends a user query to the AI backend and receives a response
  ///
  /// Includes conversation history for context awareness
  ///
  /// @param chat Chat object containing the message and image reference
  /// @returns AI model's response as a string
  Future<String> postQuery(Chat chat) async {
    // Convert in-memory chat array to a format expected by the model
    List<Map<String, dynamic>> history = _chatArray
        .map((e) => {
              "role": e['senderId'] == 'user' ? 'user' : 'model',
              "parts": e['message'] ?? ''
            })
        .toList();

    // Prepare the request payload
    var payload = {
      'message': chat.message,
      'image': chat.imageString,
      'history': history
    };

    try {
      // Send request to backend API
      Response response = await _dio.post("$_baseUrl/query", data: payload);
      var data = response.data["message"];
      return data;
    } catch (e) {
      // Silent error handling - could be improved with logging
      return "";
    }
  }

  //---------------------- CHAT STORAGE ----------------------//

  /// Stores a chat message in the database
  ///
  /// Adds the message to in-memory array and persists the entire chat session
  ///
  /// @param chat Chat object containing the message details
  /// @param userId ID of the user who owns the chat
  /// @param chatId ID of the chat session
  /// @returns null after operation completes
  Future<String?> storeChat(Chat chat, var userId, var chatId) async {
    // Prepare message data
    var messageData = {
      'message': chat.message,
      'image': chat.imageString,
      'senderId': chat.senderId
    };

    // Add to in-memory array
    _chatArray.add(messageData);

    // Persist to database
    await supabase.from('chat').upsert({
      'chatId': chatId,
      'chats': _chatArray,
      'userId': userId,
    });

    return null;
  }

  /// Clears the in-memory chat array
  ///
  /// Used when starting a new conversation or switching between chats
  void clearChatArray() {
    chatArray = [];
  }

  /// Deletes a chat session and its associated images
  ///
  /// @param chatId ID of the chat session to delete
  Future<void> deleteChat(var chatId) async {
    // First fetch the chat to get associated images
    var chats = await supabase.from('chat').select('*').eq('chatId', chatId);

    // Delete all images associated with this chat
    for (var chat in chats) {
      for (var convo in chat['chats']) {
        if (convo['image'] != null && convo['image'] != '') {
          await supabase.from('images').delete().eq('imageId', convo['image']);
        }
      }
    }

    // Delete the chat session itself
    await supabase.from('chat').delete().eq('chatId', chatId);
  }

  //---------------------- IMAGE HANDLING ----------------------//

  /// Stores an image in the database
  ///
  /// @param imageId Unique identifier for the image
  /// @param base64Code Base64-encoded image data
  /// @returns null after operation completes
  Future<String?> storeImage(var imageId, var base64Code) async {
    await supabase
        .from('images')
        .insert({'imageId': imageId, 'base64_code': base64Code});
    return null;
  }

  /// Retrieves an image from the database
  ///
  /// @param imageId Unique identifier for the image to fetch
  /// @returns Base64-encoded image data, or null if not found
  Future<String?> fetchImage(String imageId) async {
    final response = await supabase
        .from('images')
        .select('base64_code')
        .eq('imageId', imageId)
        .single();

    if (response['base64_code'] != null) {
      return response['base64_code'] as String;
    } else {
      return null;
    }
  }
}
