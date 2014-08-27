//
//  LoginParser.m
//  CardReader
//


#import "LoginParser.h"
#import "LoginResponse.h"
#import "Store.h"
#import "AffiliationCodes.h"
@implementation LoginParser
@synthesize currentElement,response;
@synthesize loginResponse;
@synthesize storeList;
@synthesize affiliationsNumbers;

#define RETURN          @"return"
#define CODE            @"code"
#define NAME            @"name"
#define NOTIENDA        @"noTienda"
#define NOMBRETIENDA		@"nombre"
#define NOMBREIMPRESION		@"nombreImpresion"
#define NOMBRE_BANCO		@"nombreBanco"
#define NUMERO_AFILIACION	@"numeroAfiliacion"



-(void) startParser:(NSData*) data
{
	//-----------------------------------------------------------
	DLog(@"***************************************");
	NSString* aStr;
	aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	DLog(@"Datos %@  ",aStr);
	[aStr release]; // Cambio Ruben - 18/Enero/2012
	aStr=nil;
	DLog(@"***************************************");	
	//-----------------------------------------------------------
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	response=[[NSString alloc] init];
	loginResponse=[[LoginResponse alloc] init];
    
    storeList=[[NSMutableArray alloc]init];
    
    affiliationsNumbers=[[NSMutableArray alloc]init];

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
	DLog(@"Valor %@ - %@ ",loginResponse.code, loginResponse.nameU);
	DLog(@"Error %i, Description: %@, Line: %i, Column: %i",
		  [parseError code], [[parser parserError] localizedDescription],
		  [parser lineNumber], [parser columnNumber]);
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
	DLog(@"Finalizo parser");
	DLog(@"Valor %@ - %@ ",loginResponse.code, loginResponse.nameU);
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	currentElement=elementName;
	response=@"";
    if ([currentElement isEqualToString:@"stores"]) {
        store=[[Store alloc] init];
        [storeList addObject:store];
        [store release];
    }else if ([currentElement isEqualToString:@"affCodes"]) {
        affCode=[[AffiliationCodes alloc] init];
        [affiliationsNumbers addObject:affCode];
        [affCode release];
        
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (!string) {
		string=@"";
	}
	if ([currentElement isEqualToString:RETURN]) {

		response=[response stringByAppendingString:string];
	}
	else if ([currentElement isEqualToString:CODE]) {
		response=[response stringByAppendingString:string];
		[loginResponse setCode:[response copy]] ;
	}
	else if ([currentElement isEqualToString:NAME]) {
		response=[response stringByAppendingString:string];
		[loginResponse setNameU:[response copy]] ;
	}
    else if ([currentElement isEqualToString:NOTIENDA]) {
		store.number=[string copy];
	}
    else if ([currentElement isEqualToString:NOMBRETIENDA]) {
		store.name=[string copy];
	}
    else if ([currentElement isEqualToString:NOMBREIMPRESION]) {
		store.description=[string copy];
	}
    else if ([currentElement isEqualToString:NOMBRE_BANCO]) {
		affCode.bankName=[string copy];
	}
    else if ([currentElement isEqualToString:NUMERO_AFILIACION]) {
		affCode.affiliationNumber=[string copy];
	}
    

}
-(BOOL) isLoginSuccesful
{
	//NSString *trimmedResponse=@"";
	
	if ([loginResponse code]!=nil && [[loginResponse code] length] > 0 ) 
		{	
			
			if ([[loginResponse code] isEqualToString:@"OK"]) 
				return YES;
			else 
				return NO;
		}
	else
		{response=@"Error de Conexion Con el Servidor Bridgecore";
			return NO;
		}
}
-(NSString*) returnErrorMessage
{
	return [loginResponse code];
}

-(NSString*) returnName
{
	NSString *trimmedResponse;
	
	if ([loginResponse nameU]!=nil && [[loginResponse nameU] length] > 0 ) 
		trimmedResponse=[loginResponse nameU];
	else 
		trimmedResponse=@"Error de Conexion Con el Servidor Bridgecore";
	
	DLog(@"returnName %@",trimmedResponse);
	return trimmedResponse;
}
-(NSString*) getStoreAddress
{
    return [loginResponse nameU];
}

-(void)dealloc
{
    [affiliationsNumbers release];
	//[response release];
    [storeList release];
	[loginResponse release],loginResponse=nil;
	[super dealloc];
}
@end