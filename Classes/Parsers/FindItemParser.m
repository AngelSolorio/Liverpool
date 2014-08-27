//
//  Parser.m
//  CardReader
//

#import "FindItemParser.h"
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

@implementation FindItemParser
@synthesize currentElement,findItemModel;

-(void) startParser:(NSData*) data
{
	//currentElement=[[NSString alloc] init];
	findItemModel=[[FindItemModel alloc] init];
	findItemModel.promo=YES;
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	
    [parser setDelegate:self]; // The parser calls methods in this class
    [parser setShouldProcessNamespaces:NO]; // We don't care about namespaces
    [parser setShouldReportNamespacePrefixes:NO]; //
    [parser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
	
    [parser parse]; // Parse that data..
	
	/*NSError *err;
    if (err && [parser parserError]) {
        err = [parser parserError];
    }
	*/
    [parser release];
}

-(void) parserDidStartDocument:(NSXMLParser *)parser
{
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
	DLog(@"Finalizo parser");
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	currentElement=elementName;
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (!string) {
		string=@"";
	}
	if ([currentElement isEqualToString:BARCODE]) {
		findItemModel.barCode=[[string copy]autorelease];
	}
	if ([currentElement isEqualToString:BRAND]) {
		findItemModel.brand=[[string copy]autorelease];

	}
	if ([currentElement isEqualToString:DEPARTMENT]) {
		findItemModel.department=[[string copy]autorelease];

	}
	if ([currentElement isEqualToString:GENERIC]) {
		findItemModel.generic=[[string copy]autorelease];

	}
	if ([currentElement isEqualToString:ITEMCOUNT]) {
		findItemModel.itemCount=[[string copy]autorelease];

	}
	if ([currentElement isEqualToString:ITEMTYPE]) {
		findItemModel.itemType=[[string copy]autorelease];

	}
	if ([currentElement isEqualToString:LINETYPE]) {
		findItemModel.lineType=[[string copy]autorelease];

	}
	if ([currentElement isEqualToString:PRICE]) {
		findItemModel.price=[[string copy]autorelease];
        findItemModel.priceExtended=[[string copy]autorelease];
		
	}
	if ([currentElement isEqualToString:DESCRIPTION]) {
		//findItemModel.description=[[string copy]autorelease];
        findItemModel.description=[findItemModel.description stringByAppendingString:string]; //fix 1.4.4

	}
	if ([currentElement isEqualToString:PROMOTION]) {
		
		if ([string isEqualToString:@"false"]) //patch 1.4.5 rev3 shorter response time
			findItemModel.promo=false;
		if ([string isEqualToString:@"true"]) 
			findItemModel.promo=false;
	
	}
 
	
}
-(FindItemModel*) getItemObject
{
	return findItemModel;
}
-(BOOL) itemFounded
{
	if ([findItemModel.description isEqualToString:@"No encontrado"])
		return NO;
	else
		return YES;
}

-(void)dealloc
{
	[findItemModel release];
//	[currentElement release];
	[super dealloc];
}
@end
