import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  final storage = const FlutterSecureStorage();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<String> _getUserName() async {
    final userData = await storage.read(key: 'userData');
    if (userData != null) {
      final Map<String, dynamic> parsedData = json.decode(userData);
      final username = parsedData['username'] ?? 'Unknown User';
      print('Username: $username'); // Print the username
      return username;
    }
    print('No User Data'); // Print a message if there's no user data
    return 'No User Data';
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final username = await _getUserName();
    print(username);
    final path = join(await getDatabasesPath(), '${username}_agriguide.db');

    // Check if the database already exists
    if (await databaseExists(path)) {
      print('Database already exists for user: $username');
      return await openDatabase(path);
    }
    print('Creating new database: $path');
    // await storage.write(key: '${username}_db', value: '${username}_agriguide.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY,
        title TEXT,
        body TEXT,
        timestamp TEXT,
        isSeen BOOLEAN DEFAULT 0
      )
    ''');
  }

  Future<void> insertNotification(Map<String, dynamic> notification) async {
    Database db = await database;
    await db.insert(
      'notifications',
      notification,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    Database db = await database;
    // Extract and print the database name
    // String dbPath = db.path;
    // String dbName = basename(dbPath);
    // print('Database Name: $dbName');

    return await db.query('notifications');
  }

  Future<void> deleteNotification(int id) async {
    final db = await database;
    await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllNotifications() async {
    final db = await database;
    await db.delete('notifications');
  }

  Future<void> dropDatabase() async {
    final username = await _getUserName();
    final path = join(await getDatabasesPath(), '${username}_agriguide.db');
    await deleteDatabase(path);
    _database = null; // Reset the database instance
  }

  void resetDatabase() {
    _database = null;
  }

  Future<void> reinitializeDatabase() async {
    await database;
  }

  // Function to add the isSeen column
  Future<void> addIsSeenColumn() async {
    final db = await database;
    await db.execute('''
      ALTER TABLE notifications ADD COLUMN isSeen BOOLEAN DEFAULT 0
    ''');
  }

  Future<void> markMultipleAsSeen(List<int> notificationIds) async {
    final db = await database;
    final batch = db.batch();

    for (int id in notificationIds) {
      batch.update(
        'notifications',
        {'isSeen': 1}, // Set isSeen to true (1)
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    await batch.commit(noResult: true);
  }
}
