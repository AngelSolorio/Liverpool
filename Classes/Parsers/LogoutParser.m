//
//  LogoutParser.m
//  CardReader


#import "LogoutParser.h"
#import "Tools.h"

@implementation LogoutParser
@synthesize currentElement,response;

#define RETURN		@"return"
#define CODE		@"code"
#define NAME		@"name"


-(void) startParser:(NSData*) data
{
	//-----------------------------------------------------------
	DLog(@"***************************************");
	NSString* aStr;
	aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	DLog(@"Datos %@  ",aStr);
	aStr=nil;
	DLog(@"***************************************");	
	//-----------------------------------------------------------
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	response=[[NSString alloc] init];
	
	
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
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
	DLog(@"Finalizo parser");
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	currentElement=elementName;
	//DLog(@"currentElement:%@",currentElement);
	response=@"";
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (!string) {
		string=@"";
	}
	if ([currentElement isEqualToString:RETURN]) 
		response=[response stringByAppendingString:string];

	
}
-(void) isLogoutSuccesful
{
	//NSString *trimmedResponse=@"";
	if ([response isEqual:@"OK"]) 
	{	
		[Tools displayAlert:@"Aviso" message:@"Cuenta Desbloqueada con exito"];
	}
		else
	{
		[Tools displayAlert:@"Error" message:response];
	}
}
-(NSString*) returnErrorMessage
{
	return response;
}

-(void)dealloc
{
	//[response release];
	[super dealloc];
}
@end