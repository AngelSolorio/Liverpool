//
//  Settings.h
//  IOPhoneTest
//
//  Created by sdtpig on 8/12/09.
//  Copyright 2009 Star Micronics Co., Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiverPoolRequest.h"
#define C_AutoCutterFullCut "\x1b\x64\x30"
#define C_LineFeedx6 "\x0a\x0a\x0a\x0a\x0a\x0a"
#define C_LineFeedx6_Size 6
#define C_AutoCutterFullCut_Size 3

@interface Settings : UIViewController <UITextFieldDelegate,WsCompleteDelegate>{
	IBOutlet UITextField *txtIPAddress;
	IBOutlet UITextField *textField_portSettings;	
	UIButton *btnOk;
    UIButton* btnDesynch;

}

@property(nonatomic,retain)IBOutlet UIButton *btnOk;
@property (nonatomic,retain)IBOutlet UIButton* btnDeSynch;
@property (assign, nonatomic) IBOutlet UISegmentedControl *ctrlPrinterType;
@property (assign, nonatomic) IBOutlet UILabel *lblIpAdress;
@property (assign, nonatomic) IBOutlet UITextField *txtIPAddress;

-(IBAction) desynchronize:(id) sender;
-(void) unregisterRequestParsing:(NSData*) data;
-(void) startDesynchronizeRequest;
-(void) unregisterRequestParsing:(NSData*) data;
-(IBAction)Ok;


@end
