//
//  LocationManager.m
//  Project-Vienna
//
//  Created by asu on 2015-09-22.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "LocationManager.h"
#import "Location.h"

@interface LocationManager()

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationManager

-(instancetype)init{
    self = [super init];
    if (self){
        _locationManager = [[CLLocationManager alloc] init];
        [self setup];
    }
    return self;
}

-(void)setup {
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter = 10; //have to move 100m before location manager checks again
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager requestAlwaysAuthorization];
    NSLog(@"new location Manager in startLocationManager");
    
    [_locationManager startUpdatingLocation];
    NSLog(@"Start Regular Location Manager");
}

- (void)startLocationManagerWithDelegate:(id<CLLocationManagerDelegate>)delegate{
    if ([CLLocationManager locationServicesEnabled]) {
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            [self setup];
            
        }else if (!([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)){
            [self setup];
            
        }else{
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Location services are disabled, Please go into Settings > Privacy > Location to enable them for Play"
                                                               message:nil
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Ok", nil];
            [alertView show];
            
        }
        
        if (delegate)
            [self setDelegate:delegate];
    }
}

-(void)stopLocationManager{
    if ([CLLocationManager locationServicesEnabled]) {
        if (_locationManager) {
            [_locationManager stopUpdatingLocation];
            NSLog(@"Stop Regular Location Manager");
        }
    }
}

-(void)setDelegate:(id<CLLocationManagerDelegate>)delegate{
    self.locationManager.delegate = delegate;
}


- (void)startMonitoringGeofence:(Location*) location radius:(float)radius{
    CLCircularRegion *fenceArea = [[CLCircularRegion alloc]
                                   initWithCenter:CLLocationCoordinate2DMake(location.latitude, location.longitude)
                                   radius:radius
                                   identifier:location.placeId];
    

    
    [self.locationManager startMonitoringForRegion:fenceArea];
}
- (void)stopMonitoringGeofence:(Location*) location{
// 	[self.locationManager stopMonitoringForRegion:region]
}



#pragma mark - class methods

+ (instancetype)sharedManager {
    static LocationManager *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[self alloc] init];
    });
    return sharedLocationManager;
}



@end
