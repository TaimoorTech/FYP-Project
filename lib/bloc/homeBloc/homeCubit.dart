
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_project/dataSources/localDatabase/sqflite.dart';
import 'package:fyp_project/modelClasses/userModel.dart';
part 'homeStates.dart';

class HomeCubit extends Cubit<HomeState> {

  HomeCubit() : super(HomeState(email: '', username: ''));

  void getDetails() async {
    List<User> list = await SQLHelper.getAllItems();
    String email = list[0].email;
    String username = list[0].username;
    emit(GetDetailsState(username: username, email: email));
  }

}