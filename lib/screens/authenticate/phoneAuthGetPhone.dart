import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:peoplesign/models/country.dart';
import 'package:peoplesign/screens/authenticate/phoneAuthVerify.dart';
import 'package:peoplesign/services/auth.dart';
import 'package:peoplesign/shared/loading.dart';

class PhoneAuthGetPhone extends StatefulWidget {
  @override
  _PhoneAuthGetPhoneState createState() => _PhoneAuthGetPhoneState();
}

class _PhoneAuthGetPhoneState extends State<PhoneAuthGetPhone> {
  final AuthService _authService = AuthService();

  /*
   *  _height & _width:
   *    will be calculated from the MediaQuery of widget's context
   *
   */
  double _height, _width, _fixedPadding;
  bool loading = false;
  bool _isCountriesDataFormed = false;

  List<Country> countries = [];
  StreamController<List<Country>> _countriesStreamController;
  Stream<List<Country>> _countriesStream;
  Sink<List<Country>> _countriesSink;

  TextEditingController _searchCountryController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  /*
   *  This will be the index, we will modify each time the user selects a new country from the dropdown list(dialog),
   *  As a default case, we are using India as default country, index = 101 is Indonesia
   */
  int _selectedCountryIndex = 101;

  @override
  Widget build(BuildContext context) {
    //  Fetching height & width parameters from the MediaQuery
    //  _logoPadding will be a constant, scaling it according to device's size
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;

    WidgetsBinding.instance.addPostFrameCallback((Duration d) {
      if (countries.length < 240) {
        _loadCountriesJson().whenComplete(() {
          setState(() => _isCountriesDataFormed = true);
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.brown[500],
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: SizedBox(
                height: _height * 8 / 10,
                width: _width * 8 / 10,

                /*
                 * Fetching countries data from JSON file and storing them in a List of Country model:
                 * ref:- List<Country> countries
                 * Until the data is fetched, there will be CircularProgressIndicator showing, describing something is on it's way
                 * (Previously there was a FutureBuilder rather that the below thing, which created unexpected exceptions and had to be removed)
                 */
                child: !_isCountriesDataFormed
                    ? Center(
                        child: Loading(),
                      )
                    : loading
                        ? Center(
                            child: Loading(),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: 40.0),
                              Text('Verify Phone Number',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.brown[500],
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w700)),

                              Padding(
                                padding: EdgeInsets.only(
                                    top: _fixedPadding, left: _fixedPadding),
                                child: _subTitle('Select your country'),
                              ),

                              /*
                           *  Select your country, this will be a custom DropDown menu, rather than just as a dropDown
                           *  onTap of this, will show a Dialog asking the user to select country they reside,
                           *  according to their selection, prefix will change in the PhoneNumber TextFormField
                           */
                              Padding(
                                padding: EdgeInsets.only(
                                    left: _fixedPadding, right: _fixedPadding),
                                child: Card(
                                  child: InkWell(
                                    onTap: _showCountries,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0,
                                          right: 4.0,
                                          top: 8.0,
                                          bottom: 8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Text(
                                                  ' ${countries[_selectedCountryIndex].flag}  ${countries[_selectedCountryIndex].name} ')),
                                          Icon(Icons.arrow_drop_down,
                                              size: 24.0)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              //  Subtitle for Enter your phone
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, left: _fixedPadding),
                                child: _subTitle('Enter your phone'),
                              ),
                              //  PhoneNumber TextFormFields
                              Padding(
                                padding: EdgeInsets.only(
                                    left: _fixedPadding,
                                    right: _fixedPadding,
                                    bottom: _fixedPadding),
                                child: Card(
                                  child: TextFormField(
                                    controller: _phoneNumberController,
                                    autofocus: true,
                                    keyboardType: TextInputType.phone,
                                    key: Key('EnterPhone-TextFormField'),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      errorMaxLines: 1,
                                      prefix: Text("  " +
                                          countries[_selectedCountryIndex]
                                              .dialCode +
                                          "  "),
                                    ),
                                  ),
                                ),
                              ),
                              /*
                                 *  Some informative text
                                 */
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(width: _fixedPadding),
                                  Icon(Icons.info,
                                      color: Colors.brown[500], size: 20.0),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                    child: RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: 'We will send ',
                                          style: TextStyle(
                                              color: Colors.brown[500],
                                              fontWeight: FontWeight.w400)),
                                      TextSpan(
                                          text: 'One Time Password',
                                          style: TextStyle(
                                              color: Colors.brown[500],
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700)),
                                      TextSpan(
                                          text: ' to this mobile number',
                                          style: TextStyle(
                                              color: Colors.brown[500],
                                              fontWeight: FontWeight.w400)),
                                    ])),
                                  ),
                                  SizedBox(width: _fixedPadding),
                                ],
                              ),
                              /*
                                 *  Button: OnTap of this, it appends the dial code and the phone number entered by the user to send OTP,
                                 *  knowing once the OTP has been sent to the user - the user will be navigated to a new Screen,
                                 *  where is asked to enter the OTP he has received on his mobile (or) wait for the system to automatically detect the OTP
                                 */
                              SizedBox(height: _fixedPadding * 1.5),
                              RaisedButton(
                                elevation: 16.0,
                                onPressed: () async {
                                  setState(() {
                                    this.loading = true;
                                  });
                                  dynamic result = await _authService
                                      .verifyPhoneNumber(
                                          countries[_selectedCountryIndex]
                                                  .dialCode +
                                              _phoneNumberController.text, () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                PhoneAuthVerify()));
                                  });
                                  if (result == null) {
                                    setState(() {
                                      this.loading = false;
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'SEND OTP',
                                    style: TextStyle(
                                        color: Colors.brown[500],
                                        fontSize: 18.0),
                                  ),
                                ),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                              ),
                            ],
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Country>> _loadCountriesJson() async {
    //  Cleaning up the countries list before we put our data in it
    countries.clear();

    //  Fetching the json file, decoding it and storing each object as Country in countries(list)
    var value = await DefaultAssetBundle.of(context)
        .loadString("data/country_phone_codes.json");
    var countriesJson = json.decode(value);
    for (var country in countriesJson) {
      countries.add(Country.fromJson(country));
    }

    //Finally adding the initial data to the _countriesSink
    // _countriesSink.add(countries);
    return countries;
  }

  /*
   *  This will trigger a dialog, that will let the user to select their country, so the dialcode
   *  of their country will be automatically added at the end
   */
  void _showCountries() {
    /*
     * Initialising components required for StreamBuilder
     * We will not be using _countriesStreamController anywhere, but just to initialize Stream & Sink from that
     * _countriesStream will give us the data what we need(output) - that will be used in StreamBuilder widget
     * _countriesSink is the place where we send the data(input)
     */
    _countriesStreamController = StreamController();
    _countriesStream = _countriesStreamController.stream;
    _countriesSink = _countriesStreamController.sink;
    _countriesSink.add(countries);

    _searchCountryController.addListener(_searchCountries);

    showDialog(
        context: context,
        builder: (BuildContext context) => WillPopScope(
              onWillPop: () => Future.value(false),
              child: Dialog(
                key: Key('SearchCountryDialog'),
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //  TextFormField for searching country
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, top: 8.0, bottom: 2.0, right: 8.0),
                        child: Card(
                          child: TextFormField(
                            autofocus: true,
                            controller: _searchCountryController,
                            decoration: InputDecoration(
                                hintText: 'Search your country',
                                contentPadding: const EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                border: InputBorder.none),
                          ),
                        ),
                      ),

                      //  Returns a list of Countries that will change according
                      //  to the search query
                      SizedBox(
                        height: 300.0,
                        child: StreamBuilder<List<Country>>(
                            //key: Key('Countries-StreamBuilder'),
                            stream: _countriesStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data.length == 0
                                    ? Center(
                                        child: Text(
                                            'Your search found no results',
                                            style: TextStyle(fontSize: 16.0)),
                                      )
                                    : ListView.builder(
                                        itemCount: snapshot.data.length,
                                        itemBuilder:
                                            (BuildContext context, int i) =>
                                                Material(
                                          color: Colors.white,
                                          type: MaterialType.canvas,
                                          child: InkWell(
                                            onTap: () {
                                              _searchCountryController.clear();
                                              Navigator.of(context).pop();
                                              Future.delayed(Duration(
                                                      milliseconds: 10))
                                                  .whenComplete(() {
                                                _countriesStreamController
                                                    .close();
                                                _countriesSink.close();

                                                setState(() {
                                                  _selectedCountryIndex =
                                                      countries.indexOf(
                                                          snapshot.data[i]);
                                                });
                                              });
                                            },
                                            //selectThisCountry(country),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 10.0,
                                                  top: 10.0,
                                                  bottom: 10.0),
                                              child: Text(
                                                "  " +
                                                    snapshot.data[i].flag +
                                                    "  " +
                                                    snapshot.data[i].name +
                                                    " (" +
                                                    snapshot.data[i].dialCode +
                                                    ")",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                              } else if (snapshot.hasError)
                                return Center(
                                  child: Text('Seems, there is an error',
                                      style: TextStyle(fontSize: 16.0)),
                                );
                              return Center(child: CircularProgressIndicator());
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
        barrierDismissible: false);
  }

  /*
   *  This will be the listener for searching the query entered by user
   *  for their country, (dialog pop-up),
   *  searches for the query and returns list of countries matching the query
   *  by adding the results to the sink of _countriesStream
   */
  void _searchCountries() {
    String query = _searchCountryController.text;
    if (query.length == 0 || query.length == 1) {
      if (!_countriesStreamController.isClosed) _countriesSink.add(countries);
//      print('added all countries again');
    } else if (query.length >= 2 && query.length <= 5) {
      List<Country> searchResults = [];
      searchResults.clear();
      countries.forEach((Country c) {
        if (c.toString().toLowerCase().contains(query.toLowerCase()))
          searchResults.add(c);
      });
      _countriesSink.add(searchResults);
//      print('added few countries based on search ${searchResults.length}');
    } else {
      //No results
      List<Country> searchResults = [];
      _countriesSink.add(searchResults);
//      print('no countries added');
    }
  }

  Widget _subTitle(String text) => Align(
      alignment: Alignment.centerLeft,
      child: Text(' $text',
          style: TextStyle(color: Colors.white, fontSize: 14.0)));
}
