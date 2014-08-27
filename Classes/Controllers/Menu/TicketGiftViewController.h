//
//  TicketGiftViewController.h
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 14/05/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketGiftViewController : UIViewController
{
    UIButton *btnGiftY;
    UIButton *btnGiftN;
}
@property (nonatomic,retain) IBOutlet     UIButton *btnGiftY;
@property (nonatomic,retain) IBOutlet     UIButton *btnGiftN;


-(IBAction) setTicketGiftFlag :(id) sender;

@end
