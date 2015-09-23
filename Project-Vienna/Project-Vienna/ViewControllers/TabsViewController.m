//
//  TabsViewController.m
//  Project-Vienna
//
//  Created by asu on 2015-09-22.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "TabsViewController.h"
#import "DataController.h"
#import "CityViewController.h"
#import "MapAttractionsViewController.h"

@interface TabsViewController ()
@property (nonatomic, strong) DataController *dataController;
@end

@implementation TabsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.dataController)
        self.dataController = [[DataController alloc] init];
    

    [self.viewControllers[0].childViewControllers[0] setDataController:self.dataController];
    [self.viewControllers[1] setDataController:self.dataController];
}



@end
