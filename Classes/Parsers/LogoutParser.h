//
//  LogoutParser.h
//  CardReader



#import <Foundation/Foundation.h>


@interface LogoutParser :  NSObject <NSXMLParserDelegate> {
	
	NSString *currentElement;
	NSString *response;
}
@property (nonatomic,retain) 	NSString *currentElement;
@property (nonatomic,retain) 	NSString *response;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void) startParser:(NSData*) data;
-(void) isLogoutSuccesful;
-(NSString*) returnErrorMessage;
@end
