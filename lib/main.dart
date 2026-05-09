import 'package:flutter/material.dart';
import 'app.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Database Service
  await DatabaseService().database;
  
  runApp(const CosmoNetApp());
}
