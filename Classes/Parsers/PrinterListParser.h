//
//  PrinterListParser.h
//  CardReader
//

#import <Foundation/Foundation.h>


@interface PrinterListParser : NSObject <NSXMLParserDelegate> {
	
	NSString *currentElement;
	NSMutableArray *printerArray;
}
@property (nonatomic,retain) 	NSString *currentElement;
@property (nonatomic,retain) 	NSMutableArray *printerArray;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void) startParser:(NSData*) data;
- (NSArray*) returnPrinterList;

@end
