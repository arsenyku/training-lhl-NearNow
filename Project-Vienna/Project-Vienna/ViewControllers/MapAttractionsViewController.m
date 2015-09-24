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
#import <MapKit/MapKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MapAttractionsViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) DataController *dataController;
@property (strong,nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) User* user;
@property (strong, nonatomic) City* city;

@end

@implementation MapAttractionsViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        _user = nil;
        _city = nil;
        _dataController = nil;
        _currentLocation = nil;
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateMap];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self fetchUser];
    [self updateMap];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	NSLog(@"Should activate Map tab -- Current Loc: %@, Current User: %@, Current City: %@",
          self.currentLocation, self.user, self.city);
    
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
        [self updateMap];
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
    
    annotationView.canShowCallout = YES;

    if ([self.user.locations containsObject:location])
        annotationView.pinColor = MKPinAnnotationColorRed;
    else
	    annotationView.pinColor = MKPinAnnotationColorPurple;
        
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    Location *location = view.annotation;
    location.currentDistanceFromUser = [self distanceToLocation:location];
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
	if (self.city)
    {
        NSArray *annotations = [self.city.locations allObjects];
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
        
        if (distanceInMetres < NOTIFICATION_DISTANCE){
            [self playAlertSound];
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
    
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(self.city.latitude, self.city.longitude);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, ZOOM_IN_MAP_AREA, ZOOM_IN_MAP_AREA);
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    [self fetchUser];
    
    [self displayPins];
    
}

- (void)playAlertSound{
   	NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"tap" withExtension:@"aif"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &soundID);
    AudioServicesPlaySystemSound(soundID);
    AudioServicesPlaySystemSound( kSystemSoundID_Vibrate );
    AudioServicesDisposeSystemSoundID(soundID);
    NSLog(@"Sound triggered");
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
