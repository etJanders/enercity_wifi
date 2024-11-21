import 'dart:async';

///Description:
///Devine an individual timer. After timer is finished a callback will be triggert
///
///Autor: Julian Anders
///erstellt am: 18-08-2022
///bearbeite am: 18-08-2022
///
///History:
///
///Notes:
class IndividualTimer {
  //timer controll true means timer in progress, false means timer not working
  bool _timerStarted = false;
  //Timer Instanz
  late Timer timer;

  ///Start a Timer, for x seconds läft
  void starteSekundenTimer(int duration, Function timerCallback) {
    if (!_timerStarted) {
      _timerStarted = true;
      timer = Timer(Duration(seconds: duration), () {
        _timerStarted = false;
        timerCallback(duration);
      });
    }
  }

  ///Start a Timer, for x Milliseconds
  void starteMsTimer(int duration, Function timerCallback) {
    if (!_timerStarted) {
      _timerStarted = true;
      timer = Timer(Duration(milliseconds: duration), () {
        _timerStarted = false;
        timerCallback(duration);
      });
    }
  }

  ///Start a timer for x minutes
  void starteMinutenTimer(int duration, Function timerCallback) {
    if (!_timerStarted) {
      _timerStarted = true;
      timer = Timer(Duration(minutes: duration), () {
        _timerStarted = false;
        timerCallback(duration);
      });
    }
  }

  ///stopp a timer if timer is in progress
  void stopTimer() {
    if (_timerStarted) {
      timer.cancel();
      _timerStarted = false;
    }
  }
}
