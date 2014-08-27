//
//  BatteryTabView.m
//  CardReader
//
//  Created by Jonathan Esquer on 07/11/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import "BatteryTabView.h"

@implementation BatteryTabView
@synthesize batteryView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{
    [super dealloc];
    DLog(@"batteryTabView dealloc");
}
@end
