//
//  ListExploreViewController.m
//  Zup
//

#import "ListExploreViewController.h"
#import "CellMinhaConta.h"
#import "CustomMap.h"
#import "CellGaleriaInventario.h"
#import "ImageCache.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XL/XLMediaZoom.h"

@interface ListExploreViewController ()

@end

@implementation ListExploreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.imageZooms = [[NSMutableDictionary alloc] init];
        self->showingImage = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    
    [self.lblNoSolicits setHidden:YES];

    [self.table registerNib:[UINib nibWithNibName:@"CellMinhaConta" bundle:nil] forCellReuseIdentifier:@"CellConta"];
    [self.table registerNib:[UINib nibWithNibName:@"CellGaleriaInventario" bundle:nil] forCellReuseIdentifier:@"CellGaleria"];
    
    [super viewDidLoad];
    
    for (UIButton *bt in self.arrBt) {
        [bt.titleLabel setFont:[Utilities fontOpensSansWithSize:14]];
    }
    
    [self setTitle:self.strTitle];
    
    [self.navigationItem setHidesBackButton:YES];
    
    if ([Utilities isIpad]) {
        CGRect tableFrame = self.table.frame;
        tableFrame.origin.x = 50;
        tableFrame.origin.y = 50;
        tableFrame.size.height +=10;
        [self.table setFrame:tableFrame];
    }
    
    
    if (!self.isColeta) {
        NSString *nibName = nil;
        if ([Utilities isIpad]) {
            nibName = @"PerfilDetailViewController_iPad";
        } else {
            nibName = @"PerfilDetailViewController";
        }
        
        detailView = [[PerfilDetailViewController alloc]initWithNibName:nibName bundle:nil];
        detailView.isFromFeed = YES;
        detailView.dictMain = self.dictMain;
        
        if ([Utilities isIpad]) {
            [detailView.view setFrame:self.view.frame];
            
        } else {
            [detailView.view setFrame:self.table.frame];
            
        }
        [self.view addSubview:detailView.view];
        
        for (UIButton *newBt in self.arrBt) {
            if (self.btInfo == newBt) {
                [newBt setSelected:YES];
            } else
                [newBt setSelected:NO];
        }
        
    }
    
    [detailView.view setHidden:YES];
    
    [self getDetails];
    //    [self removeLabelSolcitations];
    
    btCancel = [[CustomButton alloc] initWithFrame:CGRectMake(0, 5, 56, 35)];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_voltar_normal-1"] forState:UIControlStateNormal];
    [btCancel setBackgroundImage:[UIImage imageNamed:@"menubar_btn_voltar_active-1"] forState:UIControlStateHighlighted];
    [btCancel setFontSize:14];
    [btCancel setTitle:@"Voltar" forState:UIControlStateNormal];
    [btCancel addTarget:self action:@selector(btBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* spacer = [[UIBarButtonItem alloc] init];
    spacer.width = -10;
    
    UIBarButtonItem* filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:btCancel];
    self.navigationItem.leftBarButtonItems = @[spacer, filterBarButton];
}

