import 'package:rental_mobil/features/auth/domain/entities/auth.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl
implements AuthRepository{

@override
Future<AuthEntity> login({

required String email,

required String password,

}){

throw UnimplementedError();

}

@override
Future<void> logout(){

throw UnimplementedError();

}

}