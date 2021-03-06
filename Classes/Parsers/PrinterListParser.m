//
//  PrinterListParser.m
//  CardReader
//

#import "PrinterListParser.h"


@implementation PrinterListParser
@synthesize currentElement,printerArray;


#define RETURN				@"return"

-(void) startParser:(NSData*) data
{
	//currentElement=[[NSString alloc] init];
	//findItemModel=[[FindItemModel alloc] init];
	printerArray=[[NSMutableArray alloc] init];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	
    [parser setDelegate:self]; // The parser calls methods in this class
    [parser setShouldProcessNamespaces:NO]; 
    [parser setShouldReportNamespacePrefixes:NO]; //
    [parser setShouldResolveExternalEntities:NO]; 
	
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
	//DLog(@"currentElement:%@",currentElement);

}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (!string) {
		string=@"";
	}
	if ([currentElement isEqualToString:RETURN]) {
		[printerArray addObject:string];
	}
}
-(NSArray*) returnPrinterList
{
	return printerArray;
}
-(void)dealloc
{
	//[currentElement release];
	[printerArray release];
	[super dealloc];
}
@end
