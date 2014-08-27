//
//  LoginResponse.h
//  CardReader


#import <Foundation/Foundation.h>

@interface LoginResponse : NSObject {

	NSString* code;
	NSString* nameU;


}
@property (nonatomic,retain)	NSString* code;
@property (nonatomic,retain)	NSString* nameU;

@end
