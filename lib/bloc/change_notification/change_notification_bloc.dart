import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api_handler/api_treiber/update_ui_components/update_ui_components_helper.dart';

part 'change_notification_event.dart';
part 'change_notification_state.dart';

//Change E-Mail Notification state
class ChangeNotificationBloc
    extends Bloc<ChangeNotificationEvent, ChangeNotificationState> {
  ChangeNotificationBloc() : super(ChangeNotificationInitial()) {
    on<ChangeMailNotification>((event, emit) async {
      UpdateUIComponentState state = await UpdateUiComponentsHelper()
          .updateNotification(notification: event.notificationState);
      emit(NotificationChanged(stateChanged: state));
    });

    on<SaveDataAndGoToHomePage>((event, emit) async {
      emit(NavigateToHomePage());
    });
  }
}
