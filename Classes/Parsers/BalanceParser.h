//
//  BalanceParser.h
//  CardReader
//

#import <Foundation/Foundation.h>
@class Balance;

@interface BalanceParser : NSObject <NSXMLParserDelegate>{
	
	NSString *currentElement;
	NSString *response;
	Balance *balanceModel;
	
}
@property (nonatomic,retain) 	NSString *currentElement;
@property (nonatomic,retain) 	NSString *response;
@property (nonatomic,retain)	Balance *balanceModel; 	

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void) startParser:(NSData*) data;
//-(BOOL) isAirtimeSuccesful;
-(NSString*)returnReponseMessage;
-(void) parseInfo:(NSString *)cadena;
-(NSString*) parseCad:(NSString*)aCad from:(NSString*)aString;
@end
