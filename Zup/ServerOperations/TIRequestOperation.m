//
//  TIRequestOperation.m
//  TriedBy
//
//  Created by Bruno Mazzo on 11/23/12.
//  Copyright (c) 2012 #tipis mobile. All rights reserved.
//

#import "TIRequestOperation.h"
#import "TIRequestManager.h"

@implementation TIRequestOperation

-(void)CancelRequest{
    [[TIRequestManager defaultManager] cancelRequestForOperation:self];
}

-(BOOL)StartRequest:(NSURLRequest*)request{
    NSMutableURLRequest* newreq = [request mutableCopy];
    
    newreq.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    request = newreq;
    
    if ([UserDefaults getToken] != nil)
    {
        NSMutableURLRequest* newreq = [request mutableCopy];
        [newreq setValue:[UserDefaults getToken] forHTTPHeaderField:@"X-App-Token"];
        
        request = newreq;
    }
    return [[TIRequestManager defaultManager]startRequest:request forOperation:self];
}

-(void)dealloc{
    [_target release];
    [super dealloc];
}

@end
