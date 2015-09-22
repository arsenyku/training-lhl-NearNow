//
//  AttractionDetailViewController.m
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 22/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "AttractionDetailViewController.h"

@interface AttractionDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *attractionImage;

@property (weak, nonatomic) IBOutlet UILabel *attractionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressInformationLabel;
@property (weak, nonatomic) IBOutlet UILabel *localInformationLabel;
@property (weak, nonatomic) IBOutlet UILabel *openingHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteAddressLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *directionsButton;

@end

@implementation AttractionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
