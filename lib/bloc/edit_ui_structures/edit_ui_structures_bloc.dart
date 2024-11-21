// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api_handler/api_treiber/update_ui_components/update_ui_components_helper.dart';
import '../../models/database/datenbank_models.dart';

part 'edit_ui_structures_event.dart';
part 'edit_ui_structures_state.dart';

class EditUiStructuresBloc
    extends Bloc<EditUiStructuresEvent, EditUiStructuresState> {
  EditUiStructuresBloc() : super(EditUiStructuresInitial()) {
    on<UpdateUiComponents>((event, emit) async {
      UpdateUIComponentState state = await UpdateUiComponentsHelper()
          .updateDatabase(databaseModel: event.databaseModel);
      emit(UpdateUiComponentBlocState(state: state));
    });
  }
}
