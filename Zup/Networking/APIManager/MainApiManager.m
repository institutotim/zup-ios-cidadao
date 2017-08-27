//
//  MainApiManager.m
//  zup
//
//  Created by Patricia Souza on 10/28/15.
//  Copyright © 2015 ntxdev. All rights reserved.
//

#import "MainApiManager.h"
#import "NetworkingConstants.h"

@implementation MainApiManager

+ (instancetype)sharedManager {
    static MainApiManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)getInventoryCategories:(GetMainSuccessBlock)success
                       failure:(GetMainFailureBlock)fail {
    
    NSString *finalUrl = [NSString stringWithFormat:@"%@%@", [self baseAPIUrl], URLgetInventoryCategories];
    
    [super GET:finalUrl params:nil success:^(NSURLSessionTask *task, id responseObject) {
           success(responseObject);
       } failure:^(NSURLSessionTask *task, NSError *error, NSString *customErrorMessage) {
           fail(customErrorMessage);
       }];
}

@end
