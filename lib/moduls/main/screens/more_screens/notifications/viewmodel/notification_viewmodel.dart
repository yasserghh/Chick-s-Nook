import 'dart:async';

import 'package:foodapp/core/bases/base_viewmodel.dart';
import 'package:foodapp/moduls/main/domain/models/notification_model.dart';
import 'package:foodapp/moduls/main/domain/use_cases/use_caces.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../core/common/state_rendrer/state_rendrer_impl.dart';

class NotificationViewModel extends BaseViewModel
  {
  NotificationsUseCace _useCace;
  NotificationViewModel(this._useCace);
  final StreamController _notificationStream = BehaviorSubject<List<Notifi>?>();
  @override
  dispose() {
    getNotification();
  }

  @override
  start() {
    flowStateInput.add(LoadingStateFullScreen(''));
    getNotification();
  }

  @override
  Sink get notificationInput => _notificationStream.sink;

  @override
  Stream<List<Notifi>?> get notificationOutput =>
      _notificationStream.stream.map((event) => event);

  @override
  getNotification() async {
    (await _useCace.excute(HomeInpts())).fold(
        (l) => {
              flowStateInput.add(ErrorStateFullScreen(l.message)),
            },
        (data) => {
              notificationInput.add(data.notifications),
              flowStateInput.add(ContentState()),
            });
  }
}

abstract class NotificationInput {
  Sink get notificationInput;
  getNotification();
}

abstract class NotificationOutput {
  Stream<List<Notifi>?> get notificationOutput;
}
