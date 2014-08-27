//
//  CustomUITabBar.m
//  CardReader


#import "CustomUITabBar.h"
#import <QuartzCore/CoreAnimation.h>
#import "Styles.h"

@implementation CustomUITabBar

- (void)drawRect:(CGRect)rect {
    CGRect frame = CGRectMake(0.0, 0, self.bounds.size.width, 49);
	
    
	
	UIView *v = [[UIView alloc] initWithFrame:frame];
	UIColor *color1 = UIColorFromRGBWithAlpha(0X63194A,1);
	UIColor *color2 = UIColorFromRGBWithAlpha(0XA83183,1);
	
	CALayer *bgLayer=v.layer;
	bgLayer.borderColor=[[UIColor darkGrayColor]CGColor];
	bgLayer.borderWidth=1;

	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.bounds;
	/*
	gradient.colors = [NSArray arrayWithObjects:
					   (id)[[UIColor colorWithRed:(154.0/255.0) green:(3.0/255.0) blue:(100.0/255.0) alpha:1 ] CGColor]
					   , (id)[[UIColor colorWithRed:(224.0/255.0) green:(6.0/255.0) blue:(156.0/255.0) alpha:1 ] CGColor]
					   , (id)[[UIColor colorWithRed:(154.0/255.0) green:(3.0/255.0) blue:(100.0/255.0) alpha:1 ] CGColor]
					   , nil];
	*/
	
	gradient.colors = [NSArray arrayWithObjects:
					   (id)[color1 CGColor]
					   , (id)[color2 CGColor]
					   , (id)[color1 CGColor]
					   , nil];
	
	
	[bgLayer insertSublayer:gradient atIndex:0];
	 
    [self insertSubview:v atIndex:0];
	 
    [v release];
}

- (void)dealloc {
    [super dealloc];
}
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
@end
