//
//  SignPrintViewController.m
//  CardReader
//


#import "SignPrintView.h"
#import <QuartzCore/CoreAnimation.h>
#import "Tools.h"

@implementation SignPrintView
@synthesize mouseSwiped,drawImage,lastPoint,clearButton,okButton;

/*
- (id)init {
    self = [super init];
    if (self) {
        drawImage =[[UIImageView alloc] init];
    }
    return self;
}*/

- (void)drawRect:(CGRect)rect 
{
	CALayer *bgLayer=self.layer;
	[bgLayer setCornerRadius:5];
	bgLayer.borderColor=[[UIColor blackColor]CGColor];
	bgLayer.borderWidth=2;
	
}
-(IBAction) clearCanvas
{
	drawImage.image=nil;
	okSign=FALSE;
}
-(IBAction) signCheckedOk
{
	okSign=YES;
}
-(BOOL) isSignDone
{
	if (!okSign) 
		[Tools displayAlert:@"Aviso" message:@"Favor de firmar primero"];
	
	return okSign;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    
   /* if ([touch tapCount] == 2) {
		
        drawImage.image = nil;
        return;
    }*/
	
    lastPoint = [touch locationInView:self];
    lastPoint.y -= 20;
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //UITouch *touch = [touches anyObject];
    
    /*if ([touch tapCount] == 2) {
        drawImage.image = nil;
        return;
    }*/
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.frame.size);
        [drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = YES;
    
    UITouch *touch = [touches anyObject];   
    CGPoint currentPoint = [touch locationInView:self];
    currentPoint.y -= 20;
    
    
    UIGraphicsBeginImageContext(self.frame.size);
    [drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
	
}
- (void)dealloc {
	[clearButton release];clearButton=nil;
	[drawImage release];clearButton=nil;
	[okButton release], okButton=nil;
    [super dealloc];
}


@end
