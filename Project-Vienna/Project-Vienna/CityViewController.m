//
//  FirstViewController.m
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 21/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "CityViewController.h"
#import "AttractionsTableViewController.h"
#import "City.h"
#import "Location.h"
#import "DataStack.h"

@interface CityViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *londonCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *nycCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *vancouverCell;

@property (strong, nonatomic) City *london;
@property (strong, nonatomic) City *nyc;
@property (strong, nonatomic) City *vancouver;

@property (strong, nonatomic) DataStack *dataStack;

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"londonSegue"]){
        AttractionsTableViewController *attractions = (AttractionsTableViewController *) segue.destinationViewController;
        attractions.city = self.london;
        attractions.dataStack = self.dataStack;
    }
    else if ([segue.identifier isEqualToString:@"newYorkSegue"]){
        AttractionsTableViewController *attractions = (AttractionsTableViewController *) segue.destinationViewController;
        attractions.city = self.nyc;
        attractions.dataStack = self.dataStack;
    }
    else if ([segue.identifier isEqualToString:@"vancouverSegue"]){
        AttractionsTableViewController *attractions = (AttractionsTableViewController *) segue.destinationViewController;
        attractions.city = self.vancouver;
        attractions.dataStack = self.dataStack;
    }
    
}

#pragma mark - private

-(DataStack*)dataStack{
    if (! _dataStack)
        _dataStack = [[DataStack alloc] init];

    return _dataStack;
}
@end
