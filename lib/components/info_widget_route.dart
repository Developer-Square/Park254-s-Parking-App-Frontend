import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:meta/meta.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../config/globals.dart' as globals;

class _InfoWidgetRouteLayout<T> extends SingleChildLayoutDelegate {
  final Rect mapsWidgetSize;
  final double width;
  final double height;
  final bool searched;
  final double rating;
  final String price;

  _InfoWidgetRouteLayout(
      {@required this.mapsWidgetSize,
      @required this.height,
      @required this.width,
      this.searched,
      this.rating,
      this.price});

  /// Depending of the size of the marker or the widget, the offset in y direction has to be adjusted;
  /// If the appear to be of different size, the commented code can be uncommented and
  /// adjusted to get the right position of the Widget.
  /// Or better: Adjust the marker size based on the device pixel ratio!!!!)

  @override
  Offset getPositionForChild(Size size, Size childSize) {
//    if (Platform.isIOS) {
    return Offset(
      mapsWidgetSize.center.dx - childSize.width / 2,
      // ToDo: Check if this runs perfectly in IOS.
      mapsWidgetSize.center.dy - childSize.height + 75.0,
    );
//    } else {
//      return Offset(
//        mapsWidgetSize.center.dx - childSize.width / 2,
//        mapsWidgetSize.center.dy - childSize.height - 10,
//      );
//    }
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    //we expand the layout to our predefined sizes
    return BoxConstraints.expand(width: width, height: height);
  }

  @override
  bool shouldRelayout(_InfoWidgetRouteLayout oldDelegate) {
    return mapsWidgetSize != oldDelegate.mapsWidgetSize;
  }
}

class InfoWidgetRoute extends PopupRoute {
  final child;
  final double width;
  final double height;
  final bool searched;
  final double rating;
  final String price;
  final BuildContext buildContext;
  final TextStyle textStyle;
  final Rect mapsWidgetSize;

  InfoWidgetRoute({
    @required this.child,
    @required this.buildContext,
    @required this.textStyle,
    @required this.mapsWidgetSize,
    this.searched,
    this.rating,
    this.price,
    this.width = 150,
    this.height = 46,
    this.barrierLabel,
  });

  @override
  Duration get transitionDuration => Duration(milliseconds: 100);

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      removeTop: true,
      child: Builder(builder: (BuildContext context) {
        return CustomSingleChildLayout(
          delegate: _InfoWidgetRouteLayout(
              mapsWidgetSize: mapsWidgetSize,
              width: width,
              height: height,
              searched: searched,
              rating: rating,
              price: price),
          child: InfoWidgetPopUp(
            searched: searched,
            rating: rating,
            price: price,
            infoWidgetRoute: this,
          ),
        );
      }),
    );
  }
}

class InfoWidgetPopUp extends StatefulWidget {
  final bool searched;
  final double rating;
  final String price;
  const InfoWidgetPopUp(
      {Key key,
      @required this.infoWidgetRoute,
      this.searched,
      this.rating,
      this.price})
      : assert(infoWidgetRoute != null),
        super(key: key);

  final InfoWidgetRoute infoWidgetRoute;

  @override
  _InfoWidgetPopUpState createState() => _InfoWidgetPopUpState();
}

class _InfoWidgetPopUpState extends State<InfoWidgetPopUp> {
  CurvedAnimation _fadeOpacity;

  @override
  void initState() {
    super.initState();
    _fadeOpacity = CurvedAnimation(
      parent: widget.infoWidgetRoute.animation,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeOpacity,
      child: Material(
        type: MaterialType.transparency,
        textStyle: widget.infoWidgetRoute.textStyle,
        child: ClipPath(
          clipper: _InfoWidgetClipper(),
          child: Container(
            width: 100.0,
            height: 50.0,
            child: Column(
              children: [
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color:
                          widget.searched ? globals.textColor : Colors.white),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: CircularPercentIndicator(
                            radius: 30.0,
                            lineWidth: 2.0,
                            percent: (widget.rating / 5),
                            center: Container(
                                width: 26.0,
                                height: 26.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: Colors.white),
                                child: Center(
                                    child: widget.infoWidgetRoute.child)),
                            progressColor: widget.rating > 3.5
                                ? globals.backgroundColor
                                : widget.rating == 0.0
                                    ? Colors.grey[400]
                                    : Colors.red,
                          )),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(widget.price,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: widget.searched
                                  ? Colors.white
                                  : globals.textColor)),
                    ],
                  )),
                ),
                Triangle.isosceles(
                  edge: Edge.BOTTOM,
                  child: Container(
                      color: widget.searched ? globals.textColor : Colors.white,
                      height: 6.0,
                      width: 10.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoWidgetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height - 20);
    path.quadraticBezierTo(0.0, size.height - 10, 10.0, size.height);
    path.lineTo(size.width / 2 - 10, size.height);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 + 10, size.height);
    path.lineTo(size.width - 10, size.height);
    path.quadraticBezierTo(
        size.width, size.height - 10, size.width, size.height - 20);
    path.lineTo(size.width, 10.0);
    path.quadraticBezierTo(size.width, 0.0, size.width - 10.0, 0.0);
    path.lineTo(10, 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0, 10);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
