//
//  TIRequest.h
//  TriedBy
//
//  Created by Bruno Mazzo on 11/23/12.
//  Copyright (c) 2012 #tipis mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TIRequestOperation.h"
#import "TIRequestDelegate.h"

@interface TIRequest : NSObject

@property(nonatomic) NSInteger statusCode;

@property(nonatomic, retain) NSMutableData* serverResponse;
@property(nonatomic, retain) NSURLRequest* request;
@property(nonatomic, retain) NSURLConnection* currentConnection;
@property(nonatomic, assign) id<TIRequestDelegate> delegate;
@property(nonatomic) BOOL isLogin;

-(BOOL)startConnection:(NSURLRequest*)request;
-(void)cancel;
+(NSString*)createUrlFrom:(NSString*)url;

@end
