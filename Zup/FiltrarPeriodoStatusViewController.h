//
//  FiltrarPeriodoStatusViewController.h
//  zup
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface FiltrarPeriodoStatusViewController : GAITrackedViewController
{
    BOOL isMenuOpen;
    int dayFilter;
    int selectedStatusid;
}


@property (retain, nonatomic) IBOutlet UIView *viewStatus;
@property (retain, nonatomic) IBOutlet UIView *viewPontos;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSMutableArray *arrReportCategorias;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSMutableArray *arrButtonStatuses;
@property (retain, nonatomic) IBOutlet UIImageView *imgSeta;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSMutableArray *arrCurrentButtonStatuses;
@property (retain, nonatomic) IBOutlet UIButton *btViewStatus;
@property (retain, nonatomic) IBOutlet UIButton *btTodosStatus;
@property (retain, nonatomic) IBOutlet UISlider *slider;

@property (retain, nonatomic) IBOutlet UIScrollView *scroll;

- (IBAction)sliderDidChange:(id)sender;
- (IBAction)btViewStatus:(id)sender;

- (int)selectedStatusId;
- (int)dayFilter;

@end
