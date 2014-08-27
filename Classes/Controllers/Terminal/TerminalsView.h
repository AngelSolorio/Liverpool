//
//  TerminalsView.h
//  CardReader
//


#import <Foundation/Foundation.h>


@interface TerminalsView : UIViewController    {

	UIButton *selectBtn;
	UIScrollView *gridView;
	NSArray *arrayTerminals;
}
@property (nonatomic,retain) IBOutlet UIButton *selectBtn;
@property (nonatomic,retain) IBOutlet UIScrollView *gridView;
@property (nonatomic,retain)		  NSArray *arrayTerminals;


-(IBAction) selectTerminal;
-(void)styleApply;
-(IBAction) getTerminalNumber:(id)sender;
-(void) getAvailableTerminals:(int) minRange forMaxRange:(int)maxRange forBusyTerminals:(NSArray*) terminalArrays;
-(void) createButtonForRow:(int) row forColumn:(int)col forTNumber:(int) terminalNumber;
-(BOOL) isTerminalOccupied:(int) terminalNumber;

@end
