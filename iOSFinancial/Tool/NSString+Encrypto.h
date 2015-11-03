//
//  NSString+Encrypto.h
//  JTalk
//
//  Created by Mr.Yang on 15/10/30.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypto)

- (NSString *)toMd5;
- (NSString *)toSha1;

@end
