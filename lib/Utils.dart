import 'dart:io';

import 'package:flutter/material.dart';

import 'BaseModel.dart';

Directory docsDir;

/*@selectDate
*Une date est requise pour une tache ou évènement donné
* , alors elle est soit la date ou l'heure actuelle ou choisien par l'utilisateur.*/

Future selectDate(
    BuildContext inContext, BaseModel inModel, String inDateString) async {
  DateTime intitialDate = DateTime.now(); //Date par @défaut: date actuelle

  if (inDateString != null) {
    List datePart = inDateString.split(",");
    intitialDate = DateTime(
        int.parse(datePart[0]), int.parse(datePart[1]), int.parse(datePart[2]));
  }
}
