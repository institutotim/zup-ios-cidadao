//
//  SolicitacaoPhotoViewController.m
//  Zup
//

#import "SolicitacaoPhotoViewController.h"
#import "SolicitacaoPublicarViewController.h"
#import "UIApplication+name.h"

@interface SolicitacaoPhotoViewController ()

@end

@implementation SolicitacaoPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];

    [self.btNext.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];
    [self.btBack.titleLabel setFont:[Utilities fontOpensSansLightWithSize:14]];

    NSString *titleStr = @"Nova solicitação";
    if ([Utilities isIOS7]) {
        [self setTitle:titleStr];
    } else {
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        [lblTitle setFont:[Utilities fontOpensSansLightWithSize:18]];
        [lblTitle setTextColor:[UIColor blackColor]];
        [lblTitle setText:titleStr];
        [self.navigationController.navigationBar.topItem setTitleView:lblTitle];
    }
    

    [self.lblTitle setFont:[Utilities fontOpensSansBoldWithSize:11]];
    self.arrPhotos = [[NSMutableArray alloc]init];
    [self.btAddPhoto setFontSize:14];

    CGPoint center = self.view.center;

    if ([Utilities isIpad]) {
        center.y += 260;
        CGRect frame = self.btAddPhoto.frame;
        frame.origin.y -= 200;
        [self.btAddPhoto setFrame:frame];
    } else {
        if (![Utilities isIphone4inch]) {
            center.y -= 80;
        }
    }
    [self.btPhoto1 setCenter:center];

}



- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btPhoto:(id)sender {
    
    currentButtonTag = [sender tag];
    
    UIActionSheet *actionSheet = nil;
    
    BOOL canChoosePhoto = [UserDefaults isFeatureEnabled:@"allow_photo_album_access"];
    if (currentButtonTag < self.arrPhotos.count) {
        if(canChoosePhoto)
        {
            actionSheet = [[UIActionSheet alloc]initWithTitle:[UIApplication displayName] delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Escolher foto do álbum", @"Tirar foto", @"Remover foto", nil];
        }
        else
        {
            actionSheet = [[UIActionSheet alloc]initWithTitle:[UIApplication displayName] delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Tirar foto", @"Remover foto", nil];
        }
    } else {
        if(canChoosePhoto)
        {
            actionSheet = [[UIActionSheet alloc]initWithTitle:[UIApplication displayName] delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Escolher foto do álbum", @"Tirar foto", nil];
        }
        else
        {
            actionSheet = [[UIActionSheet alloc]initWithTitle:[UIApplication displayName] delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Tirar foto", nil];
        }
    }
    
    [actionSheet showInView:self.view];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.screenName = @"Adição de Fotos (Novo Relato)";
}

- (IBAction)btNext:(id)sender {
    
    SolicitacaoPublicarViewController *publicarVC = [[SolicitacaoPublicarViewController alloc]initWithNibName:@"SolicitacaoPublicarViewController" bundle:nil];
    
    publicarVC.catStr = self.catStr;
    [self.dictMain setObject:self.arrPhotos forKey:@"photos"];
    publicarVC.dictMain = self.dictMain;
    [self.navigationController pushViewController:publicarVC animated:YES];
}

- (IBAction)btBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Action Sheet Delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    BOOL canChoosePhoto = [UserDefaults isFeatureEnabled:@"allow_photo_album_access"];
    if(!canChoosePhoto)
    {
        // Fake button
        buttonIndex++;
    }
    if (buttonIndex == 2 && currentButtonTag < self.arrPhotos.count) {
        [self.arrPhotos removeObjectAtIndex:currentButtonTag];
        [self performSelector:@selector(manageButtons) withObject:nil afterDelay:0.1];
        return;
    }
    
    CustomUIImagePickerController* controller = [[CustomUIImagePickerController alloc] init];
    controller.delegate = self;
    [controller setAllowsEditing:YES];
    
    if (buttonIndex == 0) {
        [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    } else if (buttonIndex == 1) {
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
       [self presentViewController:controller animated:YES completion:nil]; 
    });

}

-(void)imagePickerController:(UIImagePickerController*)picker
didFinishPickingMediaWithInfo:(NSDictionary*)info {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    UIImage* image = [info objectForKey: UIImagePickerControllerEditedImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (currentButtonTag < self.arrPhotos.count) {
        [self.arrPhotos replaceObjectAtIndex:currentButtonTag withObject:image];
    } else {
        [self.arrPhotos addObject:image];
    }
    
    [self performSelector:@selector(manageButtons) withObject:nil afterDelay:0.1];
}

- (void)manageButtons {
    
    int diffIpad = 220;
    BOOL isHideButton = NO;
    
    for (int i = 0; i < self.arrPhotos.count; i ++) {
        UIImage *img = [self.arrPhotos objectAtIndex:i];
        for (UIButton *bt in self.btArray) {
            if (bt.tag == i) {
                [bt setBackgroundImage:img forState:UIControlStateNormal];
                [bt.imageView setContentMode:UIViewContentModeCenter];
                [bt setImage:[UIImage imageNamed:@"btn_editar-foto_active"] forState:UIControlStateNormal];
                [bt setImage:[UIImage imageNamed:@"btn_editar-foto_normal"] forState:UIControlStateHighlighted];
                [bt setContentEdgeInsets:UIEdgeInsetsMake(-60, 60, 0, 0)];
            }
        }
    }
    
    if (self.arrPhotos.count == 1) {
        CGRect frame = self.btPhoto1.frame;
        frame.origin.x = 68;
        if ([Utilities isIpad])
            frame.origin.x += diffIpad;
            
        [self.btPhoto1 setFrame:frame];
        
        frame.origin.x = 163;
        if ([Utilities isIpad])
            frame.origin.x += diffIpad;
        [self.btPhoto2 setFrame:frame];
        
        [self.btPhoto2 setBackgroundImage:[UIImage imageNamed:@"solicite_foto-frame-1"] forState:UIControlStateNormal];
        [self.btPhoto2 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.btPhoto2 setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [self.btPhoto2 setHidden:NO];
        
        [self.btPhoto3 setHidden:YES];


    } else if (self.arrPhotos.count == 2) {
        CGRect frame = self.btPhoto1.frame;
        frame.origin.x = 20;
        if ([Utilities isIpad])
            frame.origin.x += diffIpad;

        [self.btPhoto1 setFrame:frame];
        
        frame.origin.x = 115;
        if ([Utilities isIpad])
            frame.origin.x += diffIpad;

        [self.btPhoto2 setFrame:frame];
        
        frame.origin.x = 210;
        if ([Utilities isIpad])
            frame.origin.x += diffIpad;

        [self.btPhoto3 setFrame:frame];
        [self.btPhoto3 setBackgroundImage:[UIImage imageNamed:@"solicite_foto-frame-1"] forState:UIControlStateNormal];
        [self.btPhoto3 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.btPhoto3 setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [self.btPhoto3 setHidden:NO];
        

    } else if (self.arrPhotos.count == 3) {
        [self.btPhoto3 setHidden:NO];
        isHideButton = YES;
    } else if (self.arrPhotos.count == 0) {
        CGRect frame = self.btPhoto1.frame;
        frame.origin.x = 115;
        if ([Utilities isIpad])
            frame.origin.x += diffIpad;

        [self.btPhoto1 setFrame:frame];
        
        [self.btPhoto2 setHidden:YES];
        [self.btPhoto3 setHidden:YES];
        
        [self.btPhoto1 setBackgroundImage:[UIImage imageNamed:@"solicite_foto-frame-1"] forState:UIControlStateNormal];
        [self.btPhoto1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.btPhoto1 setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        

    }
    
    int alpha;
    if (isHideButton) alpha = 0;
    else alpha = 1;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.btAddPhoto setAlpha:alpha];
    }];
}

@end
