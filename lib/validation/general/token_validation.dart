///Description
///On some pages it is possible to enter a verification a activation token
///This class helps to validate the user tokens
///
///Author: J. Anders
///created: 30-11-2022
///changed: 30-11-2022
///
///History:
///
///Notes
///
class TokenValidation {
  ///Check if token has a length of 6 and contains of numbers
  bool validateToken({required String enteredToken}) {
    bool tokenValid = true;
    if (enteredToken.isEmpty || enteredToken.length < 6) {
      tokenValid = false;
    }
    return tokenValid;
  }
}
