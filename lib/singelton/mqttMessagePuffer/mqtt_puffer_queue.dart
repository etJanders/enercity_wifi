class MqttPufferItem {
  final String mac;
  final String value;
  late int timestamp;

  MqttPufferItem({required this.mac, required this.value}) {
    timestamp = DateTime.now().millisecondsSinceEpoch;
  }
}
