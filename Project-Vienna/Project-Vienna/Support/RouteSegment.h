//
//  RouteSegment.h
//  Project-Vienna
//
//  Created by asu on 2015-09-25.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteSegment : NSObject
@property (nonatomic) NSString * startLatitude;
@property (nonatomic) NSString * startLongitude;
@property (nonatomic) NSString * endLatitude;
@property (nonatomic) NSString * endLongitude;
@end
