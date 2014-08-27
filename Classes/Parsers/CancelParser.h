//
//  CancelParser.h
//  CardReader
//
//  Created by Jonathan Esquer on 26/02/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentResponse.h"
#import "FindItemModel.h"
#import "Promotions.h"
#import "RefundData.h"
#import "Card.h"
@interface CancelParser : NSObject <NSXMLParserDelegate>{
    NSString *currentElement;
    NSString *msgResponse;
    PaymentResponse *payment;
    NSMutableArray *productList;
    NSMutableArray *eGlobalsCard;

    FindItemModel *itemModel;
    Promotions *promo;
    RefundData *refundD;
    Card *card;

}
@property (nonatomic,retain) 	NSString *msgResponse;
@property (nonatomic,retain) 	NSString *currentElement;
@property (nonatomic,retain) 	PaymentResponse *payment;
@property (nonatomic,retain) 	NSMutableArray *productList;
@property (nonatomic,retain) 	NSMutableArray *eGlobalsCard;
@property (nonatomic,retain) 	NSMutableArray *paymentCardList;

@property (nonatomic,retain) 	FindItemModel *itemModel;
@property (nonatomic,retain) 	Promotions *promo;

@property (nonatomic,retain) 	RefundData *refundD;




- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void) startParser:(NSData*) data;
-(NSString*) getMessageResponse;
-(BOOL) getStateOfMessage;
-(NSMutableArray*) returnSaleProductList;
-(void) assignPromoType:(NSString*)promoTypeBenefit;
@end
