//
//  CellMinhaConta.m
//  Zup
//

#import "CellMinhaConta.h"

@implementation CellMinhaConta

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}

- (void)setvalues:(NSDictionary*)dict {
    NSDictionary *catDict = nil;
    if ([dict valueForKeyPath:@"category.id"]) {
        catDict = [UserDefaults getCategory:[[dict valueForKeyPath:@"category.id"]integerValue]];
    } else {
        catDict = [UserDefaults getCategory:[[dict valueForKeyPath:@"category_id"]integerValue]];
    }
    
    if([catDict valueForKey:@"parent_id"] != nil) // Categoria possui pai
    {
        NSNumber* parentcatid = [catDict valueForKey:@"parent_id"];
        NSDictionary* parentcatdict = [UserDefaults getCategory:[parentcatid intValue]];
        
        if ([parentcatdict valueForKey:@"title"]) {
            [self.lblTitle setText:[Utilities checkIfNull:[parentcatdict valueForKey:@"title"]]];
        }
        if ([catDict valueForKey:@"title"]) {
            [self.lblCategory setText:[Utilities checkIfNull:[catDict valueForKey:@"title"]]];
        }
        
        self.lblCategory.hidden = NO;
    }
    else
    {
        if ([catDict valueForKey:@"title"]) {
            [self.lblTitle setText:[Utilities checkIfNull:[catDict valueForKey:@"title"]]];
        }
        
        self.lblCategory.hidden = YES;
    }
    
    
    NSString *timeSentence = [Utilities calculateNumberOfDaysPassed:[dict valueForKey:@"updated_at"]];
    
    [self.lblSubtitle setText:timeSentence];
    
    [self.lblProtocolo setText:[NSString stringWithFormat:@"PROTOCOLO %@",[Utilities checkIfNull:[dict valueForKey:@"protocol"]]]];
    
    [self.lblTitle setFont:[Utilities fontOpensSansLightWithSize:16]];
    [self.lblCategory setFont:[Utilities fontOpensSansLightWithSize:12]];
    [self.lblSubtitle setFont:[Utilities fontOpensSansBoldWithSize:10]];
    [self.lblProtocolo setFont:[Utilities fontOpensSansLightWithSize:8]];
    
    NSString *strColor = nil;
    NSString *strStatus = nil;
    if ([dict valueForKeyPath:@"status.color"]) {
        strColor = [dict valueForKeyPath:@"status.color"];
        strStatus = [dict valueForKeyPath:@"status.title"];
    } else {
        for (NSDictionary *newDict in [catDict valueForKeyPath:@"statuses"]) {
            if ([[newDict valueForKeyPath:@"id"]intValue] == [[dict valueForKey:@"status_id"]intValue]) {
                strColor = [newDict valueForKey:@"color"];
                strStatus = [newDict valueForKey:@"title"];
            }
        }
    }
    
    if([strColor isKindOfClass:[NSNull class]])
        strColor = @"#ffffff";
    
    strColor = [strColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    UIColor *color = [Utilities colorWithHexString:strColor];
    [self.imgLine setBackgroundColor:color];
    
    [self.lblStatus setFrame:CGRectMake(207, 67 + 9, 101, 21)];
    [self.lblStatus setText:[Utilities checkIfNull:strStatus]];
    
    [self.lblStatus setBackgroundColor:color];
    [self.lblStatus.layer setCornerRadius:10];
    [self.lblStatus setClipsToBounds:YES];
    self.lblStatus.text = self.lblStatus.text.uppercaseString;
    [self.lblStatus setFont:[Utilities fontOpensSansExtraBoldWithSize:11]];
    
    float currentW = self.lblStatus.frame.size.width;
    float width = [Utilities expectedWidthWithLabel:self.lblStatus];
    CGRect frame = self.lblStatus.frame;
    frame.size.width = width + 20;
    
    if ([Utilities isIpad]) {
        frame.origin.x = self.lblStatus.frame.origin.x + currentW - width + 228;
    } else {
        //frame.origin.x = self.lblStatus.frame.origin.x + currentW - width - 20;
        frame.origin.x = self.frame.size.width - width - 20 - 12;
    }
    
    
    [self.lblStatus setFrame:frame];
    
    //    int type = [[dict valueForKey:@"tipo"]intValue];
    //
    //    if (type == 0) {
    //        [self.imgLine setBackgroundColor:[Utilities colorRed]];
    //    } else if (type == 1) {
    //        [self.imgLine setBackgroundColor:[Utilities colorYellow]];
    //    } else if (type == 2) {
    //        [self.imgLine setBackgroundColor:[Utilities colorGray]];
    //    } else if (type == 3) {
    //        [self.imgLine setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0f]];
    //    }
    //
    for (CustomButton *bt in self.arrButton) {
        [bt.titleLabel setFont:[Utilities fontOpensSansBoldWithSize:10]];
        
        //        if (bt.tag == type) {
        [bt setHidden:NO];
        //        } else {
        [bt setHidden:YES];
        //        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
