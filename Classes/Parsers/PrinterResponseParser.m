//
//  PrinterResponseParser.m
//  CardReader
//


#import "PrinterResponseParser.h"


@implementation PrinterResponseParser
@synthesize msgResponse,currentElement,urlPDF;


#define RETURN				@"return"
#define URL					@"url"

-(void) startParser:(NSData*) data
{
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
	DLog(@"currentElement:%@",currentElement);
	
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (!string) {
		string=@"";
	}
	if ([currentElement isEqualToString:RETURN]) {
		msgResponse=[string copy];
	}
}
-(BOOL) getStateOfMessage{
	
	NSString *trimmedResponse=[msgResponse substringToIndex:2];
	if([trimmedResponse isEqual:@"OK"])
		return YES;
	else 
		return NO;
}
-(NSString*) returnErrorMessage
{
	return msgResponse;
}
-(NSString*) returnURLPDF
{
	
	NSString *trimmedURL=[msgResponse substringFromIndex:3];
	//DLog(@"parser URL pdf:%@",trimmedURL);
	return trimmedURL;
}
-(void)dealloc
{
	[msgResponse release];
	[urlPDF release];
	//[currentElement release];
	[super dealloc];
}
@end
