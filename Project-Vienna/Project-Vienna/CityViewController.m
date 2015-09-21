//
//  FirstViewController.m
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 21/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "CityViewController.h"

@interface CityViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *londonCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *nycCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *vancouverCell;

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"londonSegue"]){

    }
    else if ([segue.identifier isEqualToString:@"newYorkSegue"]){

    }
    else if ([segue.identifier isEqualToString:@"vancouverSegue"]){

    }
    
}

@end
