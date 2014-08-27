//
//  SomsListParser.m
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 10/08/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import "SomsListParser.h"

@implementation SomsListParser
@synthesize msgResponse,currentElement;
@synthesize payment;
@synthesize productList;
@synthesize itemModel;

#define RETURN				@"return"
#define ISERROR				@"isError"
#define MESSAGE				@"message"

#define PRODUCTOS			@"productos"
#define BARCODE				@"barcode"
#define BRAND				@"brand"
#define DEPARTMENT			@"department"
#define GENERIC				@"generic"
#define ITEMCOUNT			@"itemCount"
#define ITEMTYPE			@"itemType"
#define LINETYPE			@"lineType"
#define PRICE				@"price"
#define DESCRIPTION			@"description"
#define PROMOTION			@"promocion"
#define FECHA_ENTREGA       @"fechaEntrega"


-(void) startParser:(NSData*) data
{
	//currentElement=[[NSString alloc] init];
	msgResponse=[[NSString alloc] init];
	payment=[[PaymentResponse alloc] init];
	[payment setMessage:[[NSString alloc] init]];
	[payment setIsError:true];
	
	productList=[[NSMutableArray alloc]init];
    
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	
    [parser setDelegate:self]; // The parser calls methods in this class
    [parser setShouldProcessNamespaces:NO]; 
    [parser setShouldReportNamespacePrefixes:NO]; //
    [parser setShouldResolveExternalEntities:NO]; 
	
    [parser parse]; // Parse that data..

    [parser release];
}

-(void) parserDidStartDocument:(NSXMLParser *)parser
{
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
	DLog(@"Finalizo parser");
	DLog(@"productlist %i ,%@",[productList count],productList );
	for (FindItemModel *item in productList) {
		DLog(@"itemmodel ,%@",item.description );
		/*for (Promotions *promos in item.discounts) {
			DLog(@"promos in itemmodel %i ,%@", [item.discounts count],promos.promoDescription );
			DLog(@"promos in itemmodel %@", promos.promoBaseAmount );
			DLog(@"promos in itemmodel %@", promos.promoDiscountPercent );
			DLog(@"promos in itemmodel %@", promos.promoTypeBenefit );
            
		}*/
	}
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	currentElement=elementName;
	
	if ([currentElement isEqualToString:PRODUCTOS]) {
		itemModel =[[FindItemModel alloc]init];
		[productList addObject:itemModel];
		[itemModel release];
		DLog(@"currentelement payparser producto: %@",currentElement);
		
	}
    	
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (!string) {
		string=@"";
	}
    if ([currentElement isEqualToString:ISERROR]) {
		if([string isEqualToString:@"false"]){
			[payment setIsError:false];
		}else {
			[payment setIsError:true];
	
		}
	}else if ([currentElement isEqualToString:MESSAGE]) {
		[payment setMessage:[payment.message stringByAppendingString:string]];
        
	}
	///******************product**************************************
    if ([currentElement isEqualToString:BARCODE]) {
		itemModel.barCode=[[string copy]autorelease];
	}
	if ([currentElement isEqualToString:BRAND]) {
		itemModel.brand=[[string copy]autorelease];
        
	}
	if ([currentElement isEqualToString:DEPARTMENT]) {
		itemModel.department=[[string copy]autorelease];
        
	}
	if ([currentElement isEqualToString:GENERIC]) {
		itemModel.generic=[[string copy]autorelease];
        
	}
	if ([currentElement isEqualToString:ITEMCOUNT]) {
		itemModel.itemCount=[[string copy]autorelease];
        
	}
	if ([currentElement isEqualToString:ITEMTYPE]) {
		itemModel.itemType=[[string copy]autorelease];
        
	}
	if ([currentElement isEqualToString:LINETYPE]) {
		itemModel.lineType=[[string copy]autorelease];
        
	}
	if ([currentElement isEqualToString:PRICE]) {
		itemModel.price=[[string copy]autorelease];
        itemModel.priceExtended=[[string copy]autorelease];
		
	}
	if ([currentElement isEqualToString:DESCRIPTION]) {
		itemModel.description=[[string copy]autorelease];
		
	}
	if ([currentElement isEqualToString:PROMOTION]) {
		
		if ([string isEqualToString:@"false"])
			itemModel.promo=true;
		if ([string isEqualToString:@"true"])
			itemModel.promo=true;
        
	}
    else if ([currentElement isEqualToString:FECHA_ENTREGA]) {
        [itemModel setDeliveryDate:string];
        
	}


}

-(NSString*) getMessageResponse{
	return [payment message];
}
-(BOOL) getStateOfMessage{
	DLog(@"payparserMesagge %@", payment.message);
	if(![payment isError])
		return YES;
	else 
		return NO;
}
-(NSMutableArray*) returnSaleProductList
{
	return productList;
}
-(void)dealloc
{	
	//[promo release];
	//[productList release];
	//[itemModel release];
	[payment release],payment=nil;
	//[msgResponse release];
	//[currentElement release];
	[super dealloc];
}
@end
