//
//  SignPrintViewController.h
//  CardReader
//


#import <UIKit/UIKit.h>


@interface SignPrintView : UIView {

	BOOL mouseSwiped;
	CGPoint lastPoint;
	UIImageView *drawImage;
	UIButton *clearButton;
	UIButton *okButton;

	BOOL okSign;
	
}
@property(nonatomic, retain) IBOutlet UIImageView *drawImage;
@property(nonatomic, retain) IBOutlet UIButton *clearButton;
@property(nonatomic, retain) IBOutlet UIButton *okButton;

@property (nonatomic) 	CGPoint lastPoint;
@property (nonatomic)	BOOL mouseSwiped;

-(IBAction) clearCanvas;
-(IBAction) signCheckedOk;
-(BOOL) isSignDone;

@end
