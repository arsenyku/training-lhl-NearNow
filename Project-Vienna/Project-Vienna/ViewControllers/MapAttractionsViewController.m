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
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapAttractionsViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) DataController *dataController;
@property (strong,nonatomic) CLLocation *currentLocation;
@property (assign,nonatomic) BOOL mapLoadedWithVenues;

@property (strong, nonatomic) User* user;

@end

@implementation MapAttractionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //NSLog(@"%@", self.locationManager);
    
    self.currentLocation = nil;
    
    [[LocationManager sharedManager] startLocationManagerWithDelegate:self];
    
    [self updateMap];
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self fetchUser];
    [self updateMap];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(nonnull CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    CLLocation * loc = [locations objectAtIndex: [locations count] - 1];
    
    NSLog(@"Time %@, latitude %+.6f, longitude %+.6f currentLocation accuracy %1.2f loc accuracy %1.2f timeinterval %f",
          [NSDate date],loc.coordinate.latitude, loc.coordinate.longitude,
          loc.horizontalAccuracy, loc.horizontalAccuracy,
          fabs([loc.timestamp timeIntervalSinceNow]));
    
    NSTimeInterval locationAge = -[loc.timestamp timeIntervalSinceNow];
    if (locationAge > 10.0){
        NSLog(@"locationAge is %1.2f",locationAge);
        return;
    }
    
    if (loc.horizontalAccuracy < 0){
        NSLog(@"loc.horizontalAccuracy is %1.2f",loc.horizontalAccuracy);
        return;
    }
    
    if (_currentLocation == nil || _currentLocation.horizontalAccuracy >= loc.horizontalAccuracy){
        self.currentLocation = loc;
        [self updateMap];
    }
}




#pragma mark - core location

- (void) updateMap {
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
    
    NSLog(@"%@", self.currentLocation);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, ZOOM_IN_MAP_AREA, ZOOM_IN_MAP_AREA);
    
    [_mapView setRegion:adjustedRegion animated:YES];
    
    [self displayPins];
    
    
}

-(void)mapViewDidFinishLoadingMap:(nonnull MKMapView *)mapView{
    if (!_mapLoadedWithVenues) {
        [self updateMap];
    }
}


-(void)setDataController:(DataController*)controller{
    _dataController = controller;
}

-(void)displayPins{
    
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
        NSLog(@"%@", result);
    }
}

@end
