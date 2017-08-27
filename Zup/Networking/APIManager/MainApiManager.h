//
//  MainApiManager.h
//  zup
//
//  Created by Patricia Souza on 10/28/15.
//  Copyright © 2015 ntxdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiNetworkingManager.h"

typedef void (^GetMainSuccessBlock)(id response);
typedef void (^GetMainFailureBlock)(NSString *errorMsg);

@interface MainApiManager : ApiNetworkingManager

+ (instancetype)sharedManager;

- (void)getInventoryCategories:(GetMainSuccessBlock)success
                       failure:(GetMainFailureBlock)failure;

@end
