//
//  LoginViewController.h
//  CardReader

#import <UIKit/UIKit.h>
#import "LiverPoolRequest.h"
#import "TerminalViewController.h"
#import "LineaSDK.h"

@interface LoginViewController : UIViewController<LineaDelegate,UITextFieldDelegate,WsCompleteDelegate,TerminalDelegate> {

	UIView* vistaInterior;
	UITextField *txtUser;
	UITextField *txtPassword;
	UIView* darkView;
	UIView* configView;


	UIButton* btnSynch;
	UIButton* btnStart;
	UIButton* btnUnlock;
	UIButton* btnGuest;
    
	TerminalViewController* terminalViewController;
	
	UILabel* lblStore;
	UILabel* lblTerminal;
	UILabel* lblDate;
	
	UILabel* lblConfig;
	UILabel* lblTerminalTxt;
	UILabel* lblBranch;
	UILabel* lblServer;
	UIButton* btnBranch;
	UIButton* btnSave;
	
	Linea                       *scanDevice;
    NSTimer *clockTimer;


}
@property (nonatomic,retain)IBOutlet UIView* vistaInterior;
@property (nonatomic,retain)IBOutlet UITextField *txtPassword;
@property (nonatomic,retain)IBOutlet UITextField *txtUser;
@property (nonatomic,retain)IBOutlet UIView* darkView;
@property (nonatomic,retain)IBOutlet UIView* configView;


@property (nonatomic,retain)IBOutlet UIButton* btnSynch;
@property (nonatomic,retain)IBOutlet TerminalViewController* terminalViewController;
@property (nonatomic,retain)IBOutlet UILabel* lblStore; 
@property (nonatomic,retain)IBOutlet UILabel* lblTerminal; 
@property (nonatomic,retain)IBOutlet UILabel* lblDate;
@property (nonatomic,retain)IBOutlet UIButton* btnStart;
@property (nonatomic,retain)IBOutlet UIButton* btnUnlock;
@property (nonatomic,retain)IBOutlet UIButton* btnGuest;

@property (nonatomic,retain)IBOutlet UILabel* lblConfig;
@property (nonatomic,retain)IBOutlet UILabel* lblTerminalTxt;
@property (nonatomic,retain)IBOutlet UILabel* lblBranch;
@property (nonatomic,retain)IBOutlet UILabel* lblServer;

@property (nonatomic,retain)IBOutlet UIButton* btnBranch;
@property (nonatomic,retain)IBOutlet UIButton* btnSave;

-(void)styleApply;
-(IBAction) sellerSignOn:(id)sender;
//-(IBAction) guestSignOn:(id)sender;
-(IBAction) f5SignOn:(id)sender;
-(IBAction) logoutRequest;
-(IBAction)synchronized:(id)sender;
-(void) startRequest;
-(BOOL) isValidFields;
-(void) loadMenuView;
-(void) loginRequestParsing:(NSData*) data;
-(void) evaluationActivePOS;
-(void) refreshLabelData;
-(void) startClock;
-(void) stopClock;
-(void) onTimer:(NSTimer *)timer;
-(void) logoutRequestParsing:(NSData*) data;
-(void) logout;
-(void) updateStoreList:(NSMutableArray*) storeList;



@end
