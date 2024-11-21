///Description
///Heper model to map heating profile from old workflwo to new workflow
///
///Author: J. Anders
///created: 09-01-2023
///changed: 09-01-2023
///
///History:
///
///Notes:
///
class ModelInitHeatingProfile {
  final String groupId;
  final String scheduleName;
  final String scheduleImage;
  final String scheduleId;

  ModelInitHeatingProfile(
      {required this.groupId,
      required this.scheduleName,
      required this.scheduleImage,
      required this.scheduleId});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonFile = <String, dynamic>{};
    List<String> groupIds = [groupId];
    jsonFile['group_ids'] = groupIds;
    jsonFile['schedule_name'] = scheduleName;
    jsonFile['schedule_image'] = scheduleImage;
    jsonFile['schedule_id'] = scheduleId;
    return jsonFile;
  }
}
