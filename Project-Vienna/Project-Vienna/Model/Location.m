//
//  Location.m
//  Project-Vienna
//
//  Created by asu on 2015-09-22.
//  Copyright © 2015 Rodrigo Moura Gonçalves. All rights reserved.
//

#import "Location.h"
#import "City.h"
#import "User.h"

@interface Location()

@end

@implementation Location

@synthesize currentDistanceFromUser;

-(CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D result;
    result.latitude = self.latitude;
    result.longitude = self.longitude;
    
    return result;
}


-(NSString*)title{
    return self.name;
}

-(NSString*)subtitle{
    return [NSString stringWithFormat:@"Distance: %.f meters",
            self.currentDistanceFromUser];
}


@end
