//
//  FiltrarViewController.h
//  Zup
//

#import <UIKit/UIKit.h>
#import "FiltrarCategoriasViewController.h"
#import "FiltrarPeriodoStatusViewController.h"
#import "FiltrarInventarioViewController.h"
#import "CustomButton.h"
#import "GAITrackedViewController.h"

@class ExploreViewController;
@interface FiltrarViewController : GAITrackedViewController <UIGestureRecognizerDelegate> {
    BOOL isMenuOpen;
}

@property CustomButton* btFilter;

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIButton *btnCategorias;
@property (retain, nonatomic) IBOutlet UIButton *btnPeriodoStatus;
@property (retain, nonatomic) IBOutlet UIButton *btnInventario;

@property (retain, nonatomic) IBOutlet UIView *viewCategorias;
@property (retain, nonatomic) IBOutlet UIView *viewPeriodoStatus;
@property (retain, nonatomic) IBOutlet UIView *viewInventario;

@property (strong, retain) IBOutlet FiltrarCategoriasViewController* categoriasViewController;
@property (strong, retain) IBOutlet FiltrarPeriodoStatusViewController* periodoStatusViewController;
@property (strong, retain) IBOutlet FiltrarInventarioViewController* inventarioViewController;

@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *arrBtStatus;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSMutableArray *arrReportCategorias;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSMutableArray *arrInventoryCategories;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSMutableArray *arrButtonStatuses;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSMutableArray *arrCurrentButtonStatuses;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *arrLabel;
@property (retain, nonatomic)  NSMutableArray *arrBtPontos;


@property (retain, nonatomic) IBOutlet UIScrollView *scroll;
@property (retain, nonatomic) ExploreViewController *exploreView;
@property (retain, nonatomic) IBOutlet UISlider *slider;

@property (retain, nonatomic) IBOutlet UIView *viewContent;
@property (retain, nonatomic) IBOutlet UIView *viewPontos;
@property (retain, nonatomic) IBOutlet UIView *viewStatus;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollInventoryCategories;
@property (retain, nonatomic) IBOutlet UIImageView *imgSeta;

@property (retain, nonatomic) IBOutlet UILabel *lblSolicitacoesTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblPontosTitle;

@property (retain, nonatomic) IBOutlet UIButton *btBueiroBocaLobo;
@property (retain, nonatomic) IBOutlet UIButton *btColetaEntulho;
@property (retain, nonatomic) IBOutlet UIButton *btViewStatus;

@property (retain, nonatomic) IBOutlet UIButton *btTodosStatus;
@property (retain, nonatomic) IBOutlet UIButton *btResolvidos;
@property (retain, nonatomic) IBOutlet UIButton *btAndamento;
@property (retain, nonatomic) IBOutlet UIButton *btAberto;


@property (retain, nonatomic) IBOutlet UIScrollView *scrollCat;

- (IBAction)sliderDidChange:(id)sender;
- (IBAction)btExibirRelato:(id)sender;
- (IBAction)btStatus:(id)sender;
- (IBAction)btPontos:(id)sender;
- (IBAction)btViewStatus:(id)sender;

@end
