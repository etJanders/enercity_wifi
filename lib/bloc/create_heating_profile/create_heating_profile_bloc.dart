import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/create_new_schedule/create_new_schedule_helper.dart';
import 'package:wifi_smart_living/helper/create_heating_profile/create_heating_profile_helper.dart';

part 'create_heating_profile_event.dart';
part 'create_heating_profile_state.dart';

///Description
///Bloc manages the process to create a new heating profile
///
///Author: J. Anders
///created: 09-01-2023
///changed: 09-01-2023
///
///History:
///
///Notes:
///
class CreateHeatingProfileBloc
    extends Bloc<CreateHeatingProfileEvent, CreateHeatingProfileState> {
  final CreateHeatingProfileHelper _heatingProfileHelper =
      CreateHeatingProfileHelper();

  CreateHeatingProfileBloc() : super(CreateHeatingProfileInitial()) {
    on<ScheduleImageSelected>((event, emit) async {
      _heatingProfileHelper.setScheduleImage(
          scheduleImageName: event.imageName);
      CreateScheduleState state = await CreateScheduleHelper()
          .createNewSchedule(helper: _heatingProfileHelper);
      emit(CreateScheduleResponse(state: state));
    });

    on<ScheduleNameSelected>((event, emit) async {
      _heatingProfileHelper.setScheduleName(scheduleName: event.scheduleName);

      emit(ScheduleDataSet());
    });

    on<AddScheduleRooms>((event, emit) {
      _heatingProfileHelper.addRoomsToSchedule(event.groupids);
      emit(ScheduleDataSet());
    });
  }
}
