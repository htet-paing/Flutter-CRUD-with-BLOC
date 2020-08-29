import 'package:crud_bloc/model/user_model.dart';
import 'package:crud_bloc/provider/user_dao.dart';

class UserRepository {
  final userDao = UserDao();

  Future getUsers({String query}) => userDao.getUsers(query: query);

  Future getUser(int id) => userDao.getUser(id: id);

  Future createUser(User user) => userDao.createUser(user);

  Future updateUser(User user) => userDao.updateUser(user);

  Future deleteUser(int id) => userDao.deleteUser(id);
}
