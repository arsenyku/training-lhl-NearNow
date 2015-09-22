//
//  AttractionsListCell.m
//  Project-Vienna
//
//  Created by asu on 2015-09-21.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "AttractionsListCell.h"
#import "Location.h"

@interface AttractionsListCell()

@property (weak, nonatomic) IBOutlet UILabel *attractionNameLabel;

@end

@implementation AttractionsListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(Location *)location {
    self.attractionNameLabel.text = location.name;
}

@end
