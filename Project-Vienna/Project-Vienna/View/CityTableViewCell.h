//
//  CityTableViewCell.h
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 22/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import <UIKit/UIKit.h>

@class City;

@interface CityTableViewCell : UITableViewCell

- (void)configureCell:(City *)city;

@end
