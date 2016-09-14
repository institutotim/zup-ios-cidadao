//
//  NSString+Utils.h
//  zup
//
//  Created by Patricia Souza on 10/28/15.
//  Copyright © 2015 ntxdev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

-(NSString *)asEscapedURL;
-(NSString *)asCurrency;
-(NSString *)removeSpecialChars;
-(NSString *)encodeURL;
-(NSString *)formatData;
-(BOOL)hasOnlyCharactersInSet:(NSCharacterSet *)set;
-(BOOL)hasOnlyCharacters:(NSString *)stringOfCharacters;
-(NSNumber *)convertStringToNumber:(NSString *)value;
+ (BOOL) isEmpty:(NSString *) strTemp;

@end
