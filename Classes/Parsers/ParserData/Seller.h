//
//  Seller.h
//  CardReader
//


#import <Foundation/Foundation.h>


@interface Seller : NSObject {

	
	NSString *userName;
	NSString *password;
	NSString *name;

}

@property (nonatomic,retain) 	NSString *userName;
@property (nonatomic,retain) 	NSString *password;
@property (nonatomic,retain) 	NSString *name;


@end
