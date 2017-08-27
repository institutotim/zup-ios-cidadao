//
//  ApiNetworkingManager.h
//  zup
//
//  Created by Patricia Souza on 10/28/15.
//  Copyright © 2015 ntxdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^SuccessBlock)(NSURLSessionTask *task, id responseObject);
typedef void (^FailureBlock)(NSURLSessionTask *task, NSError *error, NSString *customErrorMessage);

@interface ApiNetworkingManager : NSObject

- (void)setup;
- (NSString*) baseAPIUrl;
- (void)addHeader:(NSString *)value forKey:(NSString *)key;
- (void)setupCustomHeaders;

- (void)GET:(NSString*)url params:(NSDictionary*)params success:(SuccessBlock)success
    failure:(FailureBlock)failure;

- (void)POST:(NSString*)url params:(NSDictionary*)params success:(SuccessBlock)success
     failure:(FailureBlock)failure;

- (void)PUT:(NSString*)url params:(NSDictionary*)params success:(SuccessBlock)success
    failure:(FailureBlock)failure;

- (void)DELETE:(NSString*)url params:(NSDictionary*)params success:(SuccessBlock)success
       failure:(FailureBlock)failure;

+ (NSString*) baseWebUrl;

@end
