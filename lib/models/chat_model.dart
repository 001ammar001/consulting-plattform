class ChatListItem {
  final int chatId;
  final Map<String, dynamic>? lastMassege;
  final Map<String, dynamic> otherUser;
  late final otherUserId = otherUser["user_id"];
  late final otherUserFirstName = otherUser["first_name"];
  late final otherUserLastName = otherUser["last_name"];
  late final otherUserImage = otherUser["image"];

  ChatListItem(
      {required this.chatId,
      required this.lastMassege,
      required this.otherUser});

  factory ChatListItem.fromJson(Map<String, dynamic> json) {
    return ChatListItem(
      chatId: json['chat_id'],
      lastMassege: json['last_message'],
      otherUser: json['other_user'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    data['last_message'] = lastMassege;
    data['other_user'] = otherUser;
    return data;
  }
}

class Massege {
  final int userId;
  final String massege;

  Massege({
    required this.userId,
    required this.massege,
  });

  factory Massege.fromJson(Map<String, dynamic> json) {
    return Massege(
      userId: json['user_id'],
      massege: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['message'] = massege;
    return data;
  }
}
