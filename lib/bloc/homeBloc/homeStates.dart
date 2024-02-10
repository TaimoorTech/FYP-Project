part of 'homeCubit.dart';


class HomeState{
  String email;

  HomeState({
    required this.email,
  });

}

class GetDetailsState extends HomeState{
  GetDetailsState({required super.email});
}