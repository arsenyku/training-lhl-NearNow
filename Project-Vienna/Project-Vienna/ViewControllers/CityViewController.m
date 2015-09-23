//
//  FirstViewController.m
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 21/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "CityViewController.h"
#import "Constants.h"
#import "AttractionsTableViewController.h"
#import "City.h"
#import "Location.h"


@interface CityViewController () <UITabBarControllerDelegate>

@property (strong, nonatomic) DataController *dataController;

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.parentViewController.tabBarController.delegate = self;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"londonSegue"]){
        AttractionsTableViewController *attractions = (AttractionsTableViewController *) segue.destinationViewController;
        attractions.city = [self createAndExecuteFetchRequestCityWithKey:ATTRIBUTE_PLACE_ID value:LONDON_PLACE_ID];
        attractions.dataStack = self.dataController;
    }
    else if ([segue.identifier isEqualToString:@"newYorkSegue"]){
        AttractionsTableViewController *attractions = (AttractionsTableViewController *) segue.destinationViewController;
        attractions.city = [self createAndExecuteFetchRequestCityWithKey:ATTRIBUTE_PLACE_ID value:NEW_YORK_PLACE_ID];
        attractions.dataStack = self.dataController;
    }
    else if ([segue.identifier isEqualToString:@"vancouverSegue"]){
        AttractionsTableViewController *attractions = (AttractionsTableViewController *) segue.destinationViewController;
        attractions.city = [self createAndExecuteFetchRequestCityWithKey:ATTRIBUTE_PLACE_ID value:VANCOUVER_PLACE_ID];
        attractions.dataStack = self.dataController;
    }
    
}

#pragma mark - private

- (City *) createAndExecuteFetchRequestCityWithKey:(NSString *)key value:(NSString *)value {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
    NSError *error = nil;
    NSArray *result = [self.dataController.context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Error -> %@", error);
    }
    
    return [result firstObject];
}

-(void)setDataController:(DataController *)dataController{
    _dataController = dataController;
}
@end
