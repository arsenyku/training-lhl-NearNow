//
//  SecondViewController.m
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 21/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "Constants.h"
#import "MapAttractionsViewController.h"
#import "LocationManager.h"
#import "User.h"
#import "Location.h"
#import "Route.h"
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MapAttractionsViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) MKPolyline *routeLine;

@property (weak, nonatomic) IBOutlet UIButton *trackingToggleButton;

@property (strong, nonatomic) DataController *dataController;
@property (strong,nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) User* user;
@property (strong, nonatomic) City* city;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property (strong, nonatomic) NSDate *lastPostDate;

@property (strong, nonatomic) Location *lastTappedLocation;

@property (assign, nonatomic) float notificationDistanceInMeters;
@property (assign, nonatomic) float notifyWhenClose;

@end

@implementation MapAttractionsViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        _user = nil;
        _city = nil;
        _dataController = nil;
        _currentLocation = nil;
        _lastTappedLocation = nil;
        _notificationDistanceInMeters = 1000.0f;
        _notifyWhenClose = NO;
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.trackingToggleButton.layer.cornerRadius = 5.0f;
    self.trackingToggleButton.layer.masksToBounds = YES;
    
    [self readUserDefaults];
    
    [self updateMap];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self updateMap];
}

#pragma mark - UI Control Events

- (IBAction)homeToUser:(UIButton *)sender {

    [self showMapAtLatitude:self.currentLocation.coordinate.latitude
                  longitude:self.currentLocation.coordinate.longitude];

}

- (void)toggleLastTappedLocation{
    if ([self.user.locations containsObject:self.lastTappedLocation]){
        [self.user removeLocationsObject:self.lastTappedLocation];
    } else {
        [self.user addLocationsObject:self.lastTappedLocation];
    }
    [self.dataController saveContext];
    [self updateMap];
}

- (IBAction)toggleNotificationTracking:(UIButton *)sender {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.notifyWhenClose = ! self.notifyWhenClose;
    [defaults setBool:self.notifyWhenClose forKey:KEY_NOTIFY_WHEN_CLOSE];
    
    [self setupNotifications];
    
    [self updateMap];
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	if (viewController != self)
        return YES;
    
    if (self.city != nil)
        return YES;
    
    if (self.currentLocation == nil)
        return NO;
    
    if (self.dataController == nil)
        return NO;
    
    NSArray *cities = [self.dataController cities];
    for (City *city in cities) {
        if ([self currentlyInCity:city]){
            self.city = city;
            return YES;
        }
    }

    [self showAutoDismissAlertWithTitle:@"Select a city"
                                message:@""
                dismissalDelayInSeconds:1
                            actionTitle:@""
                                 action:nil];
    
    return NO;
}


#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(nonnull CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    CLLocation * location = [locations objectAtIndex: [locations count] - 1];
    
    NSLog(@"Time %@, latitude %+.6f, longitude %+.6f currentLocation accuracy %1.2f loc accuracy %1.2f timeinterval %f",
          [NSDate date],location.coordinate.latitude, location.coordinate.longitude,
          location.horizontalAccuracy, location.horizontalAccuracy,
          fabs([location.timestamp timeIntervalSinceNow]));
    
    NSTimeInterval locationAge = -[location.timestamp timeIntervalSinceNow];
    if (locationAge > 10.0){
        NSLog(@"locationAge is %1.2f",locationAge);
        return;
    }
    
    if (location.horizontalAccuracy < 0){
        NSLog(@"horizontalAccuracy is %1.2f",location.horizontalAccuracy);
        return;
    }
    
    if (self.currentLocation == nil || self.currentLocation.horizontalAccuracy >= location.horizontalAccuracy){
        self.currentLocation = location;
        [self checkDistanceToFavourites];
    }
}


#pragma mark - MKMapViewDelegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    Location *location = (Location*)annotation;
    
    MKPinAnnotationView *annotationView =
    (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"location"];

    if (annotationView == nil){
		annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:@"location"];
    } else{
        annotationView.annotation = annotation;
    }
    
    annotationView.alpha = 0.75f;
    
    annotationView.canShowCallout = YES;

    UIButton* accessoryButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [accessoryButton addTarget:self
						action:@selector(toggleLastTappedLocation)
              forControlEvents:UIControlEventTouchUpInside];

    annotationView.rightCalloutAccessoryView = accessoryButton;

    if ([self.user.locations containsObject:location])
        annotationView.pinColor = MKPinAnnotationColorRed;
    else
	    annotationView.pinColor = MKPinAnnotationColorPurple;
        
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{

    if (view.annotation && [view.annotation isKindOfClass:[MKUserLocation class]])
        return;

    Location *location = view.annotation;

    location.currentDistanceFromUser = [self distanceToLocation:location];
    self.lastTappedLocation = location;
    
    [self showRouteToLocation:location];

}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [self.mapView removeOverlay:self.routeLine];
    self.routeLine = nil;
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:MKPolyline.class]) {
        MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        lineView.strokeColor = [UIColor colorWithRed:46.0f/255.0f
                                               green:165.0f/255.0f
                                                blue:249.0f/255.0f
                                               alpha:1.0];
        
        lineView.lineWidth = 1.5f;
        
        return lineView;
    }
    
    return nil;
}

