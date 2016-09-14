//
//  TIRequestDelegate.h
//  TriedBy
//
//  Created by Bruno Mazzo on 11/23/12.
//  Copyright (c) 2012 #tipis mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TIRequest;

@protocol TIRequestDelegate <NSObject>

-(void)request:(TIRequest*)request DidFinishWithError:(NSError*)erro data:(NSData*)data;
-(void)request:(TIRequest*)request DidFinishLoadingWithResult:(NSData*)result;

@end