//
//  Error.h
//  CardReader




@interface Error : NSObject {
	NSString* number;
	NSString* description;
}
@property (nonatomic,retain)	NSString* number;	
@property (nonatomic,retain)	NSString* description;
@end
