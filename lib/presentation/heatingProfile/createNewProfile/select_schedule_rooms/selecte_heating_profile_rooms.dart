import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wifi_smart_living/bloc/create_heating_profile/create_heating_profile_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_empty.dart';
import 'package:wifi_smart_living/presentation/general_widgets/radio_list_tile/radio_list_tile.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../../api_handler/api_treiber/sync/sync_database_entries.dart';

class SelectHeatingProfileRoomPage extends StatefulWidget {
  final Function nextCallback;
  const SelectHeatingProfileRoomPage({super.key, required this.nextCallback});

  @override
  State<SelectHeatingProfileRoomPage> createState() =>
      _SelectHeatingProfileRoomPageState();
}

class _SelectHeatingProfileRoomPageState
    extends State<SelectHeatingProfileRoomPage> {
  List<String> selectedRooms = [];

  @override
  Widget build(BuildContext context) {
    final syncData = Provider.of<DatabaseSync>(context);
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocConsumer<CreateHeatingProfileBloc, CreateHeatingProfileState>(
      listener: (context, state) {
        if (state is ScheduleDataSet) {
          widget.nextCallback();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: const BackButtonWidget(),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(local.createHeatingProfileTitle),
                Text(
                  local.roomOverview,
                  style: AppTheme.textStyleDefault.copyWith(fontSize: 16.0),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(Dimens.paddingDefault),
            child: Column(
              children: [
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                Text(
                  local.selectHeatingProfileRooms,
                  style: AppTheme.textStyleColored,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                Expanded(
                  child: syncData.helper
                          .getGroupsWithoutTimeSchedule()
                          .isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(Dimens.paddingDefault),
                          child: ListView.separated(
                              itemBuilder: (BuildContext context, int index) =>
                                  RadioListTileItem(
                                      groupManagement: syncData.helper
                                              .getGroupsWithoutTimeSchedule()[
                                          index],
                                      itemClicked: () {
                                        addOrRemoveNewRoom(syncData.helper
                                                .getGroupsWithoutTimeSchedule()[
                                            index]);
                                      }),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                        color: AppTheme.textDarkGrey,
                                      ),
                              itemCount: syncData.helper
                                  .getGroupsWithoutTimeSchedule()
                                  .length),
                        )
                      : Center(
                          child: Text(
                            local.allRoomsEditToHeatingProfile,
                            textAlign: TextAlign.center,
                            style: AppTheme.textStyleDefault,
                          ),
                        ),
                ),
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                selectedRooms.isEmpty
                    ? ClickButton(
                        buttonText: local.next,
                        buttonFunktion: () {},
                        width: double.infinity)
                    : ClickButtonFilled(
                        buttonText: local.next,
                        buttonFunktion: () {
                          BlocProvider.of<CreateHeatingProfileBloc>(context)
                              .add(AddScheduleRooms(groupids: selectedRooms));
                        },
                        width: double.infinity)
              ],
            ),
          ),
        );
      },
    );
  }

  void addOrRemoveNewRoom(ModelGroupManagement management) {
    setState(() {
      if (selectedRooms.contains(management.groupId)) {
        selectedRooms.remove(management.groupId);
      } else {
        selectedRooms.add(management.groupId);
      }
    });
  }
}
