//
//  CustomCell.m
//  CardReader
//
//  Created by Jonathan Esquer on 04/10/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize lblQuantity;
@synthesize lblAmount;
@synthesize lblTotal;
@synthesize lblType;

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
