//
//  DataStack.m
//  Project-Vienna
//
//  Created by asu on 2015-09-21.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "DataStack.h"

@interface DataStack ()

@property (nonatomic, strong) NSManagedObjectModel *mom;
@property (nonatomic, strong) NSPersistentStoreCoordinator *psc;

@end

@implementation DataStack

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // get momd url
        
        NSURL *momdURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        
        
        // init MOM
        self.mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:momdURL];
        
        
        // init PSC
        self.psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.mom];
        
        
        // get data store url
        
        NSString *storePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"datastore.sqlite"];
        
        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        
        // add a NSSQLiteStoreType PS to the PSC
        
        NSError *storeError = nil;
        
        if (![self.psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&storeError]) {
            
            NSLog(@"Couldn't create persistant store %@", storeError);
        }
        
        // make a MOC
        
        self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        
        // set the MOCs PSC
        
        self.context.persistentStoreCoordinator = self.psc;
        
        
    }
    return self;
}


@end
