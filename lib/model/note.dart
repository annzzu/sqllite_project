const String tableNotes = 'notes';

class NoteFields {
  static const String id = '_id';
  static const String isImportant = '_isImportant';
  static const String number = '_number';
  static const String title = '_title';
  static const String description = '_description';
  static const String time = '_time';

  static const List<String> values = [
    id,
    isImportant,
    number,
    title,
    description,
    time
  ];
}

class Note {
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createTime;
  final int? id;

  const Note({
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createTime,
    this.id,
  });

  Map<String, Object?> toJsonDB() => {
        NoteFields.id: id,
        NoteFields.isImportant: isImportant ? 1 : 0,
        NoteFields.number: number,
        NoteFields.title: title,
        NoteFields.description: description,
        NoteFields.time: createTime.toIso8601String(),
      };

  Map<String, Object?> toJson() => {
        'id': id,
        'isImportant': isImportant,
        'number': number,
        'title': title,
        'description': description,
        'createTime': createTime,
      };

  factory Note.fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        isImportant: json[NoteFields.isImportant] == 1,
        number: json[NoteFields.number] as int,
        title: json[NoteFields.title] as String,
        description: json[NoteFields.description] as String,
        createTime: DateTime.parse(json[NoteFields.time] as String),
      );

  static List<Note> listFromModels(data) =>
      data.map<Note>(Note.fromJson).toList();

  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createTime,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createTime: createTime ?? this.createTime,
      );
}
