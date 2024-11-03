class Note {
  int id;
  String title;
  String? description;
  bool check;

  Note(
      {required this.id,
      required this.title,
      required this.description,
      required this.check});

  factory Note.copyWith({
    int? id,
    String? title,
    String? description,
    bool? check,
  }) =>
      Note(
        id: id ?? DateTime.now().millisecondsSinceEpoch,
        title: title ?? '',
        description: description ?? '',
        check: check ?? false,
      );

  factory Note.empty() => Note(
        id: DateTime.now().millisecondsSinceEpoch,
        title: '',
        description: '',
        check: false,
      );
}
