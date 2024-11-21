// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api_handler/api_treiber/create_new_schedule/create_new_schedule_helper.dart';
import '../../helper/create_heating_profile/create_heating_profile_helper.dart';

part 'create_holiday_profile_event.dart';
part 'create_holiday_profile_state.dart';

class CreateHolidayProfileBloc
    extends Bloc<CreateHolidayProfileEvent, CreateHolidayProfileState> {
  final CreateHeatingProfileHelper _heatingProfileHelper =
      CreateHeatingProfileHelper();

  CreateHolidayProfileBloc() : super(CreateHolidayProfileInitial()) {
    on<HolidayProfileNameSelected>((event, emit) {
      _heatingProfileHelper.setScheduleName(scheduleName: event.profileName);
      emit(ProfileDataSet());
    });

    on<AddHolidayProfileRooms>((event, emit) {
      _heatingProfileHelper.addRoomsToSchedule(event.groupids);
      emit(ProfileDataSet());
    });

    on<HolidayProfileImageSelected>((event, emit) async {
      _heatingProfileHelper.setScheduleImage(
          scheduleImageName: event.imageName);
      CreateScheduleState state = await CreateScheduleHelper()
          .createNewHolidayProfile(helper: _heatingProfileHelper);
      emit(CreateHolidayProfileResponse(state: state));
    });
  }
}
