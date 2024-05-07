abstract class Data {
  int? id;
  String contents;

  Data({this.id, required this.contents});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contents': contents,
    };
  }
}

class KeyResults extends Data {
  int? weight;
  int? progress;

  KeyResults({int? id, required String contents, this.weight, this.progress})
      : super(id: id, contents: contents);

  factory KeyResults.fromMap(Map<String, dynamic> map) {
    return KeyResults(
      id: map['id'],
      contents: map['contents'],
      weight: map['weight'],
      progress: map['progress'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['weight'] = weight;
    map['progress'] = progress;
    return map;
  }
}

class Sub_goal extends Data {
  int? weight;
  int? progress;

  Sub_goal({int? id, required String contents, this.weight, this.progress})
      : super(id: id, contents: contents);

  factory Sub_goal.fromMap(Map<String, dynamic> map) {
    return Sub_goal(
      id: map['id'],
      contents: map['contents'],
      weight: map['weight'],
      progress: map['progress'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['weight'] = weight;
    map['progress'] = progress;
    return map;
  }
}

class Actionx extends Data {
  int? progress;
  int? weight;

  Actionx({int? id, required String contents, this.progress, this.weight})
      : super(id: id, contents: contents);

  factory Actionx.fromMap(Map<String, dynamic> map) {
    return Actionx(
      id: map['id'],
      contents: map['contents'],
      progress: map['progress'],
      weight: map['weight'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['progress'] = progress;
    map['weight'] = weight;
    return map;
  }
}
