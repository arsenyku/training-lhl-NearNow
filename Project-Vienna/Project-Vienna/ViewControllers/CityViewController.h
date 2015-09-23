//
//  FirstViewController.h
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 21/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
#import "City.h"

@protocol CitySelectionDelegate <NSObject>
-(void)selectedCity:(City*)city;
@end

@interface CityViewController : UITableViewController
@property (nonatomic, weak) id<CitySelectionDelegate> delegate;
-(void)setDataController:(DataController *)dataController;

@end

