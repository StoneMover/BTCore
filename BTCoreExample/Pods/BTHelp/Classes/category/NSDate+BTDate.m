//
//  NSDate+BTDate.m
//  live
//
//  Created by stonemover on 2019/5/8.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "NSDate+BTDate.h"

@implementation NSDate (BTDate)

- (NSString*)bt_year{
    return [self bt_dateStr:@"YYYY"];
}

- (NSString*)bt_month{
    return [self bt_dateStr:@"MM"];
}

- (NSString*)bt_day{
    return [self bt_dateStr:@"dd"];
}

- (NSString*)bt_hour{
    return [self bt_dateStr:@"HH"];
}

- (NSString*)bt_minute{
    return [self bt_dateStr:@"mm"];
}

- (NSString*)bt_second{
    return [self bt_dateStr:@"ss"];
}

- (NSString*)bt_weekDay{
    return [self bt_dateStr:@"EEEE"];
}

- (NSInteger)bt_weekDayNum{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:self];
    return [comps weekday] - 1;
}

- (NSString*)bt_weekDayNumStrWithHead:(NSString*)head{
    NSInteger index = [self bt_weekDayNum];
    NSArray * weekDayStrArray = nil;
    if ([head isEqualToString:@"周"]) {
        weekDayStrArray =  @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    }else{
        weekDayStrArray =  @[@"天",@"一",@"二",@"三",@"四",@"五",@"六"];
    }
    NSString * weekStr = weekDayStrArray[index];
    return [NSString stringWithFormat:@"%@%@",head,weekStr];
}

- (NSInteger)bt_calculateAge:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    NSInteger age =[self bt_year].integerValue-year;
    if (month>[self bt_month].integerValue) {
        age--;
    }else if (month==[self bt_month].integerValue){
        if (day>[self bt_day].integerValue) {
            age--;
        }
    }
    
    return age;
}

- (BOOL)bt_isFutureTime{
    NSDate *localeDate = [NSDate bt_initLocalDate];
    if (self.timeIntervalSince1970 > localeDate.timeIntervalSince1970) {
        return YES;
    }
    return NO;
}


- (NSString*)bt_dateFromNowStr{
    NSDate * d= self;
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate * dat = [NSDate bt_initLocalDate];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=now-late;
    int second=cha;
    int minute=second/60;
    int hour=minute/60;
    int day=hour/24;
    if (day!=0) {
        if (day>30) {
            return [NSString stringWithFormat:@"%d月前",day/30];
        }
        
        if (day>365) {
            return [NSString stringWithFormat:@"%d年前",day/365];
        }
        
        return [NSString stringWithFormat:@"%d天前",day];
    }
    if (hour!=0) {
        return [NSString stringWithFormat:@"%d小时前",hour];
    }
    if (minute!=0) {
        return [NSString stringWithFormat:@"%d分钟前",minute];
    }
    return @"刚刚";
}

- (NSString*)bt_dateStr:(NSString*)formater{
    NSDateFormatter * formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    formatter.dateFormat=formater;
    NSString * str = [formatter stringFromDate:self];
    return str;
}

- (BOOL)bt_isSameMonthToDate:(NSDate*)date{
    NSString * strSelf = [self bt_dateStr:@"YYYY-MM"];
    NSString * strDate = [date bt_dateStr:@"YYYY-MM"];
    return [strSelf isEqualToString:strDate];
}

- (BOOL)bt_isSameDayToDate:(NSDate*)date{
    NSString * strSelf = [self bt_dateStr:@"YYYY-MM-dd"];
    NSString * strDate = [date bt_dateStr:@"YYYY-MM-dd"];
    return [strSelf isEqualToString:strDate];
}

- (BOOL)bt_isSameHourToDate:(NSDate*)date{
    NSString * strSelf = [self bt_dateStr:@"YYYY-MM-dd HH"];
    NSString * strDate = [date bt_dateStr:@"YYYY-MM-dd HH"];
    return [strSelf isEqualToString:strDate];
}

- (BOOL)bt_isSameMinuteToDate:(NSDate*)date{
    NSString * strSelf = [self bt_dateStr:@"YYYY-MM-dd HH:mm"];
    NSString * strDate = [date bt_dateStr:@"YYYY-MM-dd HH:mm"];
    return [strSelf isEqualToString:strDate];
}

+ (instancetype)bt_initLocalDate{
    NSDate * date = [[NSDate alloc] init];
    NSDate * localeDate = [date dateByAddingTimeInterval:[self bt_timeZoneSeconods]];
    return localeDate;
}

+ (NSDate*)bt_dateYMD:(NSString*)dateStr{
    return [self bt_dateFromStr:dateStr formatter:@"YYYY-MM-dd"];
}



+ (NSDate*)bt_dateYMDHMS:(NSString*)dateStr{
    return [self bt_dateFromStr:dateStr formatter:@"YYYY-MM-dd HH:mm:ss"];
}


+ (NSDate*)bt_dateYMDHM:(NSString*)dateStr{
    return [self bt_dateFromStr:dateStr formatter:@"YYYY-MM-dd HH:mm"];
}

+ (NSDate*)bt_dateFromStr:(NSString*)dateStr formatter:(NSString*)formatterStr{
    NSDateFormatter * formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat=formatterStr;
    NSDate * date = [formatter dateFromString:dateStr];
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate * localeDate = [date dateByAddingTimeInterval: interval];
    return localeDate;
}


+ (NSInteger)bt_timeZoneSeconods{
    NSDate * date = [[NSDate alloc] init];
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return interval;
}

- (NSTimeInterval)bt_timeIntervalSince1970{
    return self.timeIntervalSince1970 - [NSDate bt_timeZoneSeconods];
}

@end
