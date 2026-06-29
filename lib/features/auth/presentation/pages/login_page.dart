import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_mobil/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:rental_mobil/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rental_mobil/features/auth/domain/usecases/login_usecase.dart';

import '../providers/login_provider.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => LoginProvider(
            loginUseCase: LoginUseCase(
              AuthRepositoryImpl(AuthRemoteDataSourceImpl()),
            ),
          ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: const Column(
                  children: [
                    LoginHeader(),

                    SizedBox(height: 40),

                    LoginForm(),

                    LoginFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
