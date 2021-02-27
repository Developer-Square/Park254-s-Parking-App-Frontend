import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/globals.dart' as globals;
import './MyText.dart';

///Creates a booking page
///
/// Requires [bookingNumber], [destination], [parkingLotNumber], [price], and [imagePath]
/// E.g
/// ```dart
/// Booking(
///   bookingNumber: 'haaga5441',
///   destination: 'Nairobi',
///   parkingLotNumber: 'pajh5114',
///   price: 10,
///   imagePath: 'assets/images/Park254_logo.png'
///);
///```
class Booking extends StatefulWidget {
  final String bookingNumber;
  final String destination;
  final String parkingLotNumber;
  final int price;
  final String imagePath;

  Booking({
    @required this.bookingNumber,
    @required this.destination,
    @required this.parkingLotNumber,
    @required this.price,
    @required this.imagePath,
  });

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  DateTime leavingDate = DateTime.now();
  DateTime arrivalDate = DateTime.now();
  DateTime lastDate = DateTime.now().add(Duration(days: 30));
  TimeOfDay arrivalTime = TimeOfDay.now();
  TimeOfDay leavingTime = TimeOfDay.now();
  TextEditingController vehicleController = new TextEditingController();
  TextEditingController numberPlateController = new TextEditingController();
  TextEditingController driverController = new TextEditingController();
  TextEditingController paymentMethodController = new TextEditingController();
  String vehicle = 'prius';
  String numberPlate = 'BBAGAAFAF';
  String driver = "linus";
  String paymentMethod = 'Visa';
  int amount = 0;

