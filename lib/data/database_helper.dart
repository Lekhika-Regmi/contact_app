import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'contact_model.dart';

class DatabaseHelper {
  static const _databaseName = "Contacts.db";
  static const _databaseVersion = 1;
  static const table = 'contacts';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnPhone = 'phone';
  static const columnEmail = 'email';
  static const columnIsFavorite = 'isFavorite';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
        CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnPhone TEXT NOT NULL,
            $columnEmail TEXT NOT NULL,
               $columnIsFavorite INTEGER NOT NULL DEFAULT 0
          )
      ''');
  }

  Future<int> insert(Contact contact) async {
    Database db = await instance.database;
    return await db.insert(table, contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      orderBy: "$columnName ASC",
    );

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return Contact.fromMap(maps[i]);
    });
  }

  Future<int> update(Contact contact) async {
    Database db = await instance.database;
    int id = contact.id!;
    return await db.update(
      table,
      contact.toMap(),
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // Get only favorite contacts
  Future<List<Contact>> getFavorites() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: "$columnName ASC",
    );

    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  // Toggle favorite status
  Future<void> toggleFavorite(Contact contact) async {
    Database db = await instance.database;
    await db.update(
      table,
      {'isFavorite': contact.isFavorite ? 0 : 1},
      where: '$columnId = ?',
      whereArgs: [contact.id],
    );
  }

  Future<void> updateContact(Contact contact) async {
    final db = await instance.database;
    await db.update(
      table,
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }
}
