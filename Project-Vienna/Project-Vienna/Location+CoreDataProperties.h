//
//  Location+CoreDataProperties.h
//  Project-Vienna
//
//  Created by asu on 2015-09-22.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *placeId;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) id hours;
@property (nonatomic) float rating;
@property (nullable, nonatomic, retain) id types;
@property (nullable, nonatomic, retain) City *city;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
