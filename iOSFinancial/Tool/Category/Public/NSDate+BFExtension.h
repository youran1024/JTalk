//
//  NSDate+BFExtension.h
//  Test2
//
//  Created by Lucifer YU on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate(BFExtension)

+ (NSDate*)dateWithString:(NSString*)string format:(NSString*)format;

- (NSString*)labelString;
- (NSString *)weekString;

@end
