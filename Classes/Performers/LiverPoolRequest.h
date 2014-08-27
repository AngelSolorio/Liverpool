//
//  LiverPoolRequest.h
//  LiverPoolClient
//
//  Created by Gonet on 03/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	buyRequest,
	firstPaymentRequest,
	secondPaymentRequest,
	findRequest,
	findPrinters,
	printingRequest,
	findPromoRequest,
	consultSKURequest,
	loginRequest,
	airtimeRequest,
	logoutRequest,
	bRequest,
	loginPrinterRequest,
	totalizeRequest,
	buyRequest2,
    addressRequest,
    storeListRequest,
    adminLoginRequest,
    unregisterRequest,
    SOMSRequest,
    SOMSListRequest,
    closeTerminalRequest,
    restaurantListRequest,
    restaurantRequest,
    cancelRequest,
    refundRequest,
    cancel_Payment,
    withdraw_Request
} RequestType;

@protocol WsCompleteDelegate <NSObject>
-(void) performResults:(NSData*) receivedData :(RequestType)requestType;
@end


@interface LiverPoolRequest : NSObject <UIWebViewDelegate> {
	NSMutableData *	receivedData;
	RequestType requestType;
	
	id <WsCompleteDelegate> delegate;
	
	NSTimer *timerRequest;
}
@property (nonatomic,retain) 	NSMutableData *	receivedData;
@property (nonatomic)			RequestType requestType;
@property (nonatomic,retain)	id <WsCompleteDelegate> delegate;



//-(NSString*) createEnvelope:(NSString*) method;
-(void) sendRequest:(NSString*) requestName forParameters:(NSArray*)parameters forRequestType:(RequestType) reqType;
- (void)startRequest;
- (NSString*) createEnvelope: (NSString*) method forParameters: (NSArray*) params; 
-(NSArray*) buildParameterNodes;
-(NSString*) buildParameterBody:(NSArray*)parameters;
-(void) timerRequestValidation;
-(void) invalidateTimer;
@end
