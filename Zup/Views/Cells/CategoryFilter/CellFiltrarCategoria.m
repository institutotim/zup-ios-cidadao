//
//  CellFiltrarCategoria.m
//  zup
//

#import "CellFiltrarCategoria.h"

@implementation CellFiltrarCategoria

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setvalues:(NSDictionary*) dict selected:(BOOL)selected iconColored:(BOOL)iconColored
{
    BOOL isSub = NO;
    
    UIImage* icon;
    if([dict objectForKey:@"parent_id"] != nil)
    {
        isSub = YES;
        icon = nil;
    }
    else if(iconColored)
        icon = [UIImage imageWithData:[dict valueForKey:@"iconData"]];
    else
        icon = [UIImage imageWithData:[dict valueForKey:@"iconDataDisabled"]];
    
    self.iconView.image = icon;
    self.lblTitle.text = [dict valueForKey:@"title"];
    if(isSub)
        self.lblTitle.font = [Utilities fontOpensSansLightWithSize:13];
    else
        self.lblTitle.font = [Utilities fontOpensSansLightWithSize:17];
    
    [self.iconView setContentMode:UIViewContentModeScaleToFill];
    self.lblLink.hidden = YES;
    self.lblTitle.textColor = [UIColor blackColor];
    self.lblTitle.hidden = NO;
    self.iconView.hidden = NO;
    self.separator.hidden = NO;
    self.selectIndicator.hidden = !selected;
    
    CGRect frame = self.lblTitle.frame;
    CGSize sz = [self.lblTitle.text sizeWithFont:self.lblTitle.font constrainedToSize:CGSizeMake(frame.size.width, 999)];
    
    frame.size.height = sz.height;
    self.lblTitle.frame = frame;
    
    self.separator.frame = CGRectMake(self.separator.frame.origin.x, self.lblTitle.frame.origin.y + self.lblTitle.frame.size.height + 8, self.separator.frame.size.width, 1);
    
    frame = self.selectIndicator.frame;
    frame.origin.y = self.lblTitle.frame.origin.y + ((self.lblTitle.frame.size.height - frame.size.height) / 2);
    
    self.selectIndicator.frame = frame;
    
    self.height = self.separator.frame.origin.y + self.separator.frame.size.height + 5;
}

- (void) setShowMoreExpanded:(BOOL) expanded
{
    self.iconView.hidden = YES;
    self.separator.hidden = YES;
    self.lblLink.font = [Utilities fontOpensSansLightWithSize:11];
    self.lblLink.hidden = NO;
    self.lblTitle.hidden = YES;
    self.selectIndicator.hidden = YES;
    
    if(!expanded)
        self.lblLink.text = @"Ver subcategorias";
    else
        self.lblLink.text = @"Ocultar subcategorias";
}

- (void) setActivateDeactivate:(BOOL) activated
{
    BOOL isSub = NO;
    
    UIImage* icon;
    if(activated)
    {
        icon = [UIImage imageNamed:@"filtros_check_todascategorias_desativar.png"];
        self.lblTitle.text = @"Desativar todas as categorias";
    }
    else
    {
        icon = [UIImage imageNamed:@"filtros_check_todascategorias_ativar.png"];
        self.lblTitle.text = @"Ativar todas as categorias";
    }
    
    self.iconView.image = icon;
    [self.iconView setContentMode:UIViewContentModeCenter];
    
    self.lblTitle.font = [Utilities fontOpensSansLightWithSize:17 - 2];
    self.lblTitle.textColor = [Utilities colorBlueLight];
    self.lblLink.hidden = YES;
    self.lblTitle.hidden = NO;
    self.iconView.hidden = NO;
    self.separator.hidden = NO;
    self.selectIndicator.hidden = YES;
    
    CGRect frame = self.lblTitle.frame;
    CGSize sz = [self.lblTitle.text sizeWithFont:self.lblTitle.font constrainedToSize:CGSizeMake(frame.size.width, 9999)];
    
    frame.size.height = sz.height;
    self.lblTitle.frame = frame;
    
    self.separator.frame = CGRectMake(self.separator.frame.origin.x, self.lblTitle.frame.origin.y + self.lblTitle.frame.size.height + 8, self.separator.frame.size.width, 1);
}

- (void)layoutSubviews
{
    CGRect frame = self.lblTitle.frame;
    CGSize sz = [self.lblTitle.text sizeWithFont:self.lblTitle.font constrainedToSize:CGSizeMake(frame.size.width, 9999)];
    
    frame.size.height = sz.height;
    self.lblTitle.frame = frame;
    
    self.separator.frame = CGRectMake(self.separator.frame.origin.x, self.lblTitle.frame.origin.y + self.lblTitle.frame.size.height + 8, self.separator.frame.size.width, 1);
    
    frame = self.selectIndicator.frame;
    frame.origin.y = self.lblTitle.frame.origin.y + ((self.lblTitle.frame.size.height - frame.size.height) / 2);
    
    self.selectIndicator.frame = frame;

    
    self.height = self.separator.frame.origin.y + self.separator.frame.size.height + 5;
}

- (void) setPlaceholder
{
    self.lblLink.hidden = YES;
    self.lblTitle.hidden = YES;
    self.iconView.hidden = YES;
    self.separator.hidden = YES;
    self.selectIndicator.hidden = YES;
}

- (void) setViewBackgroundColor:(UIColor *)backgroundColor
{
    self.qbackgroundView.backgroundColor = backgroundColor;
}

@end
