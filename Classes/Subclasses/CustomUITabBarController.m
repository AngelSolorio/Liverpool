//
//  CustomUITabBarController.m
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 18/04/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import "CustomUITabBarController.h"

@interface CustomUITabBarController ()

@end

@implementation CustomUITabBarController
//IOS 5.0 support
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskPortrait;
}

//IOS 6.0 support
- (BOOL)shouldAutorotate {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return NO;
    
    //return YES; //you are asking your current controller what it should do
}

- (NSUInteger)supportedInterfaceOrientations {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    else
        return UIInterfaceOrientationMaskPortrait;
    
    //    return UIInterfaceOrientationMaskAll;
    
}
-(void) dealloc
{
    [super dealloc];
    DLog(@"customTabBar dealloc");
}
@end
