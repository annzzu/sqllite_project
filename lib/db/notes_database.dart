// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:sqllite_project/model/note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    final initDb = await openDatabase(path, version: 1, onCreate: _createDB);
    return initDb;
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableNotes ( 
      ${NoteFields.id} $idType, 
      ${NoteFields.isImportant} $boolType,
      ${NoteFields.number} $integerType,
      ${NoteFields.title} $textType,
      ${NoteFields.description} $textType,
      ${NoteFields.time} $textType
      )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJsonDB());
    return note.copy(id: id);
  }

  Future<Note> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableNotes,
        columns: NoteFields.values,
        where: '${NoteFields.id} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
      // return null;
    }
  }

  Future<List<Note>> readAll() async {
    final db = await instance.database;
    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      orderBy: '${NoteFields.time} ASC',
    );
    return Note.listFromModels(maps);
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    final update = await db.update(
      tableNotes,
      note.toJsonDB(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
    return update;
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    final delete = await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
    return delete;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
