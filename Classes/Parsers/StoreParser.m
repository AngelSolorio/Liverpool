//
//  StoreParser.m
//  CardReader
//
//

#import "StoreParser.h"


@implementation StoreParser
@synthesize storeAddress,currentElement;
#define RETURN		@"return"


-(void) startParser:(NSData*) data
{
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	storeAddress=[[NSString alloc] init];
    
    
    [parser setDelegate:self]; // The parser calls methods in this class
    [parser setShouldProcessNamespaces:NO]; 
    [parser setShouldReportNamespacePrefixes:NO]; 
    [parser setShouldResolveExternalEntities:NO]; 
    [parser parse]; // Parse that data..
    [parser release];
}

-(void) parserDidStartDocument:(NSXMLParser *)parser
{
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	DLog(@"Error %i, Description: %@, Line: %i, Column: %i",
		  [parseError code], [[parser parserError] localizedDescription],
		  [parser lineNumber], [parser columnNumber]);
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
	DLog(@"Finalizo parser");
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	currentElement=elementName;
	//DLog(@"currentElement:%@",currentElement);
	storeAddress=@"";
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (!string) {
		string=@"";
	}
	if ([currentElement isEqualToString:RETURN]) {
        
		storeAddress=[storeAddress stringByAppendingString:string];
	}
}


-(NSString*) getStoreAddress
{
    
    NSData *stringData = [storeAddress dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: YES];
    
    NSString *cleanString = [[[NSString alloc] initWithData: stringData encoding: NSASCIIStringEncoding] autorelease];
    
	return cleanString;
}

-(void)dealloc
{
	//[response release];
    [super dealloc];
}
@end