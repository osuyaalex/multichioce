import 'package:flutter/material.dart';

snackBar(String title, context){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}