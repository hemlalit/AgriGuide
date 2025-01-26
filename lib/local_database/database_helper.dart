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

    return await openDatabase(
      path,
      version: 3, // Increment the database version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Handle database schema changes
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
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        message TEXT,
        sender TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE messages (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          message TEXT,
          sender TEXT
        )
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
        ALTER TABLE messages ADD COLUMN timestamp TEXT
      ''');
    }

    // if (oldVersion == 1) {
    //   await addIsSeenColumn(db);
    // }
  }

  Future<void> addIsSeenColumn(Database db) async {
    await db.execute('''
      ALTER TABLE notifications ADD COLUMN isSeen BOOLEAN DEFAULT 0
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

  Future<void> insertMessage(String message, String sender) async {
    final db = await database;
    await db.insert(
      'messages',
      {
        'message': message,
        'sender': sender,
        'timestamp': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    final db = await database;
    return await db.query('messages', orderBy: 'timestamp ASC');
  }
}
