import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/functions/ratings/getRatings.dart';
import 'package:park254_s_parking_app/models/queryRatings.model.dart';
import 'package:park254_s_parking_app/models/rating.model.dart';

class RatingListModel with ChangeNotifier {
  QueryRatings _ratingList = new QueryRatings(
    ratings: null,
    page: null,
    limit: null,
    totalPages: null,
    totalResults: null,
  );
  bool loading = false;

  QueryRatings get ratings => _ratingList;

  void fetch({
    @required String token,
    String userId = '',
    String parkingLotId = '',
    String sortBy = '',
    int limit = 10,
    int page = 1,
  }) async {
    loading = true;
    _ratingList = await getRatings(
      token: token,
      userId: userId,
      parkingLotId: parkingLotId,
      sortBy: sortBy,
      limit: limit,
      page: page,
    );
    loading = false;
    notifyListeners();
  }

  void add({@required Rating rating}) {
    _ratingList.ratings.add(rating);
    notifyListeners();
  }

  void remove({@required Rating rating}) {
    _ratingList.ratings.removeWhere((r) => r.id == rating.id);
    notifyListeners();
  }

  void clear() {
    _ratingList.ratings.clear();
    notifyListeners();
  }

  Rating findById({@required String id}) {
    return _ratingList.ratings.firstWhere((r) => r.id == id);
  }

  set updateRating(Rating rating) {
    num index = _ratingList.ratings.indexWhere((r) => r.id == rating.id);
    _ratingList.ratings[index] = rating;
    notifyListeners();
  }
}
