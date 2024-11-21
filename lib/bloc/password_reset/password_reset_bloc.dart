import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:wifi_smart_living/api_handler/api_treiber/activation_state/activation_state_helper.dart';
import 'package:wifi_smart_living/helper/password_reset_helper/helper_password_reset.dart';

import '../../api_handler/api_treiber/password_reset_helper.dart';

part 'password_reset_event.dart';
part 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  PasswordResetHelper passwordResetHelper = PasswordResetHelper();

  PasswordResetBloc() : super(PasswordResetInitial()) {
    on<CheckuserAccountActivationState>((event, emit) async {
      UserAccountActivationState responseState = await ActivationStateHelper()
          .determineActivationstate(userMailAdress: event.mailAdress);
      emit(UserAccountActivationResponse(responseState: responseState));
    });

    on<RequestResetToken>((event, emit) async {
      PasswordResetRespnseState state = await PasswordResetApiHelper()
          .determineResetToken(userMail: event.mailAdress);
      if (state == PasswordResetRespnseState.resetTokenSent) {
        passwordResetHelper.setUserMail(event.mailAdress);
      }
      emit(PasswordResetResponse(respnseState: state));
    });

    on<RefreshResetToken>((event, emit) async {
      ///determine new reset token
      ///=> emit: PasswordRefreshTokenRequested
      PasswordResetRespnseState state = await PasswordResetApiHelper()
          .determineResetToken(userMail: passwordResetHelper.getUserMail);
      emit(PasswordRefreshTokenRequested(respnseState: state));
    });

    on<ResetTokenEntered>((event, emit) async {
      passwordResetHelper.setresetToken(event.resetToken);
      ResetTokenGeneration generation = await PasswordResetApiHelper()
          .determienLoginToken(
              mail: passwordResetHelper.getUserMail,
              resetToken: event.resetToken);
      if (generation.state == PasswordResetRespnseState.idleState ||
          generation.state == PasswordResetRespnseState.tokenAccepted) {
        passwordResetHelper.setAccessToken(generation.accessToken);
        emit(ResetTokenValidated());
      } else {
        emit(PasswordResetResponse(respnseState: generation.state));
      }
    });

    on<ChangePassword>((event, emit) async {

      PasswordResetRespnseState state = await PasswordResetApiHelper()
          .changeUserPassword(password: event.newPassword, oldPassword: event.oldPassword);
      emit(PasswordResetResponse(respnseState: state));
    });

    on<ChangePasswordReset>((event, emit) async {
      PasswordResetRespnseState state = await PasswordResetApiHelper()
          .changeUserPasswordReset(
              token: passwordResetHelper.getAccessToken,
              password: event.newPassword);
      emit(PasswordResetResponse(respnseState: state));
    });
  }
}