  ///shows date picker for arrival date
  _selectArrivalDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: arrivalDate,
      firstDate: arrivalDate,
      lastDate: lastDate,
    );

    if(picked !=null && picked != arrivalDate){
      setState(() {
        arrivalDate = picked;
      });
    }
  }

  ///shows date picker for leaving date
  ///
  /// leaving date has to be set after arrival date
  _selectLeavingDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: leavingDate,
      firstDate: leavingDate,
      lastDate: arrivalDate,
    );

    if(picked !=null && picked != leavingDate){
      setState(() {
        leavingDate = picked;
      });
    }
  }

  ///shows date picker for arrival time
  _selectArrivalTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: arrivalTime,
    );

    if(picked != null && picked != arrivalTime){
      setState(() {
        arrivalTime = picked;
      });
    }
  }

  ///shows date picker for leaving time
  _selectLeavingTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: leavingTime,
    );

    if(picked != null && picked != leavingTime){
      setState(() {
        leavingTime = picked;
      });
    }
  }

  ///Calculates the parking duration and cost
  String _parkingTime(){
    final double totalTime = (leavingTime.hour + (leavingTime.minute / 60)) - (arrivalTime.hour + (arrivalTime.minute / 60));
    int hours = totalTime.floor();
    int minutes = ((totalTime - totalTime.floorToDouble()) * 60).round();
    int parkingHours = totalTime.ceil();
    amount = parkingHours * widget.price;
    return (hours == 0)
        ? '${minutes}m'
        : (minutes == 0) ? '${hours}h' : '${hours}h ${minutes}m';
  }

  ///listens to vehicle type input
  void _changeVehicle(){
    setState(() {
      vehicle = vehicleController.text;
    });
  }

  ///listens to number plate input
  void _changePlate(){
    setState(() {
      numberPlate = numberPlateController.text;
    });
  }

  ///listens to driver input
  void _changeDriver(){
    setState(() {
      driver = driverController.text;
    });
  }

  ///listens to payment method input
  void _changePaymentMethod(){
    setState(() {
      paymentMethod = paymentMethodController.text;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    vehicleController.dispose();
    numberPlateController.dispose();
    driverController.dispose();
    paymentMethodController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Pass Initial values
    vehicleController.text = vehicle;
    numberPlateController.text = numberPlate;
    driverController.text = driver;
    paymentMethodController.text = paymentMethod;

    // Start listening to changes.
    vehicleController.addListener(_changeVehicle);
    numberPlateController.addListener(_changePlate);
    driverController.addListener(_changeDriver);
    paymentMethodController.addListener(_changePaymentMethod);
  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Column(
              children: <Widget>[
                Text(
                  'Booking',
                  style: TextStyle(
                    color: globals.textColor,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.bookingNumber,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                          child: MyText(
                            content: 'Destination',
                          ),
                        ),
                        flex: 1,
                        fit: FlexFit.loose,
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                child: Image(
                                  image: AssetImage(
                                    widget.imagePath,
                                  ),
                                ),
                                flex: 4,
                                fit: FlexFit.loose,
                              ),
                              Spacer(),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        widget.destination,
                                        style: TextStyle(
                                            color: globals.textColor,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      flex: 1,
                                      fit: FlexFit.loose,
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.parkingLotNumber,
                                        style: TextStyle(
                                            color: Colors.blue[400],
                                            fontSize: 30
                                        ),
                                      ),
                                      flex: 1,
                                      fit: FlexFit.loose,
                                    ),

                                  ],
                                ),
                                flex: 8,
                              ),
                            ],
                          ),
                        ),
                        flex: 2,
                        fit: FlexFit.loose,
                      ),
                    ],
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 0, bottom: 0),
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black54)
                                  ),
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Arriving',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Material(
                                              color: Colors.white,
                                              child: InkWell(
                                                onTap: () => _selectArrivalDate(context),
                                                child: Text(
                                                  arrivalDate.day == DateTime.now().day ? 'Today, ' : '${arrivalDate.day.toString()}/${arrivalDate.month.toString()}/${arrivalDate.year.toString()}, ',
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Material(
                                              color: Colors.white,
                                              child: InkWell(
                                                onTap: () => _selectArrivalTime(context),
                                                child: Text(
                                                  '${arrivalTime.hour.toString()}:${arrivalTime.minute.toString()}',
                                                  style: TextStyle(
                                                      color: Colors.black54
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black54)
                                  ),
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Leaving',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Material(
                                              color: Colors.white,
                                              child: InkWell(
                                                onTap: () => _selectLeavingDate(context),
                                                child: Text(
                                                  leavingDate.day == DateTime.now().day ? 'Today, ' : '${leavingDate.day.toString()}/${leavingDate.month.toString()}/${leavingDate.year.toString()}, ',
                                                  style: TextStyle(
                                                      color: Colors.black54
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Material(
                                              color: Colors.white,
                                              child: InkWell(
                                                onTap: () => _selectLeavingTime(context),
                                                child: Text(
                                                  '${leavingTime.hour.toString()}:${leavingTime.minute.toString()}',
                                                  style: TextStyle(
                                                      color: Colors.black54
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              _parkingTime(),
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black54, width: 1))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: MyText(
                              content: 'Vehicle',
                            ),
                          ),
                          flex: 2,
                          fit: FlexFit.loose,
                        ),
                        Flexible(
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Type',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Expanded(
                                child:TextField(
                                  controller: vehicleController,
                                  style: TextStyle(
                                      color: Colors.blue[400]
                                  ),
                                  textAlign: TextAlign.right,
                                  autocorrect: true,
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: InputDecoration.collapsed(hintText: null),
                                ),
                              ),
                            ],
                          ),
                          flex: 1,
                          fit: FlexFit.loose,
                        ),
                        Flexible(
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Plate Number',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Expanded(
                                child:TextField(
                                  controller: numberPlateController,
                                  style: TextStyle(
                                      color: globals.textColor
                                  ),
                                  textAlign: TextAlign.right,
                                  textCapitalization: TextCapitalization.characters,
                                  autocorrect: true,
                                  decoration: InputDecoration.collapsed(hintText: null),
                                ),
                              ),
                            ],
                          ),
                          flex: 1,
                          fit: FlexFit.loose,
                        ),
                      ],
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black54, width: 1))
                    ),
                    child: Row(
                      children: <Widget>[
                        MyText(
                            content: 'Driver Info'
                        ),
                        Expanded(
                          child:TextField(
                            controller: driverController,
                            style: TextStyle(
                                color: globals.textColor
                            ),
                            textAlign: TextAlign.right,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration.collapsed(hintText: null),
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black54))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MyText(
                            content: 'Payment Method'
                        ),
                        Expanded(
                          child:TextField(
                            controller: paymentMethodController,
                            style: TextStyle(
                                color: Colors.blue[400]
                            ),
                            textAlign: TextAlign.right,
                            decoration: InputDecoration.collapsed(hintText: null),
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black54))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MyText(
                            content: 'Price'
                        ),
                        MyText(
                            content: 'Kes ${amount.toString()}'
                        ),
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        Spacer(),
                        Expanded(
                          child: Material(
                            color: globals.primaryColor,
                            child: InkWell(
                              onTap: () => {},
                              child: Center(
                                child: MyText(
                                    content: 'Pay now'
                                ),
                              ),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          ),
                          flex: 2,
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  flex: 2,
                ),
              ],
            ),
          )
        ),
    );
  }
}
