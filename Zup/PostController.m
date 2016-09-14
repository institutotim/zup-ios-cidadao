//
//  PostController.m
//  zup
//

#import "PostController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TWAPIManager.h"


NSString *messageTemp;

@implementation PostController

+ (void)postMessageWithFacebook:(NSString*)message link:(NSString*)link linkTitle:(NSString*)linkTitle linkDesc:(NSString*)linkDesc image:(NSString *)image {
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
        NSDictionary* fbPost = @{
                             @"message": message,
                             @"link": link,
                             @"name": linkTitle,
                             @"description": linkDesc,
                             @"picture": image
                             };
        [FBRequestConnection startWithGraphPath:@"me/feed" parameters:fbPost HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
         {
             if (!error) {
                
             } else {
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                     NSArray* arrayPermissions = @[
                                                   @"publish_actions",
                                                   @"publish_stream"
                                                   ];
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                     });
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         if(!FBSession.activeSession.isOpen){
                             
                             [FBSession openActiveSessionWithPublishPermissions:arrayPermissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                 if (status== FBSessionStateOpen) {
                                     [PostController postMessageWithFacebook:message link:link linkTitle:linkTitle linkDesc:linkDesc image:image];
                                 }else {
                                     [Utilities alertWithMessage:[NSString stringWithFormat:@"Erro ao publicar no Facebook.\n%@", error.localizedDescription]];
                                 };
                             }];
                             
                         }
                     });
                 });

             }
         }];
}

#pragma mark - G+

- (void)postMessageWithGoogle:(NSString*)message {
    
    messageTemp = message;
   
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    // You previously set kClientID in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,kGTLAuthScopePlusMe,
                     nil]; //// defined in GTLPlusConstants.h
    
    [signIn setDelegate:self];
    [signIn authenticate];
}


- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    
    if (error) {
        
        [Utilities alertWithMessage:[NSString stringWithFormat:@"Erro ao publicar no Google Plus.\n%@", error.localizedDescription]];
    }
    
    else{
        
        id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
        
        // This line will fill out the title, description, and thumbnail of the item
        // you're sharing based on the URL you included.
        [shareBuilder setURLToShare:[NSURL URLWithString:@"http://www.zup.com.br"]];//
        
        [shareBuilder setPrefillText:messageTemp];
        // if somebody opens the link on a supported mobile device
        //    [shareBuilder setContentDeepLinkID:@"rest=1234567"];
        
        [shareBuilder open];

        
    }
}

@end
