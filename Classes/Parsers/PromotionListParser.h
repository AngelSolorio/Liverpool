//
//  PromotionListParser.h
//  CardReader


#import <Foundation/Foundation.h>
#import "Promotions.h"

@interface PromotionListParser : NSObject <NSXMLParserDelegate>{

	NSString *currentElement;
	NSMutableArray *promotionsArray;
	NSMutableArray *promotionSubGroup;
	Promotions * promos;
	int option;
    NSString *message;
    BOOL isError;
}
@property (nonatomic,retain) 	NSString *currentElement;
@property (nonatomic,retain) 	NSMutableArray *promotionsArray;
@property (nonatomic,retain) 	NSMutableArray *promotionSubGroup;
@property (nonatomic,retain) 	NSString *message;
@property (nonatomic)           BOOL isError;



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void) startParser:(NSData*) data;
- (NSMutableArray*) returnPromoList;
-(NSString*) trimString:(NSString*) aString;

@end