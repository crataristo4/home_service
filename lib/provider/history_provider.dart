import 'package:flutter/material.dart';
import 'package:home_service/models/history.dart';
import 'package:home_service/service/history_service.dart';
import 'package:home_service/ui/views/auth/appstate.dart';

class HistoryProvider with ChangeNotifier {
  HistoryService _historyService = HistoryService();

  String? _id, _name, _message, _photoUrl;

  get name => _name;

  get id => _id;

  get message => _message;

  get photoUrl => _photoUrl;

  updateProviderListener(value1, value2, value3, value4) {
    _id = value1;
    _name = value2;
    _photoUrl = value3;
    _message = value4;

    notifyListeners();
  }

  createHistory(String artisanId) {
    artisanId = _id!;
    History history = History(
        id: currentUserId,
        name: name,
        photoUrl: photoUrl,
        message: message,
        timestamp: timeStamp);

    _historyService.createHistory(history, artisanId);
  }
}
