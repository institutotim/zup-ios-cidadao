//
//  TIRequestManager.h
//  TriedBy
//
//  Created by Bruno Mazzo on 11/23/12.
//  Copyright (c) 2012 #tipis mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TIRequestOperation.h"
#import "TIRequestDelegate.h"

@interface TIRequestManager : NSObject <TIRequestDelegate>

+(TIRequestManager*)defaultManager;
-(BOOL)startRequest:(NSURLRequest*)urlRequest forOperation:(TIRequestOperation*)requestOperation;
-(void)cancelRequestForOperation:(TIRequestOperation*)operation;
@end
