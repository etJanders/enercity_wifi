class TemperatureMapping {
  final Map<int, String> _temperatureUIMapping = <int, String>{};
  final Map<int, String> _temperatureValue = <int, String>{};
  final Map<String, double> _temperaturSliderProgres = <String, double>{};

  TemperatureMapping() {
    _initUI();
    _initTemperatureValue();
  }

  ///Anzeige der Temperatur, wenn Zeiger bewegt wird
  void _initUI() {
    _temperatureUIMapping[0] = 'off';
    _temperatureUIMapping[1] = '8.0 °C';
    _temperatureUIMapping[2] = '8.5 °C';
    _temperatureUIMapping[3] = '9.0 °C';
    _temperatureUIMapping[4] = '9.5 °C';
    _temperatureUIMapping[5] = '10.0 °C';
    _temperatureUIMapping[6] = '10.5 °C';
    _temperatureUIMapping[7] = '11.0 °C';
    _temperatureUIMapping[8] = '11.5 °C';
    _temperatureUIMapping[9] = '12.0 °C';
    _temperatureUIMapping[10] = '12.5 °C';
    _temperatureUIMapping[11] = '13.0 °C';
    _temperatureUIMapping[12] = '13.5 °C';
    _temperatureUIMapping[13] = '14.0 °C';
    _temperatureUIMapping[14] = '14.5 °C';
    _temperatureUIMapping[15] = '15.0 °C';
    _temperatureUIMapping[16] = '15.5 °C';
    _temperatureUIMapping[17] = '16.0 °C';
    _temperatureUIMapping[18] = '16.5 °C';
    _temperatureUIMapping[19] = '17.0 °C';
    _temperatureUIMapping[20] = '17.5 °C';
    _temperatureUIMapping[21] = '18.0 °C';
    _temperatureUIMapping[22] = '18.5 °C';
    _temperatureUIMapping[23] = '19.0 °C';
    _temperatureUIMapping[24] = '19.5 °C';
    _temperatureUIMapping[25] = '20.0 °C';
    _temperatureUIMapping[26] = '20.5 °C';
    _temperatureUIMapping[27] = '21.0 °C';
    _temperatureUIMapping[28] = '21.5 °C';
    _temperatureUIMapping[29] = '22.0 °C';
    _temperatureUIMapping[30] = '22.5 °C';
    _temperatureUIMapping[31] = '23.0 °C';
    _temperatureUIMapping[32] = '23.5 °C';
    _temperatureUIMapping[33] = '24.0 °C';
    _temperatureUIMapping[34] = '24.5 °C';
    _temperatureUIMapping[35] = '25.0 °C';
    _temperatureUIMapping[36] = '25.5 °C';
    _temperatureUIMapping[37] = '26.0 °C';
    _temperatureUIMapping[38] = '26.5 °C';
    _temperatureUIMapping[39] = '27.0 °C';
    _temperatureUIMapping[40] = '27.5 °C';
    _temperatureUIMapping[41] = '28.0 °C';
    _temperatureUIMapping[42] = 'on';
  }

  //Temperatur daten die gesnedte werden, wenn eine Temperatur eingestellt wurde
  void _initTemperatureValue() {
    //7.5 °C
    _temperatureValue[0] = '0F';
    _temperaturSliderProgres['0F'] = 0;
    //8.0 °C
    _temperatureValue[1] = '10';
    _temperaturSliderProgres['10'] = 1;
    //8.5
    _temperatureValue[2] = '11';
    _temperaturSliderProgres['11'] = 2;
    //9.0
    _temperatureValue[3] = '12';
    _temperaturSliderProgres['12'] = 3;
    //9.5
    _temperatureValue[4] = '13';
    _temperaturSliderProgres['13'] = 4;
    //10.0
    _temperatureValue[5] = '14';
    _temperaturSliderProgres['14'] = 5;
    //10.5
    _temperatureValue[6] = '15';
    _temperaturSliderProgres['15'] = 6;
    //11.0
    _temperatureValue[7] = '16';
    _temperaturSliderProgres['16'] = 7;
    //11.5
    _temperatureValue[8] = '17';
    _temperaturSliderProgres['17'] = 8;
    //12.0
    _temperatureValue[9] = '18';
    _temperaturSliderProgres['18'] = 9;
    //12.5
    _temperatureValue[10] = '19';
    _temperaturSliderProgres['19'] = 10;
    //13.0
    _temperatureValue[11] = '1A';
    _temperaturSliderProgres['1A'] = 11;
    //13.5
    _temperatureValue[12] = '1B';
    _temperaturSliderProgres['1B'] = 12;
    //14.0
    _temperatureValue[13] = '1C';
    _temperaturSliderProgres['1C'] = 13;
    //14.5
    _temperatureValue[14] = '1D';
    _temperaturSliderProgres['1D'] = 14;
    //15.0
    _temperatureValue[15] = '1E';
    _temperaturSliderProgres['1E'] = 15;
    //15.5
    _temperatureValue[16] = '1F';
    _temperaturSliderProgres['1F'] = 16;
    //16.0
    _temperatureValue[17] = '20';
    _temperaturSliderProgres['20'] = 17;
    //16.5
    _temperatureValue[18] = '21';
    _temperaturSliderProgres['21'] = 18;
    //17.0
    _temperatureValue[19] = '22';
    _temperaturSliderProgres['22'] = 19;
    //17.5
    _temperatureValue[20] = '23';
    _temperaturSliderProgres['23'] = 20;
    //18.0
    _temperatureValue[21] = '24';
    _temperaturSliderProgres['24'] = 21;
    //18.5
    _temperatureValue[22] = '25';
    _temperaturSliderProgres['25'] = 22;
    //19.0
    _temperatureValue[23] = '26';
    _temperaturSliderProgres['26'] = 23;
    //19.5
    _temperatureValue[24] = '27';
    _temperaturSliderProgres['27'] = 24;
    //20.0
    _temperatureValue[25] = '28';
    _temperaturSliderProgres['28'] = 25;
    //20.5
    _temperatureValue[26] = '29';
    _temperaturSliderProgres['29'] = 26;
    //21.0
    _temperatureValue[27] = '2A';
    _temperaturSliderProgres['2A'] = 27;
    //21.5
    _temperatureValue[28] = '2B';
    _temperaturSliderProgres['2B'] = 28;
    //22.0
    _temperatureValue[29] = '2C';
    _temperaturSliderProgres['2C'] = 29;
    //22.5
    _temperatureValue[30] = '2D';
    _temperaturSliderProgres['2D'] = 30;
    //23.0
    _temperatureValue[31] = '2E';
    _temperaturSliderProgres['2E'] = 31;
    //23.5
    _temperatureValue[32] = '2F';
    _temperaturSliderProgres['2F'] = 32;
    //24.0
    _temperatureValue[33] = '30';
    _temperaturSliderProgres['30'] = 33;
    //24.5
    _temperatureValue[34] = '31';
    _temperaturSliderProgres['31'] = 34;
    //25.0
    _temperatureValue[35] = '32';
    _temperaturSliderProgres['32'] = 35;
    //25.5
    _temperatureValue[36] = '33';
    _temperaturSliderProgres['33'] = 36;
    //26.0
    _temperatureValue[37] = '34';
    _temperaturSliderProgres['34'] = 37;
    //26.5
    _temperatureValue[38] = '35';
    _temperaturSliderProgres['35'] = 38;
    //27.0
    _temperatureValue[39] = '36';
    _temperaturSliderProgres['36'] = 39;
    //27.5
    _temperatureValue[40] = '37';
    _temperaturSliderProgres['37'] = 40;
    //28.0
    _temperatureValue[41] = '38';
    _temperaturSliderProgres['38'] = 41;
    //28.5
    _temperatureValue[42] = '39';
    _temperaturSliderProgres['39'] = 42;
  }

  String getTempToSend({required int value}) {
    String data = '';
    if (_temperatureValue.containsKey(value)) {
      data = _temperatureValue[value]!;
    }
    return data;
  }

  String getTemperatureValue({required int progress}) {
    String data = "16.0 °C";
    if (_temperatureUIMapping.containsKey(progress)) {
      data = _temperatureUIMapping[progress]!;
    }
    return data;
  }

  double getPoinerValue({required String value}) {
    double pointerValue = 17;
    if (_temperaturSliderProgres.containsKey(value)) {
      pointerValue = _temperaturSliderProgres[value]!;
    }
    return pointerValue;
  }
}
