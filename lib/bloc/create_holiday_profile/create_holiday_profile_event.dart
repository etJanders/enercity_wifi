part of 'create_holiday_profile_bloc.dart';

@immutable
abstract class CreateHolidayProfileEvent {}

class HolidayProfileImageSelected extends CreateHolidayProfileEvent {
  final String imageName;
  HolidayProfileImageSelected({required this.imageName});
}

class HolidayProfileNameSelected extends CreateHolidayProfileEvent {
  final String profileName;

  HolidayProfileNameSelected({required this.profileName});
}

class AddHolidayProfileRooms extends CreateHolidayProfileEvent {
  final List<String> groupids;
  AddHolidayProfileRooms({required this.groupids});
}
