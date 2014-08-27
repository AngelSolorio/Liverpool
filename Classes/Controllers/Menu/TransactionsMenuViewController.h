//
//  TransactionsMenu.h
//  CardReader
//


#import <UIKit/UIKit.h>


@interface TransactionsMenuViewController : UIViewController {

	UIButton *btnClientSale;
	UIButton *btnEmployeeSale;
	//UIButton *btnbtnBalance;
	UIButton *btnbtnQuerySKU;
	UIButton *btnAirTime;
	UIButton *btnBalance;
    UIButton *btnCloseStore;
    UIButton *btnCancelTicket;
    UIButton *btnClientRefund;
    UIButton *btnEmployeeRefund;
    UIButton *btnWithdrawCash;

}
@property (assign, nonatomic) IBOutlet UIButton *btnWithdrawCash;
@property (nonatomic,retain) IBOutlet UIButton *btnClientSale;
@property (nonatomic,retain) IBOutlet UIButton *btnEmployeeSale;
//@property (nonatomic,retain) IBOutlet UIButton *btnBalance;
@property (nonatomic,retain) IBOutlet UIButton *btnQuerySKU;
@property (nonatomic,retain) IBOutlet UIButton *btnAirTime;
@property (nonatomic,retain) IBOutlet UIButton *btnBalance;
@property (nonatomic,retain) IBOutlet UIButton *btnCloseStore;
@property (nonatomic,retain) IBOutlet UIButton *btnCancelTicket;
@property (nonatomic,retain) IBOutlet UIButton *btnClientRefund;
@property (nonatomic,retain) IBOutlet UIButton *btnEmployeeRefund;



-(IBAction) clientSaleTransact;
-(IBAction) SKUQueryTransact;
//-(IBAction) AirTimeTransact;
//-(IBAction) BalanceQueryTransact;
-(IBAction) logout;
-(IBAction) EmployeeSale;
-(IBAction) closeTerminal:(id)sender;
-(IBAction) cancelTicket:(id)sender;
-(IBAction) refundEmployeeTransact;
-(IBAction) refundTransact;
-(IBAction) withDrawAction:(id)sender;

@end
