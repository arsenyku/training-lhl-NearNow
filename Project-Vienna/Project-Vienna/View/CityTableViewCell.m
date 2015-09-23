//
//  CityTableViewCell.m
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 22/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "CityTableViewCell.h"
#import "City.h"

@interface CityTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

@end

@implementation CityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(City *)city {
    self.cityNameLabel.text = city.name;
}

@end
