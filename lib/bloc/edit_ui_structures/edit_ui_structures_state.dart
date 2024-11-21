part of 'edit_ui_structures_bloc.dart';

@immutable
abstract class EditUiStructuresState {}

class EditUiStructuresInitial extends EditUiStructuresState {}

class UpdateUiComponentBlocState extends EditUiStructuresState {
  final UpdateUIComponentState state;
  UpdateUiComponentBlocState({required this.state});
}
