//
//  HeaderProfileCell.m
//  Zup
//

#import "HeaderProfileCell.h"

@implementation HeaderProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValues:(NSDictionary *)dict count:(int)count{
    [self.lblSoliciationsCell setFont:[Utilities fontOpensSansBoldWithSize:12]];
    [self.lblNameCell setFont:[Utilities fontOpensSansLightWithSize:16]];
    [self.lbltitleCell setFont:[Utilities fontOpensSansBoldWithSize:11]];
    
    if (count == 1) {
        [self.lblSoliciationsCell setText:@"1 SOLICITAÇÃO"];
    } else {
        [self.lblSoliciationsCell setText:[NSString stringWithFormat:@"%i SOLICITAÇÕES", count]];
    }
    
    [self.lblNameCell setText:[dict valueForKey:@"name"]];
    
}

@end