- (void)removeLabelSolcitations {
    
    CGRect frameBt = self.btInfo.frame;
    frameBt.origin.x = 110;
    [self.btInfo setFrame:frameBt];
    
    [self.btSolicit setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Item de inventário";
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

- (void)btBack {
    if(self->showingImage)
    {
        [self->currentZoom hide];
        self->showingImage = NO;
        self->currentZoom = nil;
    }
    else
    {
        [btCancel removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)btSolicit:(id)sender {
    
    isSolicit = YES;
    [self.table setHidden:YES];
    UIButton *bt = (UIButton*)sender;
    
    for (UIButton *newBt in self.arrBt) {
        if (bt == newBt) {
            [newBt setSelected:YES];
        } else
            [newBt setSelected:NO];
    }
    
    [self getRequests];
//    if (!detailView) {
//        NSString *nibName = nil;
//        if ([Utilities isIpad]) {
//            nibName = @"PerfilDetailViewController_iPad";
//        } else {
//            nibName = @"PerfilDetailViewController";
//        }
    
//        detailView = [[PerfilDetailViewController alloc]initWithNibName:nibName bundle:nil];
//        //        detailView.isFromFeed = YES;
//        detailView.dictMain = self.dictMain;
//        
//        if ([Utilities isIpad]) {
//            
//            CGRect frame = self.view.frame;
//            frame.origin.y = 50;
//            frame.size.height -= 50;
//            [detailView.view setFrame:frame];
//            [detailView.view setBackgroundColor:[Utilities colorGrayLight]];
//        } else {
//            [detailView.view setFrame:self.table.frame];
//            
//        }
//        [self.view addSubview:detailView.view];
//    }
    
//    [detailView.view setHidden: NO];

}

- (IBAction)btMenu:(id)sender {
    
    isSolicit = NO;
    [self getDetails];
    
    UIButton *bt = (UIButton*)sender;
    
    for (UIButton *newBt in self.arrBt) {
        if (bt == newBt) {
            [newBt setSelected:YES];
        } else
            [newBt setSelected:NO];
    }
    if (detailView) {
        [detailView.view setHidden:YES];
    }
    
}

#pragma mark - Request Info

- (void)getDetails {
    
    [self.lblNoSolicits setHidden:YES];
    [self.table setHidden:YES];
    [self.spin startAnimating];
    ServerOperations *server = [[ServerOperations alloc]init];
    [server setTarget:self];
    [server setAction:@selector(didReceiveData:)];
    [server setActionErro:@selector(didReceiveError:)];
    [server getInventoryDetailsWithId:[self.dictMain valueForKey:@"inventory_category_id"] idItem:[self.dictMain valueForKey:@"id"]];
}

- (void)didReceiveData:(NSData*)data {
    
    [self.spin stopAnimating];
    [self.table setHidden:NO];

    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *arrData = [dict valueForKeyPath:@"item.data"];
    
    NSMutableArray *arrTempForTable = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in arrData) {
        if([[dict valueForKey:@"field"] isKindOfClass:[NSNull class]])
            continue;
        
        NSString *titleStr = [UserDefaults getTitleForFieldId:[[dict valueForKeyPath:@"field.id"]intValue] idCat:[[self.dictMain valueForKey:@"inventory_category_id"]intValue]];
        NSString *content = [dict valueForKey:@"content"];
        if(titleStr == nil)
        {
            NSLog(@"Invalid field: %i", [[dict valueForKeyPath:@"field.id"]intValue]);
            titleStr = @"NONAME!";
        }
        
        NSDictionary *dictTemp = @{@"title": titleStr,
                                   @"content" : content,
                                   @"kind": [dict valueForKeyPath:@"field.kind"]};
        
        [arrTempForTable addObject:dictTemp];
        
    }
    self.arrMain = [[NSArray alloc]initWithArray:arrTempForTable];
    [self.table reloadData];
    
    if ([Utilities isIpad]) {
        [self buildMap];
    }
}

- (void)didReceiveError:(NSError*)error {
    [Utilities alertWithServerError];
    [self.spin stopAnimating];
}


#pragma mark - Request Requests

- (void)getRequests {
    
    [self.lblNoSolicits setHidden:YES];

    [self.spin startAnimating];
    ServerOperations *server = [[ServerOperations alloc]init];
    [server setTarget:self];
    [server setAction:@selector(didReceiveRequestData:)];
    [server setActionErro:@selector(didReceiveError:)];
    [server getReportItemsForInventory:[self.dictMain valueForKey:@"id"]];
}

- (void)didReceiveRequestData:(NSData*)data {
    
    [self.spin stopAnimating];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    [self.table setHidden:NO];

    self.arrMain = [[NSArray alloc]initWithArray:[dict valueForKey:@"reports"]];
    [self.table reloadData];
    
    if (self.arrMain.count == 0) {
        [self.lblNoSolicits setHidden:NO];
    }
    
    if ([Utilities isIpad]) {
        [self buildMap];
    }
}

- (void)buildMap {
    
    NSString *latStr = [self.dictMain valueForKeyPath:@"position.latitude"];
    
    NSString *lngStr = [self.dictMain valueForKeyPath:@"position.longitude"];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latStr.floatValue, lngStr.floatValue);
    
    CustomMap *map = [[CustomMap alloc]init];
    CGRect frame = self.table.frame;
    frame.size.height = frame.size.width;
    frame.origin.x = self.table.frame.size.width + self.table.frame.origin.x + 30;
    [map setFrame:frame];
    
    if ([Utilities isIpad]) {
        [self.view addSubview:map];
    }
    
    
    NSString *catStr = nil;
    BOOL isReport = YES;
    
    if ([self.dictMain valueForKey:@"inventory_category_id"]) {
        catStr = [self.dictMain valueForKeyPath:@"inventory_category_id"];
        isReport = NO;
    } else if ([self.dictMain valueForKeyPath:@"category.id"]) {
        catStr = [self.dictMain valueForKeyPath:@"category.id"];
    } else if ([self.dictMain valueForKey:@"category_id"]) {
        catStr = [self.dictMain valueForKey:@"category_id"];
    }

    
    [map setPositionWithLocation:coord andCategory:[catStr intValue] isReport:isReport];
    [map setUserInteractionEnabled:NO];
    
}


#pragma mark - Table View Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isSolicit) {
        return 100;
    }
    else
    {
        NSDictionary *dict = [self.arrMain objectAtIndex:indexPath.row];
        NSString* kind = [dict valueForKey:@"kind"];
        
        
        if([kind isEqualToString:@"images"])
        {
            return 155;
        }
        else
        {
            return 60;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrMain.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isSolicit) {
        CellMinhaConta *cell = [tableView dequeueReusableCellWithIdentifier:@"CellConta"];
        
        if(cell == nil)
        {
            cell = [[CellMinhaConta alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellConta"];
        }
        
        [cell setvalues:[self.arrMain objectAtIndex:indexPath.row]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
    } else {
        
        NSDictionary *dict = [self.arrMain objectAtIndex:indexPath.row];
        id value = [dict valueForKey:@"content"];
        NSString* kind = [dict valueForKey:@"kind"];
        
        if([kind isEqualToString:@"images"])
        {
            CellGaleriaInventario* cell = [tableView dequeueReusableCellWithIdentifier:@"CellGaleria"];
            if (cell == nil) {
                cell = [[CellGaleriaInventario alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellGaleria"];
            }
            
            [cell.label setText:[[dict valueForKey:@"title"]uppercaseString]];
            [cell.label setFont:[Utilities fontOpensSansBoldWithSize:12]];
            if([cell.label respondsToSelector:@selector(setTintColor:)])
                [cell.label setTintColor:[Utilities colorGray]];

            int x = 0;
            int imageSize = 100;
            
            NSArray* images = value;
            for(NSDictionary* imageDict in images)
            {
                NSString* url = [imageDict valueForKeyPath:@"versions.thumb"];
                NSNumber* _id = [imageDict valueForKey:@"id"];
                
                UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                spinner.frame = CGRectMake(x, 0, imageSize, imageSize);
                [cell.scrollView addSubview:spinner];
                [spinner startAnimating];
                
                UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, imageSize, imageSize)];
                imageView.tag = [_id integerValue];
                [cell.scrollView addSubview:imageView];
                imageView.userInteractionEnabled = YES;
                [imageView setImageWithURL:[NSURL URLWithString:url]];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
                 
                //XLMediaZoom* zoom = [[XLMediaZoom alloc] initWithAnimationTime:@(0.5) image:imageView blurEffect:YES];
                
                //[self.view addSubview:zoom];
                //[self.imageZooms setObject:zoom forKey:_id];
                [self.imageZooms setObject:[imageDict valueForKeyPath:@"versions.high"] forKey:_id];
                
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(galleryImageTap:)];
                [imageView addGestureRecognizer:tap];
                
                x += imageSize + 5;
            }
            cell.scrollView.contentInset = UIEdgeInsetsMake(0, 15, 0, 10);
            cell.scrollView.contentSize = CGSizeMake(x, imageSize);
            
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
            }
            
            [cell.textLabel setText:[[dict valueForKey:@"title"]uppercaseString]];
            
            NSString* textValue;

            if ([value isKindOfClass:[NSNull class]]) {
                textValue = @"";
            } else if ([value isKindOfClass:[NSArray class]]) {
                textValue = [(NSArray *)value componentsJoinedByString:@", "];
            } else {
                textValue = [NSString stringWithFormat:@"%@", value];
            }
            
            NSString* xtra = @"";
            if([kind isEqualToString:@"meters"])
                xtra = @" metros";
            else if([kind isEqualToString:@"centimeters"])
                xtra = @" cm";
            else if([kind isEqualToString:@"kilometers"])
                xtra = @" km";
            else if([kind isEqualToString:@"years"])
                xtra = @" anos";
            else if([kind isEqualToString:@"months"])
                xtra = @" meses";
            else if([kind isEqualToString:@"days"])
                xtra = @" dias";
            else if([kind isEqualToString:@"hours"])
                xtra = @" horas";
            else if([kind isEqualToString:@"seconds"])
                xtra = @" segundos";
            else if([kind isEqualToString:@"angle"])
                xtra = @" graus";

            textValue = [textValue stringByAppendingString:xtra];
            
            [cell.detailTextLabel setText:textValue];
            
            [cell.textLabel setFont:[Utilities fontOpensSansBoldWithSize:12]];
            if([cell.textLabel respondsToSelector:@selector(setTintColor:)])
                [cell.textLabel setTintColor:[Utilities colorGray]];
            [cell.detailTextLabel setFont:[Utilities fontOpensSansWithSize:13]];
            [cell.detailTextLabel setTintColor:[Utilities colorGrayLight]];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            if([kind isEqualToString:@"url"])
            {
                cell.detailTextLabel.textColor = [Utilities colorBlueLight];
                if([cell.detailTextLabel respondsToSelector:@selector(setAttributedText:)])
                {
                    NSDictionary* dict = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
                    cell.detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:textValue attributes:dict];
                }
                
                UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL:)];
                [cell addGestureRecognizer:gesture];
            }
            else
            {
                cell.detailTextLabel.textColor = [UIColor blackColor];
            }
            
            return cell;
        }
    }
    
    return nil;
}

