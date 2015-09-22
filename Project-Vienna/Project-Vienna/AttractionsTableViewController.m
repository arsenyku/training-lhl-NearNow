//
//  AttractionsTableViewController.m
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 21/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "Constants.h"
#import "AttractionsTableViewController.h"
#import "NSURLSession+DownloadFromAddress.h"
#import "Location+CoreDataProperties.h"


@interface AttractionsTableViewController ()

@end

@implementation AttractionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - private



-(void) loadData{
    // lat long radius type key

    NSString *dataAddress = [NSString stringWithFormat:RADAR_API, NEW_YORK_LATITUDE, NEW_YORK_LONGITUDE, @"50000", @"museum", API_KEY];
    [NSURLSession downloadFromAddress:dataAddress completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error){
            NSLog(@"In Theatres Endpoint Download Error: %@", error);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if (jsonError){
            NSLog(@"In Theatres Endpoint Deserialization Error: %@", error);
            return;
        }
        
        NSLog(@"dataAddress %@", dataAddress);
        NSLog(@"places: %@", jsonData);
        
        NSArray *placesData = jsonData[ @"results" ];
        
        for (NSDictionary* placeData in placesData) {
            NSString* placeLatitude = placeData[ @"geometry" ][ @"location" ][ @"lat" ];
            NSString* placeLongitude = placeData[ @"geometry" ][ @"location" ][ @"lng" ];
            NSString* placeId = placeData[ @"place_id" ];
            
            NSLog(@"%@ -- %@ -- %@", placeLatitude, placeLongitude, placeId);

            Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                               inManagedObjectContext:self.dataStack.context];
            
          
            location.placeId = placeId;
            location.latitude = placeLatitude.floatValue;
            location.longitude = placeLongitude.floatValue;
        }
        
        
        [self.dataStack.context save:&error];
        
    }];
    
//    @property (nonatomic) float latitude;
//    @property (nonatomic) float longitude;
//    @property (nullable, nonatomic, retain) NSString *name;
//    @property (nullable, nonatomic, retain) NSString *placeId;
//    @property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *locations;

}


@end
