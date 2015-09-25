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
@property (weak, nonatomic) IBOutlet UILabel *openingHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *isOpenLabel;

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation AttractionDetailViewController

#pragma mark - Lyfe cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadInformation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Helper methods

- (void)loadInformation {
    
    [self.dataController loadImageFromLocation:self.location completion:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.attractionImage.image = image;
        });
    }];
    
    self.attractionNameLabel.text = self.location.name;
    self.addressInformationLabel.text = self.location.address;
    
    [self formatIsOpenLabel];
    [self formatOpeningHoursLabel];
    
    if (self.location.website != NULL) {
        [self.websiteAddressButton setTitle:self.location.website forState:UIControlStateNormal];
    }
    else {
        [self.websiteAddressButton setTitle:@"Not available" forState:UIControlStateNormal];
    }
    
    if (self.location.phone != NULL) {
        [self.phoneButton setTitle:self.location.phone forState:UIControlStateNormal];
    }
    else {
        [self.phoneButton setTitle:@"Not available" forState:UIControlStateNormal];
    }
    
}

- (void)formatIsOpenLabel {
    
    if (self.location.hours != NULL) {
        
        BOOL isOpenNow = self.location.hours[@"open_now"];
        if (isOpenNow){
            self.isOpenLabel.text = @"Open -";
        }
        else {
            self.isOpenLabel.text = @"Closed -";
        }
    }
    else {
        self.isOpenLabel.text = @"Not available";
    }
}

- (void)formatOpeningHoursLabel {
  
    if (self.location.hours != NULL) {
        NSDate *date = [NSDate new];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];

        //Day of week 1 to 7
        [dateFormatter setDateFormat:@"e"];
        NSInteger dayOfWeek = [dateFormatter stringFromDate:date].intValue;

        //In the Google API the first day of week is 0
        NSInteger index = dayOfWeek - 2;
        if (index == -1) {
            index = 6;
        }
        else if (index == -2) {
            index = 5;
        }
        self.openingHoursLabel.text = self.location.hours[@"weekday_text"][index];
    }
    else {
        self.openingHoursLabel.text = @" ";
    }
}

#pragma mark - IBAction methods

- (IBAction)backPressedButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)phoneButtonPressed:(id)sender {
    NSString *phone = self.location.phone;
    NSString *cleanNumber = [[phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    
    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@", cleanNumber];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)websiteAddresButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.location.website]];
}

@end
