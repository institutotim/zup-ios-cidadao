//
//  NSString+Utils.m
//  zup
//
//  Created by Patricia Souza on 10/28/15.
//  Copyright © 2015 ntxdev. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

-(NSString*)asEscapedURL {
    NSString *escapedURL = [[self stringByReplacingOccurrencesOfString:@" "  withString:@"+"] removeSpecialChars];
    return escapedURL;
}

-(NSString *)encodeURL
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(NSString*)asCurrency {
    NSLocale *localeBR = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:localeBR];

    NSString *numberString = [self stringByReplacingOccurrencesOfString:@","  withString:@"."];
    
    NSNumber *number = [[NSNumber alloc] initWithDouble:[numberString doubleValue]];
    
    NSString *fomatted = [numberFormatter stringFromNumber:number];
    
    return [fomatted stringByReplacingOccurrencesOfString:@"R$" withString:@"R$ "];
}

-(NSString*)removeSpecialChars{
    NSString *sanitizedText = [[NSString alloc] initWithData:[self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding];
    return sanitizedText;
}

-(NSNumber *)convertStringToNumber:(NSString *)value {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterNoStyle;
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    f.locale = usLocale;
    return [f numberFromString:value];
}

-(NSString *)formatData
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * date = [format dateFromString:self];
    
    NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
    [inFormat setDateFormat:@"dd/MM/yyyy"];
    
    NSString * string = [inFormat stringFromDate:date];
    
    return string;
}

- (BOOL)hasOnlyCharactersInSet:(NSCharacterSet *)set {
    return [self rangeOfCharacterFromSet:set.invertedSet].location == NSNotFound;
}

- (BOOL)hasOnlyCharacters:(NSString *)stringOfCharacters {
    return [self hasOnlyCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:stringOfCharacters]];
}

+ (BOOL) isEmpty:(NSString *) strTemp {
    strTemp = [strTemp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    return (!strTemp.length);
}
@end