#pragma mark - private

-(void)selectedCity:(City *)city{
    self.city = city;
}


-(void)setDataController:(DataController*)controller{
    _dataController = controller;
}

-(BOOL)currentlyInCity:(City*)city{
    float distanceToCity = [self distanceFromFirstLatidude:self.currentLocation.coordinate.latitude
                                            firstLongitude:self.currentLocation.coordinate.longitude
                                          toSecondLatitude:city.latitude
                                           secondLongitude:city.longitude];
    
    return (distanceToCity <= CITY_BOUNDS_THRESHOLD);
        
}


-(void)displayPins{
	NSArray *cities = [self.dataController cities];
    for (City *city in cities) {
        NSArray *annotations = [city.locations allObjects];
        [self.mapView removeAnnotations:annotations];
        [self.mapView addAnnotations:annotations];
    }
}



-(float)radiansFromDegrees:(float)degrees{
    return (M_PI/180.0f) * degrees;
}

-(float)distanceFromFirstLatidude:(float)latitude1 firstLongitude:(float)longitude1
                 toSecondLatitude:(float)latitude2 secondLongitude:(float)longitude2{
    latitude1 = [self radiansFromDegrees:latitude1];
    longitude1 = [self radiansFromDegrees:longitude1];
    latitude2 = [self radiansFromDegrees:latitude2];
    longitude2 = [self radiansFromDegrees:longitude2];
    
    //    dlon = lon2 - lon1
    float deltaLongitude = (longitude2 - longitude1);
    
    //    dlat = lat2 - lat1
    float deltaLatitude = (latitude2 - latitude1);
    
    //    a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2
    float aValue = pow(sin(deltaLatitude / 2.0f), 2.0f) +
    cos(latitude1) * cos(latitude2) *
    pow(sin(deltaLongitude / 2.0f), 2.0f);
    
    //    c = 2 * atan2( sqrt(a), sqrt(1-a) )
    float cValue = 2 * atan2( sqrt(aValue), sqrt( 1.0f - aValue ) );
    
    //    d = R * c (where R is the radius of the Earth)
    float earthRadius = 6373000.0f;
    
    float distance = earthRadius * cValue;

    return distance;
}

- (void) checkDistanceToFavourites {
    for (Location* favourite in self.user.locations) {
        
        float distanceInMetres = [self distanceToLocation:favourite];
        int const MinSecondsBetweenAlerts = 30;
        
        if (self.notifyWhenClose && (distanceInMetres < self.notificationDistanceInMeters)){
            double elapsed = [self secondsSinceDate:self.lastPostDate];
            if (elapsed < MinSecondsBetweenAlerts)
                return;
            
            [self playAlertSound];
            [self postNotification];

            self.lastPostDate = [NSDate date];

        }
    }
}

- (float)distanceToLocation:(Location*)location{
    
    float distanceInMetres = [self distanceFromFirstLatidude:self.currentLocation.coordinate.latitude
                                              firstLongitude:self.currentLocation.coordinate.longitude
                                            toSecondLatitude:location.latitude
                                             secondLongitude:location.longitude];

    return distanceInMetres;
}



- (void) updateMap {

    float latitude = self.city.latitude;
    float longitude = self.city.longitude;
    
    if ([self currentlyInCity:self.city]){
        latitude = self.currentLocation.coordinate.latitude;
        longitude = self.currentLocation.coordinate.longitude;
    }
    
    [self showMapAtLatitude:latitude longitude:longitude];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.notifyWhenClose){
            [self.trackingToggleButton setBackgroundColor:[UIColor blackColor]];
            [self.trackingToggleButton setImage:[UIImage imageNamed:@"Sensor colour"] forState:UIControlStateNormal];
        } else {
            [self.trackingToggleButton setBackgroundColor:[UIColor clearColor]];
            [self.trackingToggleButton setImage:[UIImage imageNamed:@"Sensor bw"] forState:UIControlStateNormal];
        }
    });
    

}

