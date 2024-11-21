part of 'edit_ui_structures_bloc.dart';

@immutable
abstract class EditUiStructuresEvent {}

class UpdateUiComponents extends EditUiStructuresEvent {
  final DatabaseModel databaseModel;
  UpdateUiComponents({required this.databaseModel});
}
