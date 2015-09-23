//
//  AttractionDetailViewController.m
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 22/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "AttractionDetailViewController.h"
#import "Location.h"

@interface AttractionDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *attractionImage;

@property (weak, nonatomic) IBOutlet UILabel *attractionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressInformationLabel;
@property (weak, nonatomic) IBOutlet UILabel *localInformationLabel;
@property (weak, nonatomic) IBOutlet UILabel *openingHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *isOpenLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *directionsButton;

@end

@implementation AttractionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadInformation];
}

- (void)loadInformation {
    
    [self.dataController loadImageFromLocation:self.location completion:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.attractionImage.image = image;
        });
    }];
    
    self.attractionNameLabel.text = self.location.name;
    self.addressInformationLabel.text = self.location.address;
    self.phoneNumberLabel.text = self.location.phone;
    
    if (self.location.hours != NULL) {
        BOOL isOpenNow = self.location.hours[@"open_now"];
        if (isOpenNow){
           self.isOpenLabel.text = @"Open";
        }
        else {
           self.isOpenLabel.text = @"Close";
        }
        NSDate *date = [NSDate new];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"c"];
        NSString *dayOfWeek = [dateFormatter stringFromDate:date];
        self.openingHoursLabel.text = self.location.hours[@"weekday_text"][dayOfWeek.intValue];
        self.websiteAddressLabel.text = self.location.website;
    }
}


- (IBAction)backPressedButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)directionsPressedButton:(id)sender {
}

@end
