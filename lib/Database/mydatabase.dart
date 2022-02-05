import 'dart:async';

import 'package:blogapp/Entity/person.dart';
import 'package:blogapp/Entity/persondao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'mydatabase.g.dart';

@Database(version: 1, entities: [Person])
abstract class AppDatabase extends FloorDatabase {
  Persondao get personDao;
}