//
//  LocationManager.h
//  Project-Vienna
//
//  Created by asu on 2015-09-22.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class Location;

@interface LocationManager : NSObject

- (void)startLocationManagerWithDelegate:(id<CLLocationManagerDelegate>)delegate;
- (void)stopLocationManager;
- (void)setDelegate:(id<CLLocationManagerDelegate>)delegate;

- (void)startMonitoringGeofence:(Location*)location radius:(float)radius;
- (void)stopMonitoringGeofence:(Location*)location;

+ (instancetype)sharedManager ;

@end
