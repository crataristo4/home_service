class History {
  final id;
  final name;
  final photoUrl;
  final message;
  final timestamp;

  History(
      {required this.id,
      required this.name,
      required this.photoUrl,
      required this.message,
      required this.timestamp});

  factory History.fromFirestore(Map<String, dynamic> data) {
    return History(
        id: data['id'],
        name: data['name'],
        photoUrl: data['photoUrl'],
        message: data['message'],
        timestamp: data['timestamp']);
  }

  Map<String, dynamic> historyToMap() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'message': message,
      'timestamp': timestamp
    };
  }
}
