//
//  NSDate+BFExtension.m
//  Test2
//
//  Created by Lucifer YU on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDate+BFExtension.h"
#import "NSString+BFExtension.h"

@implementation NSDate(BFExtension)

- (NSString *)weekString {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
    switch (dateComponents.weekday) {
        case 1: {
            return @"星期天";
            return NSLocalizedString(@"sunday", @"");
        }
            break;
            
        case 2: {
            return @"星期一";
            return NSLocalizedString(@"monday", @"");
        }
            break;
            
        case 3: {
            return @"星期二";
            return NSLocalizedString(@"tuesday", @"");
        }
            break;
            
        case 4: {
            return @"星期三";
            return NSLocalizedString(@"wednesday", @"");
        }
            break;
            
        case 5: {
            return @"星期四";
            return NSLocalizedString(@"thursday", @"");
        }
            break;
            
        case 6: {
            return @"星期五";
            return NSLocalizedString(@"friday", @"");
        }
            break;
            
        case 7: {
            return @"星期六";
            return NSLocalizedString(@"saturday", @"");
        }
            break;
            
        default:
            break;
    }
    
    return @"";
}

+ (NSDate*)dateWithString:(NSString*)string format:(NSString*)format {
    
    if ([string isEqual:[NSNull null]])
        return nil;
    
	if (format == nil)
		format = @"yyyy-MM-dd HH:mm:ss";

	NSDateFormatter *df = [[NSDateFormatter alloc] init];
    /*
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [df setTimeZone:timeZone];
     */
	[df setDateFormat:format];
	NSDate* result = [df dateFromString:string];
	return result;
}

- (NSString*)labelString {
    
	const int MINUTE	= 60;
	const int HOUR		= 60 * 60;
    const int JUST      = 3 * 60;
	
	NSString* result = @"未知时间";
	if (self != nil) {

        BOOL isThisYear = [self isThisYear];
        BOOL isToday = [self isToday];
		
        if (!isThisYear) {
            return [NSString stringWithDate:self format:@"yyyy-MM-dd"];
            
        }else if (!isToday) {
            if (![self isYestoday]) {
                return [NSString stringWithDate:self format:@"MM-dd HH:mm"];
                
            }else{
                result = [NSString stringWithDate:self format:@"昨天 HH:mm"];
            }
        
        } else{
            
            NSTimeInterval time1970 = [self timeIntervalSince1970];
            NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
            int timeInterval = now - time1970;
            
            if (timeInterval > HOUR) {
                result = [NSString stringWithFormat:@"%d小时前", timeInterval / HOUR];
                
            } else if (timeInterval > JUST) {
                result = [NSString stringWithFormat:@"%d分钟前", timeInterval / MINUTE];
                
            }else {
                result = @"刚刚";
            }
        }
    }
    
	return result;
}

- (BOOL)isYestoday
{
    const int DAY		= 24 * 60 * 60;
    
    NSString *thisDayZero = [NSString stringWithDate:[NSDate date] format:@"yyyy-MM-dd"];
    NSDate *thisDay = [NSDate dateWithString:thisDayZero format:@"yyyy-MM-dd"];
    
    NSTimeInterval time1970 = [self timeIntervalSince1970];
    NSTimeInterval now = [thisDay timeIntervalSince1970];
    NSTimeInterval timeInterval = now - time1970;
    
    return timeInterval < DAY;
}

- (BOOL)isToday
{
    NSString *oldDay = [NSString stringWithDate:self format:@"yyyy-MM-dd"];
    NSString *thisDay = [NSString stringWithDate:[NSDate date] format:@"yyyy-MM-dd"];
    
    return [oldDay isEqualToString:thisDay];
}

- (BOOL)isThisYear
{
    NSString *oldYear = [NSString stringWithDate:self format:@"yyyy"];
    NSString *thisYear = [NSString stringWithDate:[NSDate date] format:@"yyyy"];
    
    return [oldYear isEqualToString:thisYear];
}

@end
