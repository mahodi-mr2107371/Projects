/// Represents an individual message in a chat conversation
///
/// This class stores a single message with its content, sender information,
/// and optional image reference. It supports serialization for database storage.
class Chat {
  /// ID of the message sender (e.g., "user" or "model")
  final String _senderId;

  /// Text content of the message
  final String _msg;

  /// Optional reference to an image associated with this message
  /// Contains an image identifier, empty string if no image
  final String _imageString;

  /// Creates a new chat message
  ///
  /// @param sender ID of who sent the message ("user" or "model")
  /// @param msg Text content of the message
  /// @param imageString Reference to associated image (empty string if none)
  const Chat(
      {required String sender,
      required String msg,
      required String imageString})
      : _msg = msg,
        _senderId = sender,
        _imageString = imageString;

  /// Gets the message content
  String get message => _msg;

  /// Gets the sender's identifier
  String get senderId => _senderId;

  /// Gets the image reference (if any)
  String? get imageString => _imageString;

  /// Creates a Chat object from a JSON map
  ///
  /// Used when deserializing message data from the database
  ///
  /// @param map JSON map containing message properties
  /// @returns A new Chat instance
  factory Chat.fromJson(Map<String, dynamic> map) {
    return Chat(
      sender: map['senderId'],
      msg: map['message'],
      imageString: map['image'] ?? '',
    );
  }

  /// Converts the Chat object to a JSON map
  ///
  /// Used when storing message data to the database
  ///
  /// @returns Map representing the message data
  Map<String, dynamic> toJson() {
    return {
      'senderId': _senderId,
      'message': _msg,
      'image': _imageString,
    };
  }
}
