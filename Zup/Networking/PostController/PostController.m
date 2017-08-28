//
//  PostController.m
//  zup
//

#import "PostController.h"
#import "TWAPIManager.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface PostController()

@property(nonatomic, strong) NSString *messageTemp;

@end

@implementation PostController

+ (void)postMessageWithFacebook:(NSString *)message link:(NSString *)link linkTitle:(NSString *)linkTitle linkDesc:(NSString *)linkDesc image:(NSString *)image {
        //NSMutableDictionary* fbPost = [[NSMutableDictionary alloc] initWithObjectsAndKeys:message, @"message", nil];
        if(message == nil)
            message = @"";
        if(link == nil)
            link = @"";
        if(linkTitle == nil)
            linkTitle = @"";
        if(linkDesc == nil)
            linkDesc = @"";
        if(image == nil)
            image = @"";
    
        NSDictionary *fbPost = @{
                             @"message": message,
                             @"link": link,
                             @"name": linkTitle,
                             @"description": linkDesc,
                             @"picture": image
                             };
    
//        [FBRequestConnection startWithGraphPath:@"me/feed" parameters:fbPost HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//             if (!error) {
//                
//             } else {
//                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                     NSArray* arrayPermissions = @[
//                                                   @"publish_actions",
//                                                   @"publish_stream"
//                                                   ];
//                     
//                     dispatch_async(dispatch_get_main_queue(), ^{
//                     });
//                     dispatch_async(dispatch_get_main_queue(), ^{
//                         
//                         if(!FBSession.activeSession.isOpen){
//                             
//                             [FBSession openActiveSessionWithPublishPermissions:arrayPermissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//                                 if (status== FBSessionStateOpen) {
//                                     [PostController postMessageWithFacebook:message link:link linkTitle:linkTitle linkDesc:linkDesc image:image];
//                                 }else {
//                                     [Utilities alertWithMessage:[NSString stringWithFormat:@"Erro ao publicar no Facebook.\n%@", error.localizedDescription]];
//                                 };
//                             }];
//                             
//                         }
//                     });
//                 });
//
//             }
//         }];
}

@end
