//
//  NSString+BFExtension.m
//  FGClient
//
//  Created by Lucifer.YU on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+BFExtension.h"
#import <CommonCrypto/CommonDigest.h>

static const char BASE64_CHAR_TABLE[64] = {
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
	'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
	'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
	'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation NSString (BFExtension)

+ (NSString*) base64StringFromData: (NSData*)data {
	if (data == nil)
		return nil;

	int length = (int)[data length];

	const unsigned char *bytes = [data bytes];
	NSMutableString *result = [NSMutableString stringWithCapacity:length];
	unsigned long ixtext = 0;
	long ctremaining = 0;
	unsigned char bufIn[3], bufOut[4];
	short i = 0;
	short charsonline = 0, ctcopy = 0;
	unsigned long ix = 0;
	while( YES ) {
		ctremaining = length - ixtext;
		if( ctremaining <= 0 ) break;
		for( i = 0; i < 3; i++ ) {
			ix = ixtext + i;
			if( ix < length ) bufIn[i] = bytes[ix];
			else bufIn [i] = 0;
		}
		bufOut [0] = (bufIn [0] & 0xFC) >> 2;
		bufOut [1] = ((bufIn [0] & 0x03) << 4) | ((bufIn [1] & 0xF0) >> 4);
		bufOut [2] = ((bufIn [1] & 0x0F) << 2) | ((bufIn [2] & 0xC0) >> 6);
		bufOut [3] = bufIn [2] & 0x3F;
		ctcopy = 4;
		switch( ctremaining ) {
			case 1:
			ctcopy = 2;
			break;
			case 2:
			ctcopy = 3;
			break;
		}
		for( i = 0; i < ctcopy; i++ )
			[result appendFormat:@"%c", BASE64_CHAR_TABLE[bufOut[i]]];
		for( i = ctcopy; i < 4; i++ )
			[result appendString:@"="];
		ixtext += 3;
		charsonline += 4;
	}
	return result;
}

//+ (id)stringWithFormat:(NSString *)format array:(NSArray*) arguments {
//    char *argList = (char *)malloc(sizeof(NSString *) * [arguments count]);
//    [arguments getObjects:(id *)argList];
//    NSString* result = [[NSString alloc] initWithFormat:format arguments:argList];
//    free(argList);
//    return result;
//}

+ (id)stringWithDate:(NSDate*)date format:(NSString *)format {
    assert(format != nil);
    if (date == nil)
        return nil;
	NSDateFormatter* df = [[NSDateFormatter alloc] init];
	[df setDateFormat:format];
	NSString* result = [[NSString alloc] initWithFormat:@"%@", [df stringFromDate:date]];
	return result;
}

- (int) indexOf:(NSString*)str {
	NSRange range = [self rangeOfString:str];
	return (range.length > 0) ? (int)range.location : -1;
}

- (BOOL) equals:(NSString*)str {
    if (str == nil)
        return NO;
    return ([self compare:str] == NSOrderedSame);
}

- (NSString *)toMD5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
