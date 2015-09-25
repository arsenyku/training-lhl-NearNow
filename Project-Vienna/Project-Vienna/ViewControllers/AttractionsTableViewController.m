//
//  AttractionsTableViewController.m
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 21/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//
#import "AttractionsTableViewController.h"
#import "AttractionDetailViewController.h"
#import "AttractionTableViewCell.h"
#import "NSURLSession+DownloadFromAddress.h"
#import "Location+CoreDataProperties.h"
#import "Constants.h"
#import "User.h"


@interface AttractionsTableViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *filteredLocations;
@property (strong, nonatomic) NSArray *locations;
@property (strong, nonatomic) User *user;

@property (nonatomic) BOOL onlyFavorites;

@end

@implementation AttractionsTableViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set the user
    [self fetchUser];
    
    //Hidden the search bar
    self.tableView.contentOffset = CGPointMake(0, 44);

    //Get the content from NSSet and then copy to filteredLocations and sort the content of array by name of locations
    self.locations = [self orderLocationsByNameInArray:[self.city.locations allObjects]];
    self.filteredLocations = [self.locations mutableCopy];
    
    self.searchBar.delegate = self;
    self.onlyFavorites = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Segue method

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
    
    if([segue.identifier isEqualToString:@"detailLocationSegue"]){

        //The tag of the button is the same of the cell and also is the same of indexPath.row
        Location *location = [self.filteredLocations objectAtIndex:sender.tag];
        AttractionDetailViewController *attractionDetail = (AttractionDetailViewController *) segue.destinationViewController;
        attractionDetail.location = location;
        attractionDetail.dataController = self.dataStack;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttractionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttractionCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    [cell configureCell:[self.filteredLocations objectAtIndex:indexPath.row]];
    
    //Check if the location was already saved
    Location *location = [self.filteredLocations objectAtIndex:indexPath.row];
    if ([self.user.locations containsObject:location]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AttractionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    //Save the location that user select
    [self.user addLocationsObject:[self.filteredLocations objectAtIndex:indexPath.row]];
    
    NSError *error = nil;
    [self.dataStack.context save:&error];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    AttractionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    //Delete the location that user deselect
    [self.user removeLocationsObject:[self.filteredLocations objectAtIndex:indexPath.row]];

    NSError *error = nil;
    [self.dataStack.context save:&error];
}

#pragma mark - SearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterLocationsForSearchText:searchText];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Helper methods

- (NSArray *)orderLocationsByNameInArray:(NSArray *)locations {
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:ATTRIBUTE_NAME ascending:YES];
    return [locations sortedArrayUsingDescriptors:@[descriptor]];
}

- (void)filterLocationsForSearchText:(NSString *)searchText {
    
    if ([searchText length] > 0) {
        [self.filteredLocations removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@ || %K contains[c] %@",
                                  ATTRIBUTE_NAME, searchText, ATTRIBUTE_TYPES, searchText];
        self.filteredLocations = [NSMutableArray arrayWithArray:[self.locations filteredArrayUsingPredicate:predicate]];
    }
    else {
        self.filteredLocations = [self.locations mutableCopy];
    }
    
    [self.tableView reloadData];
}

- (void)showFavoritesLocationsFromCurrentCity {
    
    [self.filteredLocations removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", ATTRIBUTE_CITY, self.city];
    NSArray *favoritesLocations = [[self.user.locations allObjects] filteredArrayUsingPredicate:predicate];
    self.filteredLocations = [NSMutableArray arrayWithArray:[self orderLocationsByNameInArray:favoritesLocations]];
}

#pragma mark - IBAction methods

- (IBAction)favoritesButtonPressed:(id)sender {
    
    if (self.onlyFavorites) {
        self.onlyFavorites = NO;
    }
    else {
        self.onlyFavorites = YES;
    }
    
    if (self.onlyFavorites) {
        [self showFavoritesLocationsFromCurrentCity];
    }
    else {
        self.filteredLocations = [self.locations mutableCopy];
    }

    [self.tableView reloadData];
}

#pragma mark - Core data methods

- (void)fetchUser {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:USER_ENTITY_NAME
                                              inManagedObjectContext:self.dataStack.context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [self.dataStack.context
                       executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else {
        NSLog(@"%lu users: %@", [result count], result);
        self.user = [result firstObject];
        NSLog(@"Count locations %lu", [self.user.locations count]);
    }
}

@end
