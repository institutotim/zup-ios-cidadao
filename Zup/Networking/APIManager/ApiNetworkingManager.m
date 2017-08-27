//
//  ApiNetworkingManager.m
//  zup

#import "ApiNetworkingManager.h"
#import "AFNetworkActivityLogger.h"
#import "NSString+Utils.h"
#import "InstanceConfiguration.h"

#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <Crashlytics/Crashlytics.h>

@interface ApiNetworkingManager()

@property(nonatomic, strong) NSURL *baseUrl;
@property(nonatomic, strong) AFHTTPSessionManager *manager;

@end

static ApiNetworkingManager *instance;

@implementation ApiNetworkingManager

- (void)setup{
    [self setupRequestOperationManager];
    [self setupRequestSerializers];
    [self setupCustomHeaders];
    
#ifdef DEBUG
//    [[AFNetworkActivityLogger sharedLogger] addLogger:];
    [[AFNetworkActivityLogger sharedLogger] startLogging];
#endif
}

- (void)addHeader:(NSString *)value forKey:(NSString *)key {
    [self.manager.requestSerializer setValue:value  forHTTPHeaderField:key];
}

- (void)GET:(NSString*)url params:(NSDictionary*)params success:(SuccessBlock)success
    failure:(FailureBlock)failure {
    CLS_LOG(@"Request URL: %@",[url asEscapedURL]);
    CLS_LOG(@"Request PARAMS: %@",params);
    [self.manager GET:[url asEscapedURL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailure:task error:error failure:failure];
    }];
}

- (void)POST:(NSString*)url params:(NSDictionary*)params success:(SuccessBlock)success
     failure:(FailureBlock)failure {
    CLS_LOG(@"Request URL: %@",[url asEscapedURL]);
    CLS_LOG(@"Request PARAMS: %@",params);
    [self.manager POST:[url asEscapedURL] parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [self handleFailure:task error:error failure:failure];
    }];
}

- (void)PUT:(NSString*)url params:(NSDictionary*)params success:(SuccessBlock)success
    failure:(FailureBlock)failure {
    CLS_LOG(@"Request URL: %@",[url asEscapedURL]);
    CLS_LOG(@"Request PARAMS: %@",params);
    [self.manager PUT:[url asEscapedURL] parameters:params success:^(NSURLSessionTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [self handleFailure:task error:error failure:failure];
    }];
}

- (void)DELETE:(NSString*)url params:(NSDictionary*)params success:(SuccessBlock)success
       failure:(FailureBlock)failure {
    CLS_LOG(@"Request URL: %@",[url asEscapedURL]);
    CLS_LOG(@"Request PARAMS: %@",params);
    [self.manager DELETE:[url asEscapedURL] parameters:params success:^(NSURLSessionTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [self handleFailure:task error:error failure:failure];
    }];
}

#pragma mark - Private Methods

- (void)handleFailure:(NSURLSessionTask *)task error:(NSError *)error failure:(FailureBlock)failure {
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)task.response;
    NSInteger statusCode = resp.statusCode;
    CLS_LOG(@"HTTP %ld - response %@ - ERROR: %@", statusCode, task.response.URL, error);
    
    failure(task, error, @"");
}

- (void)setupRequestOperationManager {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    NSURL *baseURL = [NSURL URLWithString: BASE_API_URL];
    self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setAllowInvalidCertificates:YES];
    [policy setValidatesDomainName:NO];
    self.manager.securityPolicy = policy;
}

- (void)configureReachability {
    NSOperationQueue *operationQueue = self.manager.operationQueue;
    [self.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
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
    self.manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes = [self.manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
}

- (void)setupCustomHeaders {
    [self.manager.requestSerializer setValue:@"application/json;charset = UTF-8" forHTTPHeaderField:@"Accept"];
}

-(NSString*) baseAPIUrl {
    return BASE_API_URL;
}

+ (NSString *)baseWebUrl {
    return BASE_WEB_URL;
}

@end
