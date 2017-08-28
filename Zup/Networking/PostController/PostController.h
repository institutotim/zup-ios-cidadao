//
//  PostController.h
//  zup
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import "TWAPIManager.h"

@interface PostController : NSObject

+ (void)postMessageWithFacebook:(NSString *)message link:(NSString *)link linkTitle:(NSString *)linkTitle linkDesc:(NSString *)linkDesc image:(NSString *)image;

@end
