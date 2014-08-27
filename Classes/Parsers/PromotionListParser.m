//
//  PromotionListParser.m
//  CardReader

#import "PromotionListParser.h"


@implementation PromotionListParser
@synthesize currentElement,promotionsArray,promotionSubGroup;
@synthesize isError;
@synthesize message;

#define	DISPLAYMESSAGE			@"displayMessage"
#define DISPLAYPRINTERMESSAGE	@"printerMessage"
#define PROMOCIONES				@"promociones"
#define APLICATION_METHOD		@"applicationMethod"
#define BASE_AMOUNT				@"baseAmount"
#define MAGNITUDE				@"magnitude"
#define QTY						@"qty"
#define VALUE					@"value"
#define DISCOUNT_PERCENTAGE		@"discountPercentage"
#define PRORATION_METHOD		@"prorationMethod"
#define INSTALLMENTS			@"installments"
#define FACTOR					@"factor"
#define PLAN_ID					@"planId"
#define TYPE					@"type"
#define PREFIX					@"prefix"
#define EXCLUDE_PREFIX			@"excludedPrefix"
#define TENDER					@"tender"
#define BANK					@"bank"
#define MESSAGE					@"message"
#define IS_ERROR				@"isError"

-(void) startParser:(NSData*) data
{
	promotionsArray=[[NSMutableArray alloc] init];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	message=@"";
    [parser setDelegate:self]; // The parser calls methods in this class
    [parser setShouldProcessNamespaces:NO]; 
    [parser setShouldReportNamespacePrefixes:NO]; 
    [parser setShouldResolveExternalEntities:NO]; 
	
    [parser parse]; // Parse that data..
    [parser release];
}

-(void) parserDidStartDocument:(NSXMLParser *)parser
{
	option=1;

}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
	//DLog(@"promotionSubGroup count:%i, %@",[promotionsArray count],promotionsArray);
	DLog(@"Finalizo parser");
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	currentElement=elementName;

		NSString* type=[attributeDict objectForKey:@"xsi:type"];
		if ([type isEqualToString:@"ns2:group"]) 
		{	

			promotionSubGroup=[[NSMutableArray alloc] init];
			[promotionsArray addObject:promotionSubGroup];
			[promotionSubGroup release];
			/*
			promos=[[Promotions alloc]init];
			[promotionSubGroup addObject:promos];
			[promos release];
			
			promos.header=[[NSString stringWithFormat:@"OPCION:%i",option] copy];
			option++;*/
			//DLog(@"agregando grupo promo:%@",promotionsArray);

		}
		else if([currentElement isEqualToString:PROMOCIONES])
		{	
			promos=[[Promotions alloc]init];
			[promotionSubGroup addObject:promos];
			[promos release];
			promos.promoTypeBenefit=[[self trimString:type] copy];
			//DLog(@"agregando promo:%@",promotionSubGroup);

		}
		//DLog(@"promo.promTypeBenefit:%@",promos.promoTypeBenefit);
	
	
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (!string) {
		string=@"";
	}
	if ([currentElement isEqualToString:DISPLAYMESSAGE]) {
		promos.promoDescription=[string copy];
	}
	if ([currentElement isEqualToString:DISPLAYPRINTERMESSAGE]) {
		promos.promoDescriptionPrinter=[string copy];
	}
	if ([currentElement isEqualToString:APLICATION_METHOD]) {
		promos.promoAplicationMethod=[string copy];
	}
	if ([currentElement isEqualToString:BASE_AMOUNT]) {
		promos.promoBaseAmount=[string copy];
	}
	if ([currentElement isEqualToString:MAGNITUDE]) {
		promos.promoMagnitude=[string copy];
	}
	if ([currentElement isEqualToString:QTY]) {
		promos.promoQty=[string copy];
	}
	if ([currentElement isEqualToString:VALUE]) {
		promos.promoValue=[string copy];
	}
	if ([currentElement isEqualToString:DISCOUNT_PERCENTAGE]) {
		promos.promoDiscountPercent=[string copy];
	}
	if ([currentElement isEqualToString:PRORATION_METHOD]) {
		promos.promoProrationMethod=[string copy];
	}
	if ([currentElement isEqualToString:INSTALLMENTS]) {
		promos.promoInstallment=[string copy];
	}
	if ([currentElement isEqualToString:FACTOR]) {
		promos.promoDiscountPercent=[string copy];
	}
	if ([currentElement isEqualToString:PLAN_ID]) {
		promos.planId=[string copy];
	}
	if ([currentElement isEqualToString:TYPE]) {
		promos.promoTypeMonedero=[string copy];
	}
	if ([currentElement isEqualToString:PREFIX]) {
		promos.promoPrefixs=[string copy];
	}
	if ([currentElement isEqualToString:EXCLUDE_PREFIX]) {
		promos.promoExcludePrefixs=[string copy];
	}
	if ([currentElement isEqualToString:TENDER]) {
		promos.promoTender=[string copy];
	}
	if ([currentElement isEqualToString:MESSAGE]) {
		//message=[string copy];
        message=[message stringByAppendingString:string]; //fix 1.4.5
	}
    if ([currentElement isEqualToString:IS_ERROR]) {
		isError=([string isEqualToString:@"true"] ? YES : NO);
	}
}
- (NSMutableArray*) returnPromoList
{
	return promotionsArray;
}

-(NSString*) trimString:(NSString*) aString
{
	aString=[aString substringFromIndex:4];
	return aString; 
}
-(void)dealloc
{
	//[promos release];
    //[message release];
	[promotionsArray release];
	[super dealloc];
}
@end