//
//  CloseTerminalParser.h
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 02/08/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CloseTerminalData.h"
@interface CloseTerminalParser : NSObject <NSXMLParserDelegate>
{
    NSString *currentElement;
    CloseTerminalData *closeData;
}
@property (nonatomic,retain) 	NSString *currentElement;
@property (nonatomic,retain) 	NSString *response;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void) startParser:(NSData*) data;


-(CloseTerminalData*) returnCloseData;

@end
