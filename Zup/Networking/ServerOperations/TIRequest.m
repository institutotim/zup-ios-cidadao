//
//  TIRequest.m
//  TriedBy
//
//  Created by Bruno Mazzo on 11/23/12.
//  Copyright (c) 2012 #tipis mobile. All rights reserved.
//

#import "TIRequest.h"
#import "TIRequestManager.h"

@interface TIRequest ()

@property int failCount;

@end

@implementation TIRequest

-(BOOL)startConnection:(NSURLRequest*)request{
    self.failCount = 0;
    self.request = request;
    return [self sendRequest];
}

- (BOOL) sendRequest
{
    self.currentConnection = [[[NSURLConnection alloc]initWithRequest:self.request delegate:self startImmediately:YES]autorelease];
    
    if (self.currentConnection) {
        self.serverResponse = [NSMutableData data];
        return YES;
    } else {
        return NO;
    }
}

-(void)cancel{
    [self.currentConnection cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [self.serverResponse setLength:0];
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    self.statusCode = [httpResponse statusCode];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [self.serverResponse appendData:data];
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // increment the failure count
    self.failCount++;
    
    // inform the user
    NSLog(@"Connection failed %i times! Error - %@ %@",
          self.failCount, [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    // send error trigger if failed too many times
    if(self.failCount == 3)
    {
        
        // release the connection, and the data object
        
        // receivedData is declared as a method instance elsewhere
        
        if ([self.delegate respondsToSelector:@selector(request:DidFinishWithError:data:)]) {
            [self.delegate request:self DidFinishWithError:error data:self.serverResponse];
        }
        
        return;
    }
    else
    {
        // try again
        [self sendRequest];
    }
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"STATUS_CODE: %i", self.statusCode);
    //if (self.statusCode == 400 || self.statusCode == 404) {
    if(self.statusCode == 401 && !self.isLogin)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APISessionExpired" object:nil];
        return;
    }
    
    if (self.statusCode >= 400 && self.statusCode <= 499) {
        NSError* error = [NSError errorWithDomain:@"HTTP Error" code:self.statusCode userInfo:nil];
        if ([self.delegate respondsToSelector:@selector(request:DidFinishWithError:data:)]) {
            [self.delegate request:self DidFinishWithError:error data:self.serverResponse];
        }
        
        NSLog(@"%@ yielded an error", [connection.originalRequest.URL absoluteString]);
        if(self.serverResponse != nil)
        {
            NSString* string = [[NSString alloc] initWithData:self.serverResponse encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@", string);
        }
        
    }else if ([self.delegate respondsToSelector:@selector(request:DidFinishLoadingWithResult:)]) {
        [self.delegate request:self DidFinishLoadingWithResult:self.serverResponse];
    }
    
    // release the connection, and the data object
    [self clearMemory];
}

-(NSURLRequest *)connection:(NSURLConnection *)connection
            willSendRequest:(NSURLRequest *)request
           redirectResponse:(NSURLResponse *)redirectResponse
{
    if (redirectResponse) {
        return request;
    } else {
        return request;
    }
}

-(void)clearMemory{
    self.currentConnection = nil;
    self.serverResponse = nil;
}

+(NSString*)createUrlFrom:(NSString*)url{
    NSString* urlFormString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)url,
                                                                                  NULL,
                                                                                  (CFStringRef)@" !*'();@&=+$,?%#[]{}<>",
                                                                                  kCFStringEncodingUTF8 );
    return [urlFormString autorelease];
}
@end
