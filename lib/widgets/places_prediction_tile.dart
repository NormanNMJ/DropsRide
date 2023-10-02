import 'package:dropsride/global/map_key.dart';
import 'package:dropsride/infoHandler/app_info.dart';
import 'package:dropsride/models/directions.dart';
import 'package:dropsride/models/request_assistant.dart';
import 'package:dropsride/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global/global.dart';
import '../models/predicted_places.dart';

class PlacesPredictionTileDesign extends StatefulWidget {
  final PredictedPlaces? predictedPlaces;

  PlacesPredictionTileDesign({this.predictedPlaces});

  @override
  State<PlacesPredictionTileDesign> createState() =>
      _PlacesPredictionTileDesignState();
}

class _PlacesPredictionTileDesignState
    extends State<PlacesPredictionTileDesign> {

  getPlacedDirectionDetails(String? placeId, context) async
  {
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) => ProgressDialog(
    //       message:"Setting up Drop-off. Please wait...",
    //         ),
    // );
    String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapkey";

    var responseApi = await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);
    // Navigator.pop(context);

    if(responseApi == "Error Occurred. Failed. No Response.")
    {
      return;
    }
    if(responseApi["status"] == "OK"){
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];
      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
      });

      Navigator.pop(context, "obtainedDropOff");

    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return  GestureDetector(
      onTap: () {
        getPlacedDirectionDetails(widget.predictedPlaces!.place_id, context);
      },

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.add_location,
              size: 24.0, // Icon size
              color: darkTheme ? Colors.white : Colors.amber,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.predictedPlaces!.main_text!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0, // Text font size
                      color: darkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    widget.predictedPlaces!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0, // Text font size
                      color: darkTheme ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
