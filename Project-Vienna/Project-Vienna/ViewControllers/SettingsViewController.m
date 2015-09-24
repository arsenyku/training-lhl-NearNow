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

    NSNumber *distanceInMeters = [NSNumber numberWithInteger:[defaults integerForKey:KEY_NOTIFICATION_DISTANCE]];
    NSNumber *valueSaved = [self convertMetersToKilometers:distanceInMeters];
    
    if (valueSaved.intValue == 0) {
        self.distanceSlider.value = 2;
    }
    else {
        self.distanceSlider.value = valueSaved.floatValue;
        [self updateDistanceLabelWithValue:valueSaved.intValue];
    }
    
    [super viewDidLoad];
}


#pragma mark - IBAction methods

- (IBAction)distanceSliderChanged:(id)sender {
    
    NSUInteger index = self.distanceSlider.value;
    [self.distanceSlider setValue:index animated:YES];

    NSNumber *distance = [self formatFloatToNumber:self.distanceSlider.value];
    [self updateDistanceLabelWithValue:distance.intValue];
    self.minimumDistanceInMeters = [self convertKilometersToMeters:distance];
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.minimumDistanceInMeters.intValue forKey:KEY_NOTIFICATION_DISTANCE];
}


#pragma mark - Helper methods

- (void)updateDistanceLabelWithValue:(int)value {
    self.distanceLabel.text = [NSString stringWithFormat:@"%d km",value];
}

//Format a float value to NSNumber
- (NSNumber *)formatFloatToNumber:(float)floatValue {
    
    return [NSNumber numberWithFloat:round(floatValue)];
}

//Convert a number in kilometers to meters
- (NSNumber *)convertKilometersToMeters:(NSNumber *)kmNumber {

    return [NSNumber numberWithInt:kmNumber.intValue * 1000];
}

//Convert a number in meters to kilometers
- (NSNumber *)convertMetersToKilometers:(NSNumber *)meterNumber {
    
    return [NSNumber numberWithInt:meterNumber.intValue / 1000];
}


@end
