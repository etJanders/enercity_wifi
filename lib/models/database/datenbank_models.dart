///Description
///Alle Datenbankeintraege enthalten eine individuelle Public Id. Daher
///erbt jedes Datenbank Model diese Klasse.
///
///Author: Julian Anders
///created: 25-10-2022
///changed: 25-10-2022
///
///Historie:
///
///Bemerkungen:
///
///
abstract class DatabaseModel {
  final String entryPublicId;
  DatabaseModel({required this.entryPublicId});
  Map<String, dynamic> toJson();
}
