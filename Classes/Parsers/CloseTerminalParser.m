//
//  CloseTerminalParser.m
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 02/08/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import "CloseTerminalParser.h"

@implementation CloseTerminalParser
@synthesize currentElement,response;

#define ISERROR         @"isError"
#define MESSAGE         @"message"
#define ERRORCODE		@"errorCode"
#define COMPUTADOR		@"computador"
#define DEVOLUCION		@"devolucion"
#define DIFERENCIA		@"diferencia"
#define ENTREGADO		@"entregado"
#define CIERRE_DOCTO    @"cierreDocto"
#define VALES_PAPEL     @"valesPapel"
#define PUNTOS_RIFA     @"puntosRifa"
#define TRANS_GUARDADAS @"transGuardadas"


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
	closeData=[[CloseTerminalData alloc]init];
	
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
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (!string) {
		string=@"";
	}
    
	if ([currentElement isEqualToString:ISERROR]) {
		if([string isEqualToString:@"false"])
			closeData.isError=NO;
        else 
			closeData.isError=YES;
    }
    else if ([currentElement isEqualToString:MESSAGE]) {
        closeData.message=[string copy];

	}
    else if ([currentElement isEqualToString:ERRORCODE]) {
        closeData.errorCode=[string copy];
        
	} 
    else if ([currentElement isEqualToString:COMPUTADOR]) {
        closeData.computador=[string copy];
        
	} else if ([currentElement isEqualToString:DEVOLUCION]) {
        closeData.devolucion=[string copy];
        
	} else if ([currentElement isEqualToString:DIFERENCIA]) {
        closeData.diferencia=[string copy];
        
	} else if ([currentElement isEqualToString:ENTREGADO]) {
        closeData.entregado=[string copy];
        
	} else if ([currentElement isEqualToString:CIERRE_DOCTO]) {
        closeData.cierreDocto=[string copy];
        
	} else if ([currentElement isEqualToString:VALES_PAPEL]) {
        closeData.valesPapel=[string copy];
        
	} else if ([currentElement isEqualToString:PUNTOS_RIFA]) {
        closeData.puntosRifa=[string copy];
        
	} else if ([currentElement isEqualToString:TRANS_GUARDADAS]) {
        closeData.transGuardadas=[string copy];
        
	} 
}
-(CloseTerminalData*) returnCloseData
{
    return closeData;
}
-(void)dealloc
{
	[super dealloc];
    [closeData release];
}

@end
