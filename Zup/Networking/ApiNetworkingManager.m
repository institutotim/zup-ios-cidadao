//
//  ApiNetworkingManager.m
//  zup

#import "ApiNetworkingManager.h"
#import "AFNetworkActivityLogger.h"
#import "NSString+Utils.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <Crashlytics/Crashlytics.h>
#import "InstanceConfiguration.h"


@interface ApiNetworkingManager (){
    NSURL *baseUrl;
    AFHTTPRequestOperationManager *manager;
}
@end

static ApiNetworkingManager *instance;

@implementation ApiNetworkingManager

- (void)setup{
    [self setupRequestOperationManager];
    [self setupRequestSerializers];
    [self setupCustomHeaders];
    
#ifdef DEBUG
    [AFNetworkActivityLogger sharedLogger].level = AFLoggerLevelInfo;
    [[AFNetworkActivityLogger sharedLogger] startLogging];
#endif
}

- (void)addHeader:(NSString *)value forKey:(NSString *)key {
    [manager.requestSerializer setValue:value  forHTTPHeaderField:key];
}

- (void)GET:(NSString*)url params:(NSDictionary*)params success:(SuccessBlock)success
    failure:(FailureBlock)failure {
    CLS_LOG(@"Request URL: %@",[url asEscapedURL]);
    CLS_LOG(@"Request PARAMS: %@",params);
    [manager GET:[url asEscapedURL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, operation.responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailure:operation error:error failure:failure];
    }];
}

- (void)POST:(NSString*)url params:(NSDictionary*)params success:(SuccessBlock)success
     failure:(FailureBlock)failure {
    CLS_LOG(@"Request URL: %@",[url asEscapedURL]);
    CLS_LOG(@"Request PARAMS: %@",params);
    [manager POST:[url asEscapedURL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, operation.responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailure:operation error:error failure:failure];
    }];
}

- (void)PUT:(NSString*)url params:(NSDictionary*)params success:(SuccessBlock)success
    failure:(FailureBlock)failure {
    CLS_LOG(@"Request URL: %@",[url asEscapedURL]);
    CLS_LOG(@"Request PARAMS: %@",params);
    [manager PUT:[url asEscapedURL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, operation.responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailure:operation error:error failure:failure];
    }];
}

- (void)DELETE:(NSString*)url params:(NSDictionary*)params success:(SuccessBlock)success
       failure:(FailureBlock)failure {
    CLS_LOG(@"Request URL: %@",[url asEscapedURL]);
    CLS_LOG(@"Request PARAMS: %@",params);
    [manager DELETE:[url asEscapedURL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, operation.responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleFailure:operation error:error failure:failure];
    }];
}

#pragma mark - Private Methods

- (void)handleFailure:(AFHTTPRequestOperation *)operation error:(NSError*)error failure:(FailureBlock)failure{
    NSInteger statusCode = operation.response.statusCode;
    CLS_LOG(@"HTTP %ld - response %@ - ERROR: %@", statusCode ,operation.response.URL, error );
    
    failure(operation,error,operation.responseString);
}

- (void)setupRequestOperationManager{
    AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
    NSURL *baseURL = [NSURL URLWithString: BASE_API_URL];
    manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setAllowInvalidCertificates:YES];
    [policy setValidatesDomainName:NO];
    manager.securityPolicy = policy;
}

- (void)configureReachability {
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [operationQueue setSuspended:NO];
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
}

- (void)setupRequestSerializers {
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
}

- (void)setupCustomHeaders {
    [manager.requestSerializer setValue:@"application/json;charset = UTF-8" forHTTPHeaderField:@"Accept"];
}

-(NSString*) baseAPIUrl{
    return BASE_API_URL;
}

+ (NSString *)baseWebUrl {
    return BASE_WEB_URL;
}


@end
