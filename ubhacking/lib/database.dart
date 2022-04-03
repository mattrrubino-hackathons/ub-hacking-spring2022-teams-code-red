import 'package:firebase_database/firebase_database.dart';

class Database {
  static final Database _database = Database._internal();
  Database._internal();

  factory Database() {
    return _database;
  }

  Future<void> setHouseEnabled(String house, bool enabled) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(house);
    await ref.update({"enabled": enabled});
  }

  Future<void> setHouseTriggered(String house, bool triggered) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(house);
    await ref.update({"triggered": triggered});
  }

  void triggerSubscription(String house, Function f) {
    DatabaseReference triggered =
      FirebaseDatabase.instance.ref(house + '/triggered');

    triggered.onValue.listen((event) {
      final data = event.snapshot.value;
      f(data);
    });
  }
}
