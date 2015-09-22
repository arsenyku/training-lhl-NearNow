//
//  DataStack.h
//  Project-Vienna
//
//  Created by asu on 2015-09-21.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "DataStack.h"
#import <Foundation/Foundation.h>
#import "NSURLSession+DownloadFromAddress.h"

@import CoreData;

@interface DataStack : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;

-(void)initializeDataIfNeeded;
@end
