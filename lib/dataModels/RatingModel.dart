import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/functions/ratings/getRatingById.dart';
import 'package:park254_s_parking_app/models/rating.model.dart';

class RatingModel with ChangeNotifier {
  Rating _rating =
      new Rating(id: null, userId: null, parkingLotId: null, value: null);
  bool loading = false;

  Rating get rating => _rating;

  set rating(Rating value) {
    _rating = value;
    notifyListeners();
  }

  void fetch({
    @required String token,
    @required String ratingId,
  }) async {
    loading = true;
    _rating = await getRatingById(token: token, ratingId: ratingId);
    loading = false;
    notifyListeners();
  }

  void clear() {
    _rating =
        new Rating(id: null, userId: null, parkingLotId: null, value: null);
    notifyListeners();
  }
}