-(void)showMapAtLatitude:(float)latitude longitude:(float)longitude {
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(latitude, longitude);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, ZOOM_IN_MAP_AREA, ZOOM_IN_MAP_AREA);
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    [self fetchUser];
    
    [self displayPins];
    
}

- (void)showRouteToLocation:(Location*)location{

    NSString *travelMode = DRIVING_ROUTE_MODE;
    if ([self distanceToLocation:location] < 2500)
        travelMode = WALKING_ROUTE_MODE;
    
    [self.dataController loadRouteFromLatitude:self.currentLocation.coordinate.latitude
                                 fromLongitude:self.currentLocation.coordinate.longitude
                                    toLocation:location
                                          mode:travelMode
                                    completion:^(Route *route, NSError *error) {
                                        if (route == nil) {
                                            NSLog(@"No route received");
                                            return;
                                        }
                                        
                                        [self routeOverlay:route toLocation:location];
                                    }];
}

- (void)routeOverlay:(Route*)route toLocation:(Location*)location{
    NSLog(@"Route: %@", route.segments);
    
    int segmentsCount = (int)[route.segments count];
    CLLocationCoordinate2D pointsToUse[segmentsCount+2];
    
    for(int i=0; i<segmentsCount; i++) {
        RouteSegment *segment = route.segments[i];
        pointsToUse[i] = CLLocationCoordinate2DMake([segment.startLatitude floatValue], [segment.startLongitude floatValue]);
    }

    RouteSegment *segment = [route.segments lastObject];
    pointsToUse[segmentsCount] = CLLocationCoordinate2DMake([segment.endLatitude floatValue], [segment.endLongitude floatValue]);
    pointsToUse[segmentsCount+1] = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    
    self.routeLine = [MKPolyline polylineWithCoordinates:pointsToUse count:segmentsCount+2];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView addOverlay:self.routeLine];
    });
    
}

- (void)playAlertSound{
   	NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ding" ofType:@"mp3"]];
    
    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    
    if (error)
        NSLog(@"Audio Player init error: %@", error);
    
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];

}

- (void)readUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.notificationDistanceInMeters = [defaults floatForKey:KEY_NOTIFICATION_DISTANCE];
    self.notifyWhenClose = [defaults boolForKey:KEY_NOTIFY_WHEN_CLOSE];

}

-(void)fetchUser{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:self.dataController.context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [self.dataController.context
                       executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else {
        self.user = [result firstObject];
    }
}

- (double)secondsSinceDate:(NSDate*)date{

    NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:date];
    return elapsed;

}
- (void)postNotification{
    UILocalNotification *post = [[UILocalNotification alloc] init];
    post.alertTitle = @"Project-Vienna";
    post.alertBody = @"You are near a location of interest.";
    post.alertAction = @"Action";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:post];
    
    self.lastPostDate = [NSDate date];
    
}

- (void)setupNotifications{

    int numberOfFences = 10;
    
    NSArray* sortedByDistance = [[self.user.locations allObjects] sortedArrayUsingComparator:
     ^NSComparisonResult(id  _Nonnull location1, id  _Nonnull location2) {

         float distance1 = [self distanceToLocation:location1];
         float distance2 = [self distanceToLocation:location2];
         
         if (distance1 < distance2)
             return NSOrderedAscending;
         
         if (distance1 == distance2)
             return NSOrderedSame;
         
         //if (distance1 > distance2)
        return NSOrderedDescending;
         
         
    }];
    
    if ([sortedByDistance count] > numberOfFences){
        NSRange subArrayRange;
        subArrayRange.location = 0;
        subArrayRange.length = numberOfFences;
        sortedByDistance = [sortedByDistance subarrayWithRange:subArrayRange];
    }
    
    for (Location *location in sortedByDistance) {
        [[LocationManager sharedManager] startMonitoringGeofence:location radius:self.notificationDistanceInMeters];
    }

}



-(void)showAutoDismissAlertWithTitle:(NSString*)messageTitle
                             message:(NSString*)message
             dismissalDelayInSeconds:(int)delay
                         actionTitle:(NSString*)actionTitle
                              action:(void (^)(UIAlertAction *action))handler{
    
    UIAlertController* alert =
    [UIAlertController alertControllerWithTitle:messageTitle
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    if (actionTitle && handler){
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:actionTitle
                                                                style:UIAlertActionStyleDefault
                                                              handler:handler];
        
        [alert addAction:defaultAction];
    }
    
    if (delay > 0){
        [NSTimer scheduledTimerWithTimeInterval:delay
                                         target:self
                                       selector:@selector(dismissAlert)
                                       userInfo:nil
                                        repeats:NO];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)dismissAlert{
    [self dismissViewControllerAnimated:YES
                             completion:^{

                             }];
}


@end
