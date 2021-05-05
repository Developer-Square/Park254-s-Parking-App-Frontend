import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:park254_s_parking_app/functions/auth/refreshTokens.dart';

// Retry a request with a 401 status code.
@override
retryFuture(future, tokens, storeLoginDetails, clearStorage) async {
  var token = await tokens.read(key: 'refreshToken');
  refreshTokens(refreshToken: token).then((value) {
    // Clear all the previous tokens.
    clearStorage();
    // Store the new tokens
    storeLoginDetails(value);
    // Retry the actual request again.
    future();
  }).catchError((err) {
    // ToDo: Add a way to show the tooltip with the error message.
    print(err);
  });
}
