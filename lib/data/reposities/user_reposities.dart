import 'package:crud_bloc/data/model/auth_user.dart';
import 'package:crud_bloc/data/model/user_model.dart';
import 'package:crud_bloc/database/database.dart';
import 'package:crud_bloc/widget/authentication_exception.dart';

abstract class UserRepository {

  Future<List<User>> getUsers({String query});

  Future<User> getUser({int id});

  Future<int> createUser(User user);

  Future<int> updateUser(User user);

  Future<int> deleteUser(int id);

  Future<AuthUser> getAuthCurrentUser();

  Future<AuthUser> signInWithEmailAndPassword(String email, String password);
  
  Future<void> signOut();


}

class UserRepositoryImpl implements UserRepository {
  final dbProvider = DatabaseProvider.dbProvider;
  
  @override
  Future<int> createUser(User user) async{
    final db = await dbProvider.database;
      var result = await db.insert(userTable, user.toJson());
      return result;
    }
  
    @override
    Future<int> deleteUser(int id) async{
      final db = await dbProvider.database;
      var result = await db.delete(userTable, where: 'id = ?', whereArgs: [id]);
      return result;
    }
  
    @override
    Future<AuthUser> getAuthCurrentUser() async{
      return null;      
    }
  
    @override
    Future<User> getUser({List<String> columns ,int id}) async{
      final db = await dbProvider.database;

    var result = await db.query(userTable,columns: columns,  where: 'id = ?', whereArgs: [id]);

    List<User> users = result.isNotEmpty ? result.map((user) => User.fromJson(user)).toList() : [];
    User user = users.isNotEmpty ? users[0] : null;

    return user;
    }
  
    @override
    Future<List<User>> getUsers({List<String> columns,String query}) async{
      final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null && query != '') {
      if (query.isNotEmpty) {
        result = await db.query(userTable,
            columns: columns, where: 'name LIKE ?', whereArgs: ['%$query%']);
      }
    } else {
      result = await db.query(userTable, columns: columns);
    }

    List<User> users = result.isNotEmpty
        ? result.map((user) => User.fromJson(user)).toList()
        : [];
    return users;
    }
  
    @override
    Future<AuthUser> signInWithEmailAndPassword(String email, String password) async{
      await Future.delayed(Duration(seconds: 1));
      if (email.toLowerCase() != 'test@t.com' || password != 'test123') {
        throw AuthenticationException(message: 'Wrong usreName or Passwod');
      }
      return AuthUser(name: 'Test User', email: email);

    }
  
    @override
    Future<void> signOut() async{
      return null;
    }
  
    @override
    Future<int> updateUser(User user) async{
    final db = await dbProvider.database;
      var result = db.update(userTable, user.toJson(),
          where: 'id = ?', whereArgs: [user.id]);
      return result;
  }

}