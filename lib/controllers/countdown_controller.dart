import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:async';

class CountdownController extends GetxController {
  final DateTime eventDate = DateTime(2023, 7, 30, 9, 0, 0);
  final DateTime eventInProgress = DateTime(2023, 7, 30, 19, 0, 0);
  Duration duration = const Duration();

  RxString timeDifference = "".obs;
  RxString timeDifferenceInProgress = "".obs;

  void updateCountdown() {
    duration = eventDate.difference(DateTime.now());
    if (duration.isNegative) {
      timeDifference.value = "Event has passed!";
    } else {
      int days = duration.inDays;
      int hours = duration.inHours % 24;
      int minutes = duration.inMinutes % 60;
      int seconds = duration.inSeconds % 60;
      timeDifference.value = "${fDays(days)} ${fHours(hours)}\n${fMinutes(minutes)}, ${fSeconds(seconds)}";
    }
  }

  void inProgress() {
    Duration duration = eventInProgress.difference(DateTime.now());
    if (duration.isNegative) {
      timeDifferenceInProgress.value = "Event has passed!";
    } else {
      timeDifferenceInProgress.value = "Event in Progress!";
    }
  }

  @override
  void onInit() {
    super.onInit();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      updateCountdown();
    });
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      inProgress();
    });
  }

  String fDays(int days){
    if(days == 1) {
      return "0$days Day,";
    } else if (days == 0) {
      return "";
    }
    else {
      return "0$days Days,";
    }
  }

  String fSeconds(int seconds){
    if(seconds.isLowerThan(10)) {
      if(seconds.bitLength == 1 || seconds.bitLength == 0){
        return "0$seconds Second";
      }
      return "0$seconds Seconds";
    } else {
      return "$seconds Seconds";
    }
  }

  String fHours(int hours){
    if(hours.isLowerThan(10)) {
      if(hours.bitLength == 1 || hours.bitLength == 0){
        return "0$hours Hour";
      }
      return "0$hours Hours";
    } else {
      return "$hours Hours";
    }
  }

  String fMinutes(int minutes){
    if(minutes.isLowerThan(10)) {
      if(minutes.bitLength == 1 || minutes.bitLength == 0){
        return "0$minutes Minute";
      }
      return "0$minutes Minutes";
    } else {
      return "$minutes Minutes";
    }
  }
}