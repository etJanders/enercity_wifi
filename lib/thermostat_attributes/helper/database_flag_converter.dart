class DatabaseFlagHelper {
  //Check if a bit of a byte vale is 0 or 1
  bool getBitState({required int byteValue, required int position}) {
    return ((byteValue >> position) & 1) == 1;
  }
}
