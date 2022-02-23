final String ID = "id";
final String MODE = "mode";

class UserLogin {
  final int id, mode;

  UserLogin(this.id, this.mode);

  Map<String, dynamic> toMap() {
    return {
      ID: id,
      MODE: mode,
    };
  }

  Map<String, dynamic> toMapAutoIncrement() {
    return {
      ID: id,
      MODE: mode,
    };
  }

  @override
  String toString() {
    return '{id: $id, mode: $mode}';
  }
}
