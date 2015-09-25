//
//  Route.h
//  Project-Vienna
//
//  Created by asu on 2015-09-25.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouteSegment.h"

@interface Route : NSObject
@property (nonatomic) NSString *durationText;
- (NSArray*)segments;
- (void)addSegment:(RouteSegment*)segment;
@end
