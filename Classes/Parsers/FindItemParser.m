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
#define FREE                @"free"

#define WARRANTIES          @"warranties"
#define COST                @"cost"
#define DETAIL              @"detail"
#define ID                  @"id"
#define PERCENTAGE          @"percentage"
#define SKU                 @"sku"

@implementation FindItemParser
@synthesize currentElement;
@synthesize findItemModel;
@synthesize warrantiesList;

-(NSMutableArray *)warrantiesList
{
    if(!warrantiesList) warrantiesList = [[NSMutableArray alloc] init];
    return warrantiesList;
}

-(void) startParser:(NSData*) data
{
	//currentElement=[[NSString alloc] init];
	self.findItemModel=[[FindItemModel alloc] init];
	self.findItemModel.promo=YES;
    NSString *xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	
    [parser setDelegate:self]; // The parser calls methods in this class
    [parser setShouldProcessNamespaces:NO]; // We don't care about namespaces
    [parser setShouldReportNamespacePrefixes:NO]; //
    [parser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
	
    [parser parse]; // Parse that data..
    [parser release];
}

-(void) parserDidStartDocument:(NSXMLParser *)parser
{
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
	DLog(@"Finalizo parser");
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"end current element %@",elementName);
    if ([elementName isEqualToString:WARRANTIES]) {
        warrantyFound = NO;
    } else if ([elementName isEqualToString:DETAIL]){
        [detail release];
    }
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	currentElement=elementName;
    NSLog(@"Current Element %@",currentElement);
    if([currentElement isEqualToString:WARRANTIES]) {
        warrantyFound = YES;
        warranty = [[Warranty alloc] init];
        [self.warrantiesList addObject:warranty];
        [warranty release];
    } else if ([currentElement isEqualToString:DETAIL]){
        detail = [[NSMutableString alloc] init];
    }
    
}

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
    if ([currentElement isEqualToString:FREE]) {
        if ([string isEqualToString:@"false"]) //patch 1.4.5 rev3 shorter response time
            findItemModel.isFree = false;
        if ([string isEqualToString:@"true"])
            findItemModel.isFree = true;
    }
	if ([currentElement isEqualToString:LINETYPE]) {
		findItemModel.lineType=[[string copy]autorelease];
        //[string stringbyadd
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
    if (warrantyFound) {
        if ([currentElement isEqualToString:ID]) {
            warranty.warrantyId =[[string copy] autorelease];
        } else if ([currentElement isEqualToString:COST]){
            warranty.cost = [[string copy] autorelease];
        } else if ([currentElement isEqualToString:DETAIL]){
            [detail appendString:string];
            NSLog(@"Detail %@",detail);
            warranty.detail =detail;
        } else if ([currentElement isEqualToString:SKU]){
            warranty.sku = [[string copy] autorelease];
        } else if ([currentElement isEqualToString:PERCENTAGE]){
            warranty.percentage = [[string copy] autorelease];
        } else if ([currentElement isEqualToString:DEPARTMENT]){
            warranty.department = [[string copy] autorelease];
        }
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
