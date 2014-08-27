//
//  Balance.h
//  CardReader


#import <Error.h>

@interface Balance : NSObject {
	Error* error;
	NSString* nc;
	NSString* sa;
	NSString* suc;
	NSString* sv;
	NSString* svc;
	NSString* pm;
	NSString* pmni; 
	NSString* flp;
	NSString* tipoCuenta; 
	NSString* pm_sinrefin; 
	NSString* pm_conrefin;
	NSString* fe;

}

@property (nonatomic,retain)	Error* error; 	
@property (nonatomic,retain)	NSString* nc;
@property (nonatomic,retain)	NSString* sa;
@property (nonatomic,retain)	NSString* suc;
@property (nonatomic,retain)	NSString* sv;
@property (nonatomic,retain)	NSString* svc;
@property (nonatomic,retain)	NSString* pm;
@property (nonatomic,retain)	NSString* pmni; 
@property (nonatomic,retain)	NSString* flp;
@property (nonatomic,retain)	NSString* tipoCuenta; 
@property (nonatomic,retain)	NSString* pm_sinrefin; 
@property (nonatomic,retain)	NSString* pm_conrefin;
@property (nonatomic,retain)	NSString* fe;

-(BOOL) isError;
@end
