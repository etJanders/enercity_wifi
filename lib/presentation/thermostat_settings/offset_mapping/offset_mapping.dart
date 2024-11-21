class OffsetMapping {
  final Map<int, String> _offsetUIMapping = <int, String>{};
  final Map<String, String> _offsetHashOffsetMapping = <String, String>{};
  final Map<String, String> _offsetReverseHashOffsetMapping =
      <String, String>{};
  final Map<String, int> _offsetReverseHashUIMapping = <String, int>{};

  OffsetMapping() {
    _initUI();
    _initHashOffset();
    _initReverserHashOffset();
    _initReverseUIMapping();
  }

  ///Anzeige der Temperatur, wenn Zeiger bewegt wird
  void _initUI() {
    _offsetUIMapping[0] = '-3.0';
    _offsetUIMapping[1] = '-2.5';
    _offsetUIMapping[2] = '-2.0';
    _offsetUIMapping[3] = '-1.5';
    _offsetUIMapping[4] = '-1.0';
    _offsetUIMapping[5] = '-0.5';
    _offsetUIMapping[6] = '0.0';
    _offsetUIMapping[7] = '0.5';
    _offsetUIMapping[8] = '1.0';
    _offsetUIMapping[9] = '1.5';
    _offsetUIMapping[10] = '2.0';
    _offsetUIMapping[11] = '2.5';
    _offsetUIMapping[12] = '3.0';
  }

  void _initHashOffset() {
    _offsetHashOffsetMapping['-3.0°C'] = "FA";
    _offsetHashOffsetMapping['-2.5°C'] = "FB";
    _offsetHashOffsetMapping['-2.0°C'] = "FC";
    _offsetHashOffsetMapping['-1.5°C'] = "FD";
    _offsetHashOffsetMapping['-1.0°C'] = "FE";
    _offsetHashOffsetMapping['-0.5°C'] = "FF";
    _offsetHashOffsetMapping['0.0°C'] = "00";
    _offsetHashOffsetMapping['0.5°C'] = "01";
    _offsetHashOffsetMapping['1.0°C'] = "02";
    _offsetHashOffsetMapping['1.5°C'] = "03";
    _offsetHashOffsetMapping['2.0°C'] = "04";
    _offsetHashOffsetMapping['2.5°C'] = "05";
    _offsetHashOffsetMapping['3.0°C'] = "06";
  }

  void _initReverserHashOffset() {
    _offsetReverseHashOffsetMapping['FA'] = '-3.0°C';
    _offsetReverseHashOffsetMapping['FB'] = '-2.5°C';
    _offsetReverseHashOffsetMapping['FC'] = '-2.0°C';
    _offsetReverseHashOffsetMapping['FD'] = '-1.5°C';
    _offsetReverseHashOffsetMapping['FE'] = '-1.0°C';
    _offsetReverseHashOffsetMapping['FF'] = '-0.5°C';
    _offsetReverseHashOffsetMapping['00'] = '0.0°C';
    _offsetReverseHashOffsetMapping['01'] = '0.5°C';
    _offsetReverseHashOffsetMapping['02'] = '1.0°C';
    _offsetReverseHashOffsetMapping['03'] = '1.5°C';
    _offsetReverseHashOffsetMapping['04'] = '2.0°C';
    _offsetReverseHashOffsetMapping['05'] = '2.5°C';
    _offsetReverseHashOffsetMapping['06'] = '3.0°C';
  }

  void _initReverseUIMapping() {
    _offsetReverseHashUIMapping['FA'] = 0;
    _offsetReverseHashUIMapping['FB'] = 1;
    _offsetReverseHashUIMapping['FC'] = 2;
    _offsetReverseHashUIMapping['FD'] = 3;
    _offsetReverseHashUIMapping['FE'] = 4;
    _offsetReverseHashUIMapping['FF'] = 5;
    _offsetReverseHashUIMapping['00'] = 6;
    _offsetReverseHashUIMapping['01'] = 7;
    _offsetReverseHashUIMapping['02'] = 8;
    _offsetReverseHashUIMapping['03'] = 9;
    _offsetReverseHashUIMapping['04'] = 10;
    _offsetReverseHashUIMapping['05'] = 11;
    _offsetReverseHashUIMapping['06'] = 12;
  }

  //Temperatur daten die gesnedte werden, wenn eine Temperatur eingestellt wurde

  String getOffsetValue({required int progress}) {
    String data = "0.0";
    if (_offsetUIMapping.containsKey(progress)) {
      data = _offsetUIMapping[progress]!;
    }
    return data;
  }

  String getOffsetHashValue(String value) {
    String data = "00";
    if (_offsetHashOffsetMapping.containsKey(value)) {
      data = _offsetHashOffsetMapping[value]!;
    }
    return data;
  }

  String getOffsetReverseHashValue(String value) {
    String data = "0.0";
    if (_offsetReverseHashOffsetMapping.containsKey(value)) {
      data = _offsetReverseHashOffsetMapping[value]!;
    }
    return data;
  }

  int getOffsetReverseUIValue(String value) {
    int data = 0;
    if (_offsetReverseHashUIMapping.containsKey(value)) {
      data = _offsetReverseHashUIMapping[value]!;
    }
    return data;
  }
}
