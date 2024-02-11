part of 'homeCubit.dart';


class HomeState{
  String username;
  String email;

  HomeState({
    required this.username,
    required this.email,
  });

}

class GetDetailsState extends HomeState{
  GetDetailsState({required super.username, required super.email});
}