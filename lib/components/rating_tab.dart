import 'package:flutter/material.dart';
import '../config/globals.dart' as globals;

/// Creates the rating tab.
///
/// Requires [hideRatingTabFn], [searchBarController.text].
/// E.g.
/// ```dart
/// NearByParkingList(
/// hideRatingTabFn: hideRatingTabFn,
/// parkingPlaceName: searchBarController.text)
///```
class RatingTab extends StatefulWidget {
  final hideRatingTabFn;
  final parkingPlaceName;

  RatingTab({@required this.hideRatingTabFn, @required this.parkingPlaceName});
  @override
  _RatingTabState createState() => _RatingTabState();
}

class _RatingTabState extends State<RatingTab> {
  int ratingCount;
  var clickedStars;

  @override
  void initState() {
    super.initState();

    // Pass initial values.
    ratingCount = 0;
    clickedStars = [];
  }

  // Changes the rating in the rating tab.
  // also helps to identify which stars were clicked.
  void setStar(title) {
    setState(() {
      if (title == 'star1') {
        addToClickedStars(title);
      } else if (title == 'star2') {
        addToClickedStars(title);
      } else if (title == 'star3') {
        addToClickedStars(title);
      } else if (title == 'star4') {
        addToClickedStars(title);
      } else {
        addToClickedStars(title);
      }
    });
  }

// Adds the title passed on as a param to a list.
// so that we can know which stars were clicked.
// If the title is already there it's removed.
  void addToClickedStars(title) {
    if (clickedStars.contains(title)) {
      clickedStars.remove(title);
    } else {
      clickedStars.add(title);
    }
    clickedStars.map((star) => star == true ? ratingCount += 1 : null);
  }

  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: MediaQuery.of(context).size.width - 40.0,
      height: 290.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
          color: Colors.white),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 30.0, bottom: 10.0, left: 30.0, right: 25.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'How would you rate ${widget.parkingPlaceName} parking?',
                    textAlign: TextAlign.center,
                    style:
                        globals.buildTextStyle(16.0, true, globals.textColor),
                  ),
                  SizedBox(height: 17.0),
                  Row(
                    children: <Widget>[
                      _buildStars('star1'),
                      _buildStars('star2'),
                      _buildStars('star3'),
                      _buildStars('star4'),
                      _buildStars('star5')
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    'Tap the number of stars you would give ${widget.parkingPlaceName} on a scale of 1-5!',
                    textAlign: TextAlign.center,
                    style: globals.buildTextStyle(
                        16.0, true, Colors.grey.withOpacity(0.8)),
                  ),
                  SizedBox(height: 10.0),
                ]),
          ),
          Container(height: 1.0, color: Colors.grey.withOpacity(0.4)),
          InkWell(
            onTap: () => widget.hideRatingTabFn(),
            child: Column(
              children: [
                SizedBox(height: 20.0),
                Text('NOT NOW',
                    style: globals.buildTextStyle(
                        18.0, true, Colors.grey.withOpacity(0.7)))
              ],
            ),
          ),
        ],
      ),
    ));
  }

  /// Builds out the star icons.
  ///
  /// The icons change when clicked.
  Widget _buildStars(title) {
    return InkWell(
      onTap: () => setStar(title),
      child: clickedStars.contains(title)
          ? Icon(
              Icons.star,
              color: Colors.yellow,
              size: 53.0,
            )
          : Icon(
              Icons.star_border,
              color: Colors.grey.withOpacity(0.7),
              size: 53.0,
            ),
    );
  }
}
