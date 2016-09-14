//
//  ComentarioViewController.h
//  zup
//

#import <UIKit/UIKit.h>

@interface ComentarioViewController : UIViewController
{
    NSDictionary* comentario;
}

@property (nonatomic, retain) IBOutlet UILabel* lblText;
@property (nonatomic, retain) IBOutlet UILabel* lblDate;

- (id)initWithComentario:(NSDictionary*)comentario;

@end
