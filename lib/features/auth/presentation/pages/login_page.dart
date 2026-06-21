import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_mobil/app/routes/routes.dart';
import 'package:rental_mobil/core/components/organism/app_scaffold.dart';


import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';
import '../widgets/remember_me.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {

    emailController.dispose();

    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<AuthState>(
      authProvider,
      (previous, next) {

        if (next.status == AuthStatus.authenticated) {

          context.go(AppRoutes.dashboard);

        }

        if (next.status == AuthStatus.error) {

          ScaffoldMessenger.of(context).showSnackBar(

            SnackBar(
              content: Text(
                next.errorMessage ?? "Login gagal",
              ),
            ),

          );

        }

      },
    );

    final state = ref.watch(authProvider);

    final notifier = ref.read(authProvider.notifier);

    return AppScaffold(

      body: Center(

        child: SingleChildScrollView(

          child: ConstrainedBox(

            constraints: const BoxConstraints(
              maxWidth: 420,
            ),

            child: Form(

              key: formKey,

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                children: [

                  const LoginHeader(),

                  const SizedBox(height: 48),

                  LoginForm(

                    emailController: emailController,

                    passwordController:
                        passwordController,

                    onLogin: () {

                      if (!formKey.currentState!
                          .validate()) {
                        return;
                      }

                      notifier.emailChanged(
                        emailController.text,
                      );

                      notifier.passwordChanged(
                        passwordController.text,
                      );

                      notifier.login();

                    },

                  ),

                  const SizedBox(height: 16),

                  RememberMe(

                    value: state.rememberMe,

                    onChanged: (_) {

                      notifier.toggleRemember();

                    },

                  ),

                  const SizedBox(height: 30),

                  if (state.status ==
                      AuthStatus.loading)

                    const Center(

                      child:
                          CircularProgressIndicator(),

                    ),

                ],

              ),

            ),

          ),

        ),

      ),

    );

  }

}