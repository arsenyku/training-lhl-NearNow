//
//  User+CoreDataProperties.h
//  Project-Vienna
//
//  Created by Rodrigo Moura Gonçalves on 23/09/15.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Location *> *locations;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addLocationsObject:(Location *)value;
- (void)removeLocationsObject:(Location *)value;
- (void)addLocations:(NSSet<Location *> *)values;
- (void)removeLocations:(NSSet<Location *> *)values;

@end

NS_ASSUME_NONNULL_END
