import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/components/BackArrow.dart';
import '../config/globals.dart' as globals;
import './MyText.dart';
import './BorderContainer.dart';
import 'package:park254_s_parking_app/components/TimeDatePicker.dart';
import 'package:park254_s_parking_app/components/BookingTextField.dart';

///Creates a booking page
///
/// Requires [bookingNumber], [destination], [parkingLotNumber], [price], and [imagePath]
/// E.g
/// ```dart
/// Navigator.pushNamed(
///   context,
///   Booking.routeName,
///   arguments: BookingArguments(
///      bookingNumber: 'haaga5441',
///      destination: 'Nairobi',
///      parkingLotNumber: 'pajh5114',
///      price: 10,
///      imagePath: 'assets/images/Park254_logo.png'
///   )
///);
///```
class Booking extends StatefulWidget {
  final String bookingNumber;
  final String destination;
  final String parkingLotNumber;
  final int price;
  final String imagePath;
  static const routeName = '/booking';

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
  final List<String> paymentMethodList = <String>['MPESA','Visa'];

  ///shows date picker for arrival date
  void _selectArrivalDate(BuildContext context) async{
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
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: globals.textColor,
            accentColor: globals.textColor,
            colorScheme: ColorScheme.light(primary: globals.textColor),
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child,
        );
      },
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
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: globals.textColor,
            accentColor: globals.textColor,
            colorScheme: ColorScheme.light(primary: globals.textColor),
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child,
        );
      },
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
    int hours;
    int minutes;
    if(totalTime >= 0){
      hours = totalTime.floor();
      minutes = ((totalTime - totalTime.floorToDouble()) * 60).round();
    } else {
      hours = totalTime.ceil();
      minutes = ((totalTime - totalTime.ceilToDouble()) * 60).round();
    }
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

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    vehicleController.dispose();
    numberPlateController.dispose();
    driverController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Pass Initial values
    vehicleController.text = vehicle;
    numberPlateController.text = numberPlate;
    driverController.text = driver;

    // Start listening to changes.
    vehicleController.addListener(_changeVehicle);
    numberPlateController.addListener(_changePlate);
    driverController.addListener(_changeDriver);
  }

  Widget _destination(){
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: Container(
            padding: EdgeInsets.only(bottom: 10, left: width/20, right: width/20),
            child: MyText(
              content: 'Destination',
            ),
          ),
          flex: 1,
          fit: FlexFit.loose,
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.only(left: width/20, right: width/20),
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
                  flex: 3,
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
                        child: MyText(
                          content: widget.destination,
                        ),
                        flex: 1,
                        fit: FlexFit.loose,
                      ),
                      Flexible(
                        child: Text(
                          widget.parkingLotNumber,
                          style: TextStyle(
                              color: Colors.blue[400],
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        flex: 1,
                        fit: FlexFit.loose,
                      ),

                    ],
                  ),
                  flex: 6,
                ),
              ],
            ),
          ),
          flex: 2,
          fit: FlexFit.loose,
        ),
      ],
    );
  }

  Widget _vehicle(){
    return Column(
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
                child:BookingTextField(
                  controller: vehicleController,
                  textColor: Colors.blue[400],
                  fontWeight: FontWeight.bold,
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
                child: BookingTextField(
                  controller: numberPlateController,
                  capitalize: TextCapitalization.characters,
                ),
              ),
            ],
          ),
          flex: 1,
          fit: FlexFit.loose,
        ),
      ],
    );
  }

  Widget _driverInfo(){
    return Row(
      children: <Widget>[
        MyText(
            content: 'Driver Info'
        ),
        Expanded(
          child:BookingTextField(
            controller: driverController,
          ),
        ),
      ],
    );
  }

  Widget _paymentMethod(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        MyText(
            content: 'Payment Method'
        ),
        DropdownButton(
          value: paymentMethod,
          items: paymentMethodList.map<DropdownMenuItem<String>>((String value){
            return DropdownMenuItem<String>(
              value: value,
              child: Align(
                child: Text(value),
                alignment: Alignment.centerLeft,
              ),
            );
          }).toList(),
          onChanged: (String newValue){
            setState(() {
              paymentMethod = newValue;
            });
          },
          underline: Container(
              height: 0
          ),
          style: TextStyle(
              color: Colors.blue[400],
              fontWeight: FontWeight.bold,
              fontSize: 16
          ),
        ),
      ],
    );
  }

  Widget _price(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        MyText(
            content: 'Price'
        ),
        MyText(
            content: 'Kes ${amount.toString()}'
        ),
      ],
    );
  }

  Widget _paymentButton(){
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Spacer(flex: 2,),
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
    );
  }

  @override
  Widget build(BuildContext context){
    var padding = MediaQuery.of(context).padding;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double finalHeight = height - padding.top - padding.bottom - kToolbarHeight;

    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            title: Column(
              children: <Widget>[
                MyText(
                  content: 'Booking',
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
            elevation: 0.0,
            automaticallyImplyLeading: true,
            leading: BackArrow()
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              width: width,
              height: finalHeight,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _destination(),
                      flex: 2,
                    ),
                    Expanded(
                      child: TimeDatePicker(
                          pickArrivalDate: () => _selectArrivalDate(context),
                          pickArrivalTime: () => _selectArrivalTime(context),
                          pickLeavingDate: () => _selectLeavingDate(context),
                          pickLeavingTime: () => _selectLeavingTime(context),
                          arrivalDate: arrivalDate.day == DateTime.now().day ? 'Today, ' : '${arrivalDate.day.toString()}/${arrivalDate.month.toString()}/${arrivalDate.year.toString()},',
                          arrivalTime: arrivalTime.minute > 9 ? ' ' + '${arrivalTime.hour.toString()}:${arrivalTime.minute.toString()}' : ' ' + '${arrivalTime.hour.toString()}:0${arrivalTime.minute.toString()}',
                          leavingDate: leavingDate.day == DateTime.now().day ? 'Today, ' : '${leavingDate.day.toString()}/${leavingDate.month.toString()}/${leavingDate.year.toString()},',
                          leavingTime: leavingTime.minute > 9 ? ' ' + '${leavingTime.hour.toString()}:${leavingTime.minute.toString()}' : ' ' + '${leavingTime.hour.toString()}:0${leavingTime.minute.toString()}',
                          parkingTime: _parkingTime()
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: BorderContainer(
                        content: _vehicle(),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: BorderContainer(
                        content: _driverInfo()
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: BorderContainer(
                        content: _paymentMethod()
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: BorderContainer(
                        content: _price()
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: _paymentButton(),
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
