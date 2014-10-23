//
//  Tools.h
//  CardReader


#import <Foundation/Foundation.h>
#import "FindItemModel.h"

UIActivityIndicatorView *activityIndicator;
UIView *bgActivity;
UITextField *txtField;

@interface Tools : NSObject

//+(void) loadPrinter;
//+(void) savePrinter;

//Accesory Methods
+(void) startActivityIndicator:(UIView*) aView;
+(void) stopActivityIndicator;
+(void) displayAlert:(NSString *)title message:(NSString *)message;
+(void)displayAlert:(NSString *)title message:(NSString *)message withDelegate:(id) delegate;
+(void) showViewAnimation:(UIView*) aView;
+(void) hideViewAnimation:(UIView*) aView;
+(void) loadStore;
+(void) saveStore;
+(void) resetStore;
+(void) disableApp;
+(void) enableApp;
+(void) hideKeyboard;
+(BOOL) validatePrinterConfig;
+(BOOL) isTextFieldEmpty:(UITextField*) theTextfield;
+(BOOL) confirmPhoneValidation:(UITextField*) txtFirstNumber :(UITextField*) txtSecondNumber;
+(BOOL) isValidNumber:(NSString *) string;
//+(NSString*) getUniqueID;
+(NSString*) convertImageToBase64String:(UIImage*) aImage;
+(UIImage*) captureSign:(UIView*) aView;
+(UIImage*) captureScreen:(UIView*) aView;
+(NSInteger) string:(NSString*)actual indexOf:(NSString*)buscado;
+(UIView *) inputAccessoryView:(UITextField*) aTxtField;
+(BOOL) isValidAmountToPay:(UITextField*) discount :(NSNumber*) maxAmount :(int) paymentType;
+(void) saveStoreToPlist:(NSMutableArray*) storeList;
+(void) restartVoucherNumber;
+(void) increaseVoucherNumber;
+(int) getVoucherNumber;
+(BOOL) isStringNumber:(NSString*) number;
+(BOOL) compareStrings:(NSString*) string1 :(NSString*) string2;
+(BOOL) compareNumbers:(NSString*) number1 :(NSString*) number2;
+(BOOL) validateManualDiscounts:(FindItemModel *) item :(int) promoToAdd;
+(NSString*) getRefundReasonPrintText:(NSString*) aIndex;
+(NSString*) roundUpValue:(NSString *)value;
+(NSString*) getTypeOfSaleBCString;
+(NSString*) getShortErrorMessage:(NSString*) value;

//Formats
+(NSString*) amountCurrencyFormatFloat:(float) amount;
+(NSString*) amountCurrencyFormat:(NSString*) amount;
+(NSString*) maskMonederoNumber:(NSString*) cardNumber;
+(NSString*) maskCreditCardNumber:(NSString*) cardNumber;
+(NSString*) trimExpireDateCard:(NSString*) track1;
+(NSString*) trimExpireDateCreditCardTrack:(NSString*) track1;
+(NSString*) trimUsernameFromCreditCardTrack:(NSString*) track1;
+(NSString*) maskQuantityFormat:(NSString*) value;
+(NSString*) maskModifierFormat:(NSString*) value;
+(NSString*) getDateFromString:(NSString*) string;
+(NSString*) getDateFormatRefundTicket:(NSString*) string;
+(NSString*) getRFCFormat:(NSString*) RFC;
+(NSString*) getMonederoBalanceFromBC:(NSString*) monederoBalance;
+(NSString*) trimComandaNumber:(NSString*) track1;

//Calculations
+(NSString*) calculateAddUpValueAmount:(NSString*) amount1 :(NSString*)amount2;
+(NSString*) calculateMultiplyValueAmount:(NSString*) multi1 :(NSString*)multi2;
+(NSString*) calculateDivisionValueAmount:(NSString*) dividend :(NSString*)divisor;
+(NSString*) calculateRestValueAmount:(NSString*) amount1 :(NSString*)amount2;
+(NSString*) calculateAmountToPayWithPromo:(NSArray*) productList :(NSMutableArray*) promos;
+(NSString*) calculateAmountToPay:(NSArray*) productList;
+(NSString*) calculateDiscountValuePercentage:(NSString*) aPrice :(NSString*)percentageDiscount;
+(NSString*) calculateDiscountValueAmount:(NSString*) aPrice :(NSString*)amountDiscount;
+(void)		 calculateSuccesiveDiscounts:(FindItemModel *) item;
+(NSString*) calculateQuantityExtendedPrice:(FindItemModel *) item;

//+(NSString*) calculateDiscountValueForTicket:(NSMutableArray*) promos;

//Arrays searchs
+(BOOL) monederoPromotionInList:(NSArray*) aProductList;
+(BOOL) isMonederoPromotion:(NSMutableArray*) promotionList;
+(BOOL) isDiscountPromotionInGroup:(NSMutableArray*) promotionList;
+(BOOL) removeExtraMonedero:(NSMutableArray*) promotionList;
+(BOOL) addExtraMonedero:(NSMutableArray*) promotionList :(NSString*) aFactor;

//Arrays Filters
+(NSMutableArray*) removePromotionFromList:(NSMutableArray*)testArray forPlanId:(NSString*) planId;
+(NSMutableArray*) removeCouponBenefitFromList:(NSMutableArray*)testArray;
+(NSMutableArray*) removeDESCxPROMFromList:(NSMutableArray*)testArray;
+(NSMutableArray*) removePaymentPlanBenefitFromList:(NSMutableArray*)testArray;
+(NSMutableArray*) removePagoFijoFromList:(NSMutableArray*)testArray;
//Arrays inserts
+(void) applyPromotionsToTicket:(NSMutableArray*) aPromotionList :(NSMutableArray*) aProductList;
+(NSMutableArray *)popWarrantiesFromArray:(NSArray *)productList;

@end
