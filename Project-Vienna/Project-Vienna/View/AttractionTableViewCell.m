//
//  AttractionsListCell.m
//  Project-Vienna
//
//  Created by asu on 2015-09-21.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "AttractionTableViewCell.h"
#import "Location.h"

@interface AttractionTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *attractionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *attractionRatingLabel;

@end

@implementation AttractionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(Location *)location {
    self.attractionNameLabel.text = location.name;
    self.attractionRatingLabel.text = [NSString stringWithFormat:@"%0.01f", location.rating];
}

@end
