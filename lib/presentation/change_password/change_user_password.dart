import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_smart_living/bloc/password_reset/password_reset_bloc.dart';
import 'package:wifi_smart_living/presentation/change_password/change_user_password_content.dart';

class ChangeUserPasswordPage extends StatelessWidget {
  static const routName = '/change_user_password';

  const ChangeUserPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordResetBloc(),
      child: ChangeUserPasswordContent(),
    );
  }
}
