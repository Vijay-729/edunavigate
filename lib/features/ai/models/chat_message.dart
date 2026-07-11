/// A single message in the AI Mentor conversation.
class ChatMessage {
  final String text;
  final bool fromUser;
  final bool isError;

  const ChatMessage({
    required this.text,
    required this.fromUser,
    this.isError = false,
  });
}
