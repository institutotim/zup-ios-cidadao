//
//  UIApplication+name.m
//  zup
//
//  Created by Igor Lira on 5/10/15.
//  Copyright (c) 2015 ntxdev. All rights reserved.
//

#import "UIApplication+name.h"

@implementation UIApplication (name)

+ (NSString*) displayName
{
    NSBundle* bundle = [NSBundle mainBundle];
    NSDictionary* infoDict = [bundle infoDictionary];
    
    return [infoDict valueForKey:@"CFBundleDisplayName"];
}

@end
