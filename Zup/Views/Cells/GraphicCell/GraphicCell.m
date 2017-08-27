//
//  GraphicCell.m
//  Zup
//

#import "GraphicCell.h"

@implementation GraphicCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        NSString *strNib;
        if ([Utilities isIpad]) {
            strNib = @"GraphicCell_iPad";
        } else {
            strNib = @"GraphicCell";
        }
        
        NSArray *contentViewNib = [[NSBundle mainBundle] loadNibNamed:strNib owner:self options:nil];
        [self.contentView addSubview:contentViewNib[0]];
    }
    return self;
}

- (void)setValues:(NSDictionary *)dict {
    
    if ([Utilities isIpad]) {
        [self.lblTitle setFont:[Utilities fontOpensSansWithSize:18]];
    } else {
        [self.lblTitle setFont:[Utilities fontOpensSansWithSize:12]];
    }
    
    NSString *colorStr = [dict valueForKey:@"color"];
    if(colorStr == nil || [colorStr isKindOfClass:[NSNull class]])
        colorStr = @"#ffffff";
    
    colorStr = [colorStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    UIColor *color = [Utilities colorWithHexString:colorStr];
    [self.lblCount setTextColor:color];

    
    [self.viewPie setPieFillColor:color];
    [self.viewPie setPieBorderColor:[UIColor clearColor]];
    [self.viewPie setBackgroundColor:[UIColor clearColor]];
    
    if ([Utilities isIpad]) {
        [self.lblPercent setFont:[Utilities fontOpensSansBoldWithSize:20]];
        [self.lblCount setFont:[Utilities fontOpensSansExtraBoldWithSize:55]];
    } else {
        [self.lblPercent setFont:[Utilities fontOpensSansBoldWithSize:10]];
        [self.lblCount setFont:[Utilities fontOpensSansExtraBoldWithSize:34]];
    }
    
    int totalCount = [[dict valueForKeyPath:@"totalCount"]intValue];
    int count = [[dict valueForKey:@"count"]intValue];
    float percent = 0;
    if (count == 0 ) {
        percent = 0;
    } else {
        percent = (count * 100) / totalCount;
    }
    
    [self setValue:percent andCount:count];
    [self.lblTitle setText:[dict valueForKey:@"title"]];
    
    [self.lblPercent setTextColor:[Utilities colorGray]];
}

- (void)setValue:(float)value andCount:(int)count{
    [self.viewPie setProgress:value/100];
    float newValue = value;
    [self.lblPercent setText:[NSString stringWithFormat:@"%.0f%%", newValue]];
    [self.lblCount setText:[NSString stringWithFormat:@"%i", count]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
