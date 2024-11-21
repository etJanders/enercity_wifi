// // import 'package:flutter/material.dart';
// // import 'package:focused_menu/focused_menu.dart';
// // import 'package:focused_menu/modals.dart';
// // import 'package:wifi_smart_living/dimens.dart';
// // import 'package:wifi_smart_living/models/database/model_group_management.dart';
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// // import 'package:wifi_smart_living/theme.dart';
// //
// // import '../../core/image_mapping/image_name_mapping.dart';
// //
// // class ScheduleRoomTile extends StatelessWidget {
// //   final ModelGroupManagement groupManagement;
// //   final Function deleteRoomFromSchedule;
// //   const ScheduleRoomTile(
// //       {super.key,
// //       required this.groupManagement,
// //       required this.deleteRoomFromSchedule});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     AppLocalizations local = AppLocalizations.of(context)!;
// //     return FocusedMenuHolder(
// //       blurSize: 1,
// //       menuItemExtent: 60,
// //       menuWidth: MediaQuery.of(context).size.width * 0.5,
// //       onPressed: () {},
// //       menuItems: [
// //         FocusedMenuItem(
// //             title: Text(
// //               local.delete,
// //               style: AppTheme.textStyleBackground,
// //             ),
// //             trailingIcon: const Icon(
// //               Icons.delete,
// //               color: AppTheme.hintergrund,
// //             ),
// //             onPressed: () {
// //               deleteRoomFromSchedule();
// //             })
// //       ],
// //       child: GridTile(
// //         footer: Container(
// //           padding: const EdgeInsets.only(left: Dimens.paddingDefault),
// //           child: GridTileBar(
// //             title: Text(
// //               groupManagement.groupName,
// //               textAlign: TextAlign.start,
// //               style: AppTheme.textStyleDefault,
// //             ),
// //           ),
// //         ),
// //         child: Image.asset(
// //             "assets/images/${ImageMapping().getImageNameToShow(imageName: groupManagement.groupImage)}"),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:focused_menu/focused_menu.dart';
// import 'package:focused_menu/modals.dart';
// import 'package:wifi_smart_living/dimens.dart';
// import 'package:wifi_smart_living/models/database/model_group_management.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:wifi_smart_living/theme.dart';
//
// import '../../core/image_mapping/image_name_mapping.dart';
// import '../general_widgets/popup_menu/popup_menu_delete_widget.dart';
//
// class ScheduleRoomTile extends StatelessWidget {
//   final ModelGroupManagement groupManagement;
//   final Function deleteRoomFromSchedule;
//   const ScheduleRoomTile(
//       {super.key,
//         required this.groupManagement,
//         required this.deleteRoomFromSchedule});
//
//   @override
//   Widget build(BuildContext context) {
//     AppLocalizations local = AppLocalizations.of(context)!;
//     return InkWell(
//       // blurSize: 1,
//       // menuItemExtent: 60,
//       // menuWidth: MediaQuery.of(context).size.width * 0.5,
//       // onPressed: () {},
//       // menuItems: [
//       //   FocusedMenuItem(
//       //       title: Text(
//       //         local.delete,
//       //         style: AppTheme.textStyleBackground,
//       //       ),
//       //       trailingIcon: const Icon(
//       //         Icons.delete,
//       //         color: AppTheme.hintergrund,
//       //       ),
//       //       onPressed: () {
//       //         deleteRoomFromSchedule();
//       //       })
//       // ],
//       child: GridTile(
//         header: Container(
//           padding: const EdgeInsets.only(
//               top: 0, left: 25, right: 5),
//           child:Column(
//           children: [
//
//        Expanded(
//
//           child:
//
//           Align(
//               alignment: Alignment.topRight,
//               child: FittedBox(
//
//                   child:
//                     PopupMenuDeleteWidget(
//
//                       callback: (value) {
//                         deleteRoomFromSchedule();
//                       },
//
//                       icon: const Icon(
//                         Icons.more_vert,
//                         color: AppTheme.schriftfarbe,
//                       ),
//                     ),
//               )
//           )
//      ),
//        Expanded(
//           child: Align(
//             alignment: Alignment.bottomLeft,
//             child: FittedBox(
//                 child:
//                 Text(
//                         groupManagement.groupName,
//                         textAlign: TextAlign.start,
//
//                         style: AppTheme.textStyleDefault,
//                       ),
//             ),
//           )
//        ),
//       ],
//           )
//           // Container(
//           //   child:
//           //
//           //   Column(
//           //   mainAxisAlignment: MainAxisAlignment.end,
//           //
//           //   children: [
//           //
//           //     // GridTileBar(
//           //
//           //
//           //     //  ),
//           //     PopupMenuDeleteWidget(
//           //
//           //       callback: (value) {
//           //         deleteRoomFromSchedule();
//           //       },
//           //
//           //       icon: const Icon(
//           //         Icons.more_vert,
//           //         color: AppTheme.schriftfarbe,
//           //       ),
//           //     ),
//           //
//           //     Text(
//           //       groupManagement.groupName,
//           //       textAlign: TextAlign.start,
//           //
//           //       style: AppTheme.textStyleDefault,
//           //     ),
//           //
//           //
//           //   ],
//           // ),
//           //
//           // ),
//
//         ),child: Image.asset(
//           "assets/images/${ImageMapping().getImageNameToShow(imageName: groupManagement.groupImage)}"),
//       ),
//     );
//   }
//
//
// }
import 'package:flutter/material.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/models/database/model_group_management.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../core/image_mapping/image_name_mapping.dart';
import '../general_widgets/popup_menu/popup_menu_delete_widget.dart';

class ScheduleRoomTile extends StatelessWidget {
  final ModelGroupManagement groupManagement;
  final Function deleteRoomFromSchedule;
  const ScheduleRoomTile(
      {super.key,
      required this.groupManagement,
      required this.deleteRoomFromSchedule});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // blurSize: 1,
      // menuItemExtent: 60,
      // menuWidth: MediaQuery.of(context).size.width * 0.5,
      // onPressed: () {},
      // menuItems: [
      //   FocusedMenuItem(
      //       title: Text(
      //         local.delete,
      //         style: AppTheme.textStyleBackground,
      //       ),
      //       trailingIcon: const Icon(
      //         Icons.delete,
      //         color: AppTheme.hintergrund,
      //       ),
      //       onPressed: () {
      //         deleteRoomFromSchedule();
      //       })
      // ],
      child: GridTile(
        footer: Container(
          padding: const EdgeInsets.only(
              bottom: Dimens.paddingDefault, left: 30, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // GridTileBar(
              Text(
                groupManagement.groupName,
                textAlign: TextAlign.start,
                style: AppTheme.textStyleWhite,
              ),

              //  ),
            ],
          ),
        ),
        header: Container(
          padding: const EdgeInsets.only(top: 0, left: 30, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuDeleteWidget(
                callback: (value) {
                  deleteRoomFromSchedule();
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: AppTheme.schriftfarbe,
                ),
              ),
            ],
          ),
        ),
        child: Image.asset(
            "assets/images/${ImageMapping().getImageNameToShow(imageName: groupManagement.groupImage)}"),
      ),
    );
  }
}
