//
//  StoreParser.h
//  CardReader
//
//

#import <Foundation/Foundation.h>


@interface StoreParser : NSObject <NSXMLParserDelegate>{

	NSString *storeAddress;
    NSString *currentElement;

}
@property (nonatomic,retain) 	NSString *currentElement;
@property (nonatomic,retain) 	NSString *storeAddress;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void) startParser:(NSData*) data;
- (NSString*) getStoreAddress;
@end
