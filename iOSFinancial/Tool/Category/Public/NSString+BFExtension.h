//
//  NSString+BFExtension.h
//  FGClient
//
//  Created by Lucifer.YU on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSString.h>

@interface NSString (BFExtension)

+ (NSString *) base64StringFromData:(NSData *)data;

+ (id)stringWithDate:(NSDate*)date format:(NSString *)format;

- (int) indexOf:(NSString*)str;

- (BOOL) equals:(NSString*)str;

- (NSString *)toMD5;

@end
