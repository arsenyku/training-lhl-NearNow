//
//  NSURL+Download.h
//  Rotten Mangoes
//
//  Created by asu on 2015-09-14.
//  Copyright (c) 2015 asu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSession (DownloadFromAddress)
+(NSURLSessionTask*)downloadFromAddress:(NSString*)address
                completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
@end
