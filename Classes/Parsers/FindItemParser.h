//
//  Parser.h
//  CardReader


#import <Foundation/Foundation.h>
#import "FindItemModel.h"
#import "Warranty.h"

@interface FindItemParser : NSObject <NSXMLParserDelegate> {

	NSString *currentElement;
	FindItemModel   *findItemModel;
    Warranty        *warranty;
    BOOL            *warrantyFound;
    NSMutableString *detail;
}

@property (nonatomic,retain) 	NSString *currentElement;
@property (nonatomic,retain) 	FindItemModel * findItemModel;
@property (nonatomic, retain)   NSMutableArray *warrantiesList;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                       namespaceURI:(NSString *)namespaceURI
                                      qualifiedName:(NSString *)qName
                                         attributes:(NSDictionary *)attributeDict;
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
                                     namespaceURI:(NSString *)namespaceURI
                                    qualifiedName:(NSString *)qName;
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
-(void)startParser:(NSData*) data;
-(FindItemModel*)getItemObject;
-(BOOL)itemFounded;


@end
