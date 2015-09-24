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
#import "CityTableViewCell.h"
#import "City.h"
#import "Location.h"

@interface CityViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) DataController *dataController;
@property (strong, nonatomic) NSMutableArray *filteredCities;
@property (strong, nonatomic) NSArray *cities;

@end

@implementation CityViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dataController initializeDataIfNeeded];
    
    //Get the content from NSSet and then copy to filteredCities
    self.cities = [self loadAllCities];
    self.filteredCities = [self.cities mutableCopy];
    
    //Hidden the search bar
    self.tableView.contentOffset = CGPointMake(0, 44);
    
    self.searchBar.delegate = self;

}

#pragma mark - Segue method

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"citySegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        City *selectCity = [self.filteredCities objectAtIndex:indexPath.row];
        
        AttractionsTableViewController *attractions = (AttractionsTableViewController *) segue.destinationViewController;

        attractions.city = [self createAndExecuteFetchRequestCityWithKey:ATTRIBUTE_PLACE_ID value:selectCity.placeId];
        attractions.dataStack = self.dataController;
        
        if (self.delegate)
            [self.delegate selectedCity:attractions.city];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredCities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell" forIndexPath:indexPath];
    [cell configureCell:[self.filteredCities objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark - SearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterLocationsForSearchText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Helper methods

- (void)filterLocationsForSearchText:(NSString *)searchText {
    
    if ([searchText length] > 0) {
        [self.filteredCities removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", ATTRIBUTE_NAME, searchText];
        self.filteredCities = [NSMutableArray arrayWithArray:[self.cities filteredArrayUsingPredicate:predicate]];
    }
    else {
        self.filteredCities = [self.cities mutableCopy];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Core data methods


- (NSArray *)loadAllCities {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:CITY_ENTITY_NAME];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:ATTRIBUTE_NAME ascending:YES]];
    
    NSError *error = nil;
    NSArray *result = [self.dataController.context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Error -> %@", error);
    }
    
    return result;
}

- (City *)createAndExecuteFetchRequestCityWithKey:(NSString *)key value:(NSString *)value {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:CITY_ENTITY_NAME];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
    NSError *error = nil;
    NSArray *result = [self.dataController.context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Error -> %@", error);
    }
    
    return [result firstObject];
}


- (void)setDataController:(DataController *)dataController{
    _dataController = dataController;
}
@end
