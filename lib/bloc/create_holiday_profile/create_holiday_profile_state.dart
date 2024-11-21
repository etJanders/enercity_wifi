part of 'create_holiday_profile_bloc.dart';

@immutable
abstract class CreateHolidayProfileState {}

class CreateHolidayProfileInitial extends CreateHolidayProfileState {}

class ProfileDataSet extends CreateHolidayProfileState {}

class CreateHolidayProfileResponse extends CreateHolidayProfileState {
  final CreateScheduleState state;

  CreateHolidayProfileResponse({required this.state});
}
