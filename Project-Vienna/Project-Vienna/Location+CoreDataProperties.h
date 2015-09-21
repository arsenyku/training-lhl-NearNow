//
//  Location+CoreDataProperties.h
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 21/09/15.
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
@property (nullable, nonatomic, retain) City *city;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
