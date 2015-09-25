//
//  DataStack.h
//  Project-Vienna
//
//  Created by asu on 2015-09-21.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "DataController.h"
#import <Foundation/Foundation.h>
#import "NSURLSession+DownloadFromAddress.h"
#import <UIKit/UIKit.h>

@import CoreData;
@class Location;
@class User;
@class Route;

@interface DataController : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;

- (NSArray*)cities;

- (void)loadImageFromLocation:(Location *)location completion:(void (^)(UIImage *image, NSError *error))completionHandler;

-(void)loadRouteFromLatitude:(float)fromLatitude
               fromLongitude:(float)fromLongitude
                  toLocation:(Location *)toLocation
                        mode:(NSString*)mode
                  completion:(void (^)(Route *, NSError *))completionHandler;

- (void)initializeDataIfNeeded;

- (void)saveContext;
@end
