import 'package:shared_preferences/shared_preferences.dart';

/// Sets the SharedPreferences' hasRunBefore to the passed state.
/// Takes in a required state (bool, true or false) that will
/// be assigned to hasRunBefore.
void setHasRunBefore(bool state) async {
  await (await SharedPreferences.getInstance()).setBool('hasRunBefore', state);
}

/// Returns the value of hasRunBefore, bool.
/// If there isn't a hasRunBefore, it will return false as default.
Future<bool> getHasRunBefore() async {
  return (await SharedPreferences.getInstance()).getBool("hasRunBefore") ?? false;
}