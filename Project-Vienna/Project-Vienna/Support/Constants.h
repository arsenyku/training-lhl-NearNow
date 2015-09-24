//
//  Constants
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 21/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//



#define PLACE_DETAILS_API @"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@"
#define NEARBY_API @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=%@&types=%@&key=%@"
#define RADAR_API @"https://maps.googleapis.com/maps/api/place/radarsearch/json?location=%@,%@&radius=%@&types=%@&key=%@"
#define PLACE_PHOTOS_API @"https://maps.googleapis.com/maps/api/place/photo?maxheight=%d&photoreference=%@&key=%@"

#define NEW_YORK_LATITUDE @"40.7127837"
#define NEW_YORK_LONGITUDE @"-74.0059413"
#define NEW_YORK_PLACE_ID @"ChIJOwg_06VPwokRYv534QaPC8g"

#define VANCOUVER_LATITUDE @"49.2827291"
#define VANCOUVER_LONGITUDE @"-123.1207375"
#define VANCOUVER_PLACE_ID @"ChIJs0-pQ_FzhlQRi_OBm-qWkbs"

#define LONDON_LATITUDE @"51.5073509"
#define LONDON_LONGITUDE @"-0.1277583"
#define LONDON_PLACE_ID @"ChIJdd4hrwug2EcRmSrV3Vo6llI"


#define CITY_ENTITY_NAME @"City"
#define LOCATION_ENTITY_NAME @"Location"
#define USER_ENTITY_NAME @"User"

#define ZOOM_IN_MAP_AREA 2100

#define MAX_HEIGHT 200

#define ATTRIBUTE_PLACE_ID @"placeId"
#define ATTRIBUTE_LATITUTE @"latitude"
#define ATTRIBUTE_LONGITUDE @"longitude"
#define ATTRIBUTE_NAME @"name"
#define ATTRIBUTE_TYPES @"type"
#define ATTRIBUTE_ICON_URL @"iconURL"
#define ATTRIBUTE_WEBSITE @"website"
#define ATTRIBUTE_PHOTO_REFERENCE @"photoReference"

// In metres
#define NOTIFICATION_DISTANCE 2000
#define CITY_BOUNDS_THRESHOLD 55000



