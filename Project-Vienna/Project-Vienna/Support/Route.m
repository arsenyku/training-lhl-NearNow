//
//  Route.m
//  Project-Vienna
//
//  Created by asu on 2015-09-25.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "Route.h"
@interface Route()
@property (nonatomic) NSArray* segments;
@end

@implementation Route

- (instancetype)init
{
    self = [super init];
    if (self) {
        _segments = @[];
    }
    return self;
}


- (NSArray*)segments{
    return _segments;
}
- (void)addSegment:(RouteSegment*)segment{
    self.segments = [self.segments arrayByAddingObject:segment];
}
@end
