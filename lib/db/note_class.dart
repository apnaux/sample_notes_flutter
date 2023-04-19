class Note {
  int id;
  String title;
  String note;
  String? imgLoc;

  Note({
    required this.id,
    required this.title,
    required this.note,
    this.imgLoc
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'imgLoc': imgLoc
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, note: $note, imgLoc: $imgLoc}';
  }
}