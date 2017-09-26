//
//  NewOfficeCell.m
//  MobileOffice1
//
//  Created by shizheng on 13-11-27.
//
//

#import "NewOfficeCell.h"

@implementation NewOfficeCell


@synthesize titleLabel;
@synthesize timeLabel;
@synthesize fromLabel;

- (void) dealloc
{
    self.titleLabel = nil;
    self.timeLabel = nil;
    self.fromLabel = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
