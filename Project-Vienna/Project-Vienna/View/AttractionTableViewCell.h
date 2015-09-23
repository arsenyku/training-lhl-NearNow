//
//  AttractionsListCell.h
//  Project-Vienna
//
//  Created by asu on 2015-09-21.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Location;

@interface AttractionTableViewCell : UITableViewCell

- (void)configureCell:(Location *)location;

@end
