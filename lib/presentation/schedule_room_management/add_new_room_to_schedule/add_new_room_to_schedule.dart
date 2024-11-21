// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wifi_smart_living/bloc/add_room_to_schedule/add_room_to_schedule_bloc.dart';
// import 'package:wifi_smart_living/models/database/model_schedule_manager.dart';
// import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
// import 'package:wifi_smart_living/presentation/schedule_room_management/add_new_room_to_schedule/add_new_room_to_schedule_content.dart';
// import 'package:wifi_smart_living/theme.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class AddRoomToSchedulePage extends StatelessWidget {
//   static const routName = "/add_room_to_schedule_page";
//   const AddRoomToSchedulePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     AppLocalizations local = AppLocalizations.of(context)!;
//     ModelScheduleManager manager =
//         ModalRoute.of(context)!.settings.arguments as ModelScheduleManager;
//     return BlocProvider(
//       create: (context) => AddRoomToScheduleBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           leading: const BackButtonWidget(),
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(local.addRoomToSchedule),
//               Text(
//                 local.avaialableRooms,
//                 style: AppTheme.textStyleColored,
//               ),
//             ],
//           ),
//         ),
//         body:
//         AddRoomToScheduleContent(
//           smPublicId: manager.entryPublicId,
//         ),
//       ),
//     );
//   }
// }

