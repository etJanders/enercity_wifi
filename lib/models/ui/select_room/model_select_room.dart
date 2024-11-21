///Description
///UI Model to manage selected Rooms
class ModelSelectRoom {
  final String _roomName;
  final String _activeRoomImage;
  final String _inactiveRoomImage;
  bool _roomSelected;
  final bool _addRoom;

  ModelSelectRoom(this._roomName, this._activeRoomImage,
      this._inactiveRoomImage, this._roomSelected, this._addRoom);

  void changeRoomSelectedMode(bool value) {
    _roomSelected = value;
  }

  String get getRoomName => _roomName;
  String get getImageName =>
      _roomSelected ? _activeRoomImage : _inactiveRoomImage;
  bool get roomSelected => _roomSelected;
  bool get getAddRoom => _addRoom;
}
