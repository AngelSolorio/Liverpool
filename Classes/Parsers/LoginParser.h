//
//  LoginParser.h
//  CardReader
//


#import <Foundation/Foundation.h>
@class LoginResponse;
@class Store;
@class AffiliationCodes;
@interface LoginParser : NSObject <NSXMLParserDelegate> {

	NSString *currentElement;
	NSString *response;
	LoginResponse* loginResponse;
    NSMutableArray   *storeList;
    Store* store;
    AffiliationCodes *affCode;
    NSMutableArray *affiliationsNumbers;
}
@property (nonatomic,retain) 	NSString *currentElement;
@property (nonatomic,retain) 	NSString *response;
@property (nonatomic,retain) 	LoginResponse* loginResponse;
@property (nonatomic,retain) 	NSMutableArray   *storeList;
@property (nonatomic,retain) 	NSMutableArray   *affiliationsNumbers;


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void) startParser:(NSData*) data;
-(BOOL) isLoginSuccesful;
-(NSString*) returnErrorMessage;
-(NSString*) returnName;
-(NSString*) getStoreAddress;

@end