- (void)openURL:(UITapGestureRecognizer*)sender
{
    UITableViewCell* cell = (UITableViewCell*) sender.view;
    UILabel* label = cell.detailTextLabel;
    NSString* url = label.text;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)galleryImageTap:(UITapGestureRecognizer*)sender
{
    __weak UIImageView* view = (UIImageView*) sender.view;
    NSNumber* _id = [NSNumber numberWithInteger:view.tag];
    NSString* url = [self.imageZooms objectForKey:_id];
    
    view.layer.opacity = .5f;
    [view setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        view.layer.opacity = 1.0f;
        XLMediaZoom* zoom = [[XLMediaZoom alloc] initWithAnimationTime:@(0.35) image:view blurEffect:YES];
        
        self->showingImage = YES;
        self->currentZoom = zoom;
        
        [self.view addSubview:zoom];
        [zoom show:^{
            self->showingImage = NO;
            self->currentZoom = nil;
        }];
    }];
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01f;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (isSolicit) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSString *nibName = nil;
        if ([Utilities isIpad]) {
            nibName = @"PerfilDetailViewController_iPad";
        } else {
            nibName = @"PerfilDetailViewController";
        }
        PerfilDetailViewController *perfilDetailVC = [[PerfilDetailViewController alloc]initWithNibName:nibName bundle:nil];
        perfilDetailVC.dictMain = [self.arrMain objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:perfilDetailVC animated:YES];
    }
    
    //    NSString *nibName = nil;
    //    if ([Utilities isIpad]) {
    //        nibName = @"PerfilDetailViewController_iPad";
    //    } else {
    //        nibName = @"PerfilDetailViewController";
    //    }
    //
    //    PerfilDetailViewController *perfilDetailVC = [[PerfilDetailViewController alloc]initWithNibName:nibName bundle:nil];
    //    perfilDetailVC.dictMain = [self.arrMain objectAtIndex:indexPath.row];
    //    [self.navigationController pushViewController:perfilDetailVC animated:YES];
    //
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
