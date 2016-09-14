//
//  ComentarioViewController.m
//  zup
//

#import "ComentarioViewController.h"

@interface ComentarioViewController ()

@end

@implementation ComentarioViewController

- (id)initWithComentario:(NSDictionary*)_comentario;
{
    self = [super initWithNibName:@"ComentarioViewController" bundle:nil];
    if(self)
    {
        self->comentario = _comentario;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.translatesAutoresizingMaskIntoConstraints = NO;
    //[self.view removeConstraints:self.view.constraints];
    
    self.lblText.text = [self->comentario valueForKey:@"message"];
    self.lblText.numberOfLines = 0;
    [self.lblText sizeToFit];
    
    //CGRect frame = self.lblDate.frame;
    //frame.origin.y = self.lblText.frame.origin.y + self.lblText.frame.size.height + 100;
    //self.lblDate.frame = frame;
    
    //NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:100];
    /*NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.lblDate attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:constraint];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
