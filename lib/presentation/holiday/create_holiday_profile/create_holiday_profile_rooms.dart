import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wifi_smart_living/bloc/create_holiday_profile/create_holiday_profile_bloc.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_colored.dart';
import 'package:wifi_smart_living/presentation/general_widgets/click_buttons/click_button_empty.dart';
import 'package:wifi_smart_living/presentation/general_widgets/radio_list_tile/radio_list_tile.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../../api_handler/api_treiber/sync/sync_database_entries.dart';
import '../../../models/database/model_group_management.dart';

class SelectHolidayProfileRoomsPage extends StatefulWidget {
  final Function nextCallback;
  const SelectHolidayProfileRoomsPage({super.key, required this.nextCallback});

  @override
  State<SelectHolidayProfileRoomsPage> createState() =>
      _SelectHolidayProfileRoomsPageState();
}

class _SelectHolidayProfileRoomsPageState
    extends State<SelectHolidayProfileRoomsPage> {
  List<String> selectedRooms = [];
  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return BlocConsumer<CreateHolidayProfileBloc, CreateHolidayProfileState>(
      listener: (context, state) {
        if (state is ProfileDataSet) {
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
                Text(local.createHolidayProfile),
                Text(
                  local.roomOverview,
                  style: AppTheme.textStyleDefault.copyWith(fontSize: 16.0),
                )
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
                  local.selectHolidayProfileRooms,
                  style: AppTheme.textStyleColored,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: Dimens.sizedBoxDefault,
                ),
                Expanded(
                    child: context
                            .read<DatabaseSync>()
                            .helper
                            .getGroupsWithoutHolidayProfile()
                            .isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.all(Dimens.paddingDefault),
                            child: ListView.separated(
                                itemBuilder: ((context, index) =>
                                    RadioListTileItem(
                                        groupManagement: context
                                                .read<DatabaseSync>()
                                                .helper
                                                .getGroupsWithoutHolidayProfile()[
                                            index],
                                        itemClicked: () {
                                          addOrRemoveNewRoom(context
                                                  .read<DatabaseSync>()
                                                  .helper
                                                  .getGroupsWithoutHolidayProfile()[
                                              index]);
                                        })),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(
                                          color: AppTheme.textDarkGrey,
                                        ),
                                itemCount: context
                                    .read<DatabaseSync>()
                                    .helper
                                    .getGroupsWithoutHolidayProfile()
                                    .length))
                        : Center(
                            child: Text(
                              local.allRoomsEditToHolidayProfile,
                              textAlign: TextAlign.center,
                              style: AppTheme.textStyleDefault,
                            ),
                          )),
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
                          BlocProvider.of<CreateHolidayProfileBloc>(context)
                              .add(AddHolidayProfileRooms(
                                  groupids: selectedRooms));
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
