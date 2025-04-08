import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class MySqlite {
  Future<Database?> get db;
  initialDB();
  onCreatDb(Database _db, int version);
  // user db
  Future<int> onDeleteDbUser(int id);
  Future<List<Map>?> onReedDbUser();
  Future<int> onInsertUser(int id, String firstName, String lastName,
     String phone,);
  Future<int> onUpdateUser(
      int id, String firstName, String lastName, String phone);
  // card db
  Future<int> onDeleteDbCards(int id);
  Future<int> onInsertCards(String title, double subPrice, double totalPrice,
      int count, String varies, int item_id, int discount,String image);
  Future<List<Map>?> onReedDbCards();
  Future<int> onUpdateCards(double totalPrice, String varies, int id);
  Future<int> onDeleteDbAllCards();
}

class MySqliteImpl implements MySqlite {
  static Database? _db;
  
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB();
      return _db;
    } else {
      return _db;
    }
  }

  @override
  // initial my database
  Future<Database?> initialDB() async {
   
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, "card.db");

    Database? myDb = await openDatabase(path, version: 1, onCreate: onCreatDb);
    return myDb;
  }

  @override
  // creation of tables on my database

  onCreatDb(Database? _db, int version) async {
    Database? mydb = await _db;
    await mydb!.execute('''
CREATE TABLE "user" (
  "id" INTEGER PRIMARY KEY , "f_name" TEXT ,"l_name" TEXT ,"phone" TEXT)
''');
    await mydb.execute('''
CREATE TABLE "cards" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "title" TEXT ,"subPrice" REAL, "price" REAL, "count" INTEGER , "discount" INTEGER ,"varies" TEXT , "item_id" INTEGER, "image" TEXT  )
''');
    print("TABLES CREATED SUCCESS");
  }

  // user local data base

  @override
  Future<int> onDeleteDbUser(int id) async {
    Database? mydb = await db;
    var response = await mydb!.rawDelete("DELETE FROM user WHERE id = '${id}'");
    if (response == 0) {
      print("fail myDB");
    } else if (response > 0) {
      print("success myDB");
    }
    return response;
  }

  @override
  Future<List<Map>?> onReedDbUser() async {
    Database? mydb = await db;

    List<Map> response = await mydb!.rawQuery("SELECT * FROM 'user'");
    return response;
  }

 /*  @override
  Future<int> onInsertUser(int id, String firstName, String lastName,
    String phone) async {
    Database? mydb = await db;



       int response =   await mydb!.rawInsert('INSERT OR REPLACE INTO user (id, f_name, l_name, phone) VALUES (?, ?, ?, ?)', [id, firstName, lastName, phone]);

    if (response == 0) {
      print("fail myDB");
    } else if (response > 0) {
      print("success myDB");
    }
    return response;
  }
 */
@override
Future<int> onInsertUser(int id, String firstName, String lastName, String phone) async {
  Database? mydb = await db;
  List<Map<String, dynamic>> schema = await mydb!.rawQuery('PRAGMA table_info(user);');

  // Print the schema information for debugging
  for (var column in schema) {
    print('Column: ${column['name']}, Type: ${column['type']}, Primary Key: ${column['pk']}');
  }
  if (mydb == null) {
    print("Database not initialized!");
    return 0;
  }

  try {
    int response = await mydb.rawInsert(
      'INSERT OR REPLACE INTO user (id, f_name, l_name, phone) VALUES (?, ?, ?, ?)',
      [id, firstName, lastName, phone]
    );

    if (response > 0) {
      print("Success in inserting user into DB!");
    } else {
      print("Failed to insert into DB!");
    }
    return response;
  } catch (e) {
    print("DB Error: $e");
    return 0;
  }
}
  @override
  Future<int> onUpdateUser(int id, String firstName, String lastName,
       String phone) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(
        "UPDATE user SET 'f_name' = '$firstName' , 'l_name' = '$lastName' , 'phone' = '$phone' WHERE 'id' = '$id'");
    if (response == 0) {
      print("fail myDB");
    } else if (response > 0) {
      print("success myDB");
    }
    return response;
  }
  // cards local data base

  @override
  Future<int> onDeleteDbCards(int id) async {
    Database? mydb = await db;

    var response =
        await mydb!.rawDelete("DELETE FROM cards WHERE id = '${id}'");
    if (response == 0) {
      print("fail myDB");
    } else if (response > 0) {
      print("success myDB");
    }
    return response;
  }

  @override
  Future<int> onDeleteDbAllCards() async {
    Database? mydb = await db;

    var response = await mydb!.rawDelete("DELETE FROM cards");
    if (response == 0) {
      print("fail myDB");
    } else if (response > 0) {
      print("success myDB");
    }
    return response;
  }

  @override
  Future<int> onInsertCards(String title, double subPrice, double totalPrice,
      int count, String varies, int item_id, int discount,String image) async {
    Database? mydb = await db;
    var response = await mydb!.rawInsert(
        "INSERT INTO 'cards' ( 'title' , 'subPrice' ,'price' , 'count' , 'varies' , 'item_id' , 'discount','image') VALUES ('$title', '$subPrice' , '$totalPrice' , '$count' , '$varies' , '$item_id' , '$discount','$image')");
    if (response == 0) {
      print("fail myDB");
    } else if (response > 0) {
      print("success myDB");
    }
    return response;
  }

  @override
  Future<List<Map>?> onReedDbCards() async {
    Database? mydb = await db;

    List<Map>? response = await mydb?.rawQuery("SELECT * FROM 'cards'");

    return response;
  }

  @override
  Future<int> onUpdateCards(double totalPrice, String varies, int id) async {
    Database? mydb = await db;
    var response = await mydb!.rawUpdate(
        "UPDATE cards SET 'price' = '$totalPrice' , 'varies' = '$varies' WHERE id = '$id' ");
    if (response == 0) {
      print("fail myDB");
    } else if (response > 0) {
      print("success myDB");
    }
    return response;
  }
}
