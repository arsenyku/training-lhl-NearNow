//
//  AttractionsTableViewController.m
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 21/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//
#import "AttractionsTableViewController.h"
#import "AttractionTableViewCell.h"
#import "NSURLSession+DownloadFromAddress.h"
#import "Location+CoreDataProperties.h"
#import "Constants.h"


@interface AttractionsTableViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *filteredLocations;
@property (strong, nonatomic) NSArray *locations;

@end

@implementation AttractionsTableViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Hidden the search bar
    self.tableView.contentOffset = CGPointMake(0, 44);

    //Get the content from NSSet and then copy to filteredLocations
    self.locations = [self.city.locations allObjects];
    self.filteredLocations = [self.locations mutableCopy];
    
    self.searchBar.delegate = self;
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
    [cell configureCell:[self.filteredLocations objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - SearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterLocationsForSearchText:searchText];
}

#pragma mark - Helper methods

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

@end
