//
//  SynchonizeViewController.h
//  CardReader
//

#import <UIKit/UIKit.h>
#import "LiverPoolRequest.h"
@class Store;
@class StoreViewController;
@protocol TerminalDelegate
	-(void) isShowConfigView;
	-(void) showModal:(UIViewController*) aViewController;
	-(void) showViewsForStoreData;
    -(void) evaluationActivePOS;

@end


@interface TerminalViewController : UIViewController<UITextFieldDelegate,WsCompleteDelegate> {
	UIButton* btnStore;
	UIButton* btnSave;
	UITextField* txtTerminal;
    UITextField* txtServer;
	id<TerminalDelegate> delegate;
	Store* storeData;
	StoreViewController *storeViewController;

}

@property (nonatomic,retain)IBOutlet UIButton* btnStore; 
@property (nonatomic,retain)IBOutlet UIButton* btnSave; 
@property (nonatomic,retain)IBOutlet UITextField* txtTerminal;
@property (nonatomic,retain)IBOutlet UITextField* txtServer;

@property (nonatomic,retain) 	Store* storeData;
@property(nonatomic,retain)	id<TerminalDelegate> delegate;
-(void) storeSelection:(id)sender;
-(void) save:(id)sender; 
-(void) startRequestGetStoreAddress;
-(void) addressRequestParsing:(NSData*) data;
-(void) storeListRequestParsing:(NSData*) data;
-(void) startRequestGetStoreList;
-(void) resetLabels;

@end
