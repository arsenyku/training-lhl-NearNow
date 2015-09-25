//
//  SettingsViewController.m
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 24/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "SettingsViewController.h"
#import "Constants.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (strong, nonatomic) NSNumber *minimumDistanceInMeters;

@end

@implementation SettingsViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    float distanceInMeters = [defaults floatForKey:KEY_NOTIFICATION_DISTANCE];
    float valueSaved = [self convertMetersToKilometers:distanceInMeters];
    
    if (valueSaved == 0.0f) {
        self.distanceSlider.value = 1.0f;
        [self updateDistanceLabel];
    }
    else {
        self.distanceSlider.value = valueSaved;
        [self updateDistanceLabel];
    }
    
    [super viewDidLoad];
}


#pragma mark - IBAction methods

- (IBAction)distanceSliderChanged:(id)sender {

    // Round to nearest 0.1km
    self.distanceSlider.value = (round(self.distanceSlider.value*10.0f)) / 10.0f;
    
    [self updateDistanceLabel];
    self.minimumDistanceInMeters =
    [NSNumber numberWithFloat:[self convertKilometersToMeters:self.distanceSlider.value]];
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:self.minimumDistanceInMeters.floatValue forKey:KEY_NOTIFICATION_DISTANCE];
}


#pragma mark - Helper methods

- (void)updateDistanceLabel {
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f km",self.distanceSlider.value];
}

//Format a float value to NSNumber
- (NSNumber *)formatFloatToNumber:(float)floatValue {
    
    return [NSNumber numberWithFloat:round(floatValue)];
}

//Convert a number in kilometers to meters
- (float)convertKilometersToMeters:(float)kmNumber {

    return kmNumber * 1000.0f;
}

//Convert a number in meters to kilometers
- (float)convertMetersToKilometers:(float)meterNumber {
    
    return meterNumber / 1000.0f;
}


@end
