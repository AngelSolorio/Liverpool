//
//  SomsListParser.h
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 10/08/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentResponse.h"
#import "FindItemModel.h"
#import "Promotions.h"

@interface SomsListParser : NSObject <NSXMLParserDelegate>
{
    NSString *currentElement;
    NSString *msgResponse;
    PaymentResponse *payment;
    NSMutableArray *productList;

    FindItemModel *itemModel;
}
@property (nonatomic,retain) 	NSString *msgResponse;
@property (nonatomic,retain) 	NSString *currentElement;
@property (nonatomic,retain) 	PaymentResponse *payment;
@property (nonatomic,retain) 	NSMutableArray *productList;

@property (nonatomic,retain) 	FindItemModel *itemModel;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void) startParser:(NSData*) data;
-(NSString*) getMessageResponse;
-(BOOL) getStateOfMessage;
-(NSMutableArray*) returnSaleProductList;

@end
