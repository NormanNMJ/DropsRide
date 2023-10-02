import 'active_nearby_available_drivers.dart';

class GeoFireAssistant{

static List<ActiveNearByAvailableDrivers> activeNearByAvailableDriversList= [];

static void deleteOfflineDriverFromList(String driversId)
{
  int indexNumber = activeNearByAvailableDriversList.indexWhere((element) => element.driverId == driversId) ;

  activeNearByAvailableDriversList.removeAt(indexNumber);
}

static void updateActiveNearByAvailableDriverLocation(ActiveNearByAvailableDrivers driverWhoMove){

  int indexNumber = activeNearByAvailableDriversList.indexWhere((element) => element.driverId  == driverWhoMove.driverId);

  activeNearByAvailableDriversList[indexNumber].locationLatitude = driverWhoMove.locationLatitude;
  activeNearByAvailableDriversList[indexNumber].locationLongitude = driverWhoMove.locationLongitude;

}
}