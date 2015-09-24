//
//  AttractionDetailViewController.h
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 22/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"

@class Location;

@interface AttractionDetailViewController : UIViewController

@property (nonatomic, strong) Location *location;
@property (strong, nonatomic) DataController *dataController;

-(void)setDataController:(DataController *)dataController;

@end
