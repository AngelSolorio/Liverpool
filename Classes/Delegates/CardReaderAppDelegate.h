//
//  CardReaderAppDelegate.h
//  CardReader


#import <UIKit/UIKit.h>
#import "FindItemModel.h"
#import "Promotions.h"
#import "ScanViewController.h"
#import "PaymentViewController.h"
#import "LineaSDK.h"
#import "BatteryTabView.h"
@class LoginViewController;
@interface CardReaderAppDelegate : UIResponder
								   <UIApplicationDelegate, 
								   UITabBarDelegate/*,CBCentralManagerDelegate*/>
{
	UIWindow               *window;
	UITabBarController     *aTabBarController;
	UITabBar			   *aTabBar;
	//UINavigationController *aNavigationControllerScan;
	UINavigationController *aNavigationControllerRecord;
	UINavigationController *aNavigationControllerConfig;
	UINavigationController *aNavigationControllerLogin;
	LoginViewController	   *loginViewController;
	UIViewController	   *transactionMenu;
	ScanViewController		*scanViewController;
    BOOL enableCheckLoop;
    UIViewController *topView;

}

@property (retain, nonatomic) IBOutlet UIWindow             *window;
@property (retain, nonatomic) IBOutlet UITabBarController   *aTabBarController;
//@property (retain, nonatomic) IBOutlet UINavigationController *aNavigationControllerScan;
@property (retain, nonatomic) IBOutlet UINavigationController *aNavigationControllerRecord;
@property (retain, nonatomic) IBOutlet UINavigationController *aNavigationControllerConfig;
@property (retain, nonatomic) IBOutlet UINavigationController *aNavigationControllerLogin;
@property (assign, nonatomic)			LoginViewController		*loginViewController;
@property (assign, nonatomic)			UIViewController		*transactionMenu;
@property (assign, nonatomic) IBOutlet 	ScanViewController		*scanViewController;
@property (assign, nonatomic) IBOutlet 	UITabBar			   *aTabBar;


-(void) loginScreen;
-(void) mainScreen;
-(void) transactionMenuScreen;
-(void) saleOptionScreen;
-(void) removeSaleOptionScreen;
-(void) transactionF5MenuScreen;
-(void) removeTransactionMenuScreen;
-(void) airTimeScreen;
-(void) consultSKUScreen;
-(void) removeConsultSKUScreen;
-(void) removeAirTimeScreen;
-(void) transactionBalanceScreen;
-(void) installmentsScreen:(Promotions*) promo;
-(void) removeInstallmentsScreen;
-(void) promoScreen:(Promotions*) promo;
-(void) removePromoScreen;
-(void) detailItemScreen:(FindItemModel*) itemModel;
-(void) itemDiscountScreen:(FindItemModel*) itemModel;
-(void) itemPromotionScreen:(NSMutableArray*) aProductList;
-(void) removeDiscountScreen;
-(void) paymentPlanScreen:(NSMutableArray*)originalPromotions :(NSMutableArray*) promotionGroupChoosed :(PaymentViewController*) payView;
-(void) removePaymentPlanScreen;
-(void) paymentScreen:(NSMutableArray*)aProductList :(NSMutableArray*)aPromoGroup;
-(void) removePaymentScreen;
-(void) closeTerminalScreen;
-(void) removeCloseTerminalScreen;
-(void) hideTabBar;

-(void) ticketGiftScreen;
-(void) removeTicketGiftScreen;
-(void) cancelTicketScreen;
-(void) removeCancelTicketScreen;

-(void) removeScreensToSaleView;
-(void) saleOptionRefundScreen;

-(void) withdrawScreen;
-(void) removewithdrawScreen;
//-(void) refundScreen;
//-(void) removeRefundScreen;
-(void)updateBattery;
-(void) displayBatteryAnimation:(NSString*) image :(BOOL) soundOn;
-(void) removeMainScreen;

@end
