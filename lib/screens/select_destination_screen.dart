import 'package:dropsride/global/map_key.dart';
import 'package:dropsride/models/predicted_places.dart';
import 'package:dropsride/models/request_assistant.dart';
import 'package:dropsride/themeProvider/theme_provider.dart';
import 'package:dropsride/widgets/places_prediction_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';

class SelectDestination extends StatefulWidget {
  @override
  State<SelectDestination> createState() => _SelectDestinationState();
}

class _SelectDestinationState extends State<SelectDestination> {
  List<PredictedPlaces> placesPredictedList = [];

  findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapkey&components=country:NG";
      var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if(responseAutoCompleteSearch == "Error Occurred. Failed. No Response.")
      {
        return;
      }

      if(responseAutoCompleteSearch["status"] =="OK"){
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionsList =(placePredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();

        setState(() {
          placesPredictedList = placePredictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        // Adjust the color as needed
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Column(
          children: [
            Text('Select Destination'),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Icon(Icons.location_searching, color: darkTheme ?   Colors.white : Colors.amber,),

                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      onChanged: (value) {
                        findPlaceAutoCompleteSearch(value);
                      },
                      decoration: InputDecoration(
                        hintText: Provider.of<AppInfo>(context).userPickUpLocation != null
                            ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName != null
                            ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!.length > 24
                            ? "${Provider.of<AppInfo>(context).userPickUpLocation!.locationName!.substring(0, 24)}..."
                            : Provider.of<AppInfo>(context).userPickUpLocation!.locationName!)
                            : "Not Getting Address")
                            : "Not Getting Address",
                        fillColor: darkTheme ? Colors.black : Colors.white54,
                        filled: true,
                        border: InputBorder.none,
                        suffixIcon: const Icon(Icons.my_location),
                        contentPadding: const EdgeInsets.only(
                          left: 11,
                          top: 8,
                          bottom: 8,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Icon(Icons.location_on, color: darkTheme ?   Colors.white : Colors.amber,),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      onChanged: (value) {
                        findPlaceAutoCompleteSearch(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Destination',
                        fillColor: darkTheme ? Colors.black : Colors.white54,
                        filled: true,
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.location_on_outlined),
                        contentPadding: EdgeInsets.only(
                          left: 11,
                          top: 8,
                          bottom: 8,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),




            (placesPredictedList.length > 0)
                ? Expanded(
                    child: ListView.separated(
                      itemCount: placesPredictedList.length,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return PlacesPredictionTileDesign(
                          predictedPlaces: placesPredictedList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            SizedBox(height: 5,),
                            Divider(
                              height: 1,
                              color:
                                  darkTheme ? Colors.amber.shade400 : Colors.black,
                              thickness: 0,
                            ),
                            SizedBox(height: 5,),
                          ],
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class TextFieldWithIcon extends StatelessWidget {
  final IconData icon;
  final String hintText;

  const TextFieldWithIcon({
    required this.icon,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
