//
//  VFIBTBridge.h
//  VMF
//

#import <Foundation/Foundation.h>
#import	<ExternalAccessory/ExternalAccessory.h>

@class VFIBTBridge;

@interface VFIBTBridge : NSObject {
	
	
	
}

/**
 * Framework Version.
 *
 * Returns VeriFone Mobile Framework Version.
 */
+(NSString* )frameworkVersion;

/**
 * Disable Bluetooth Bridge.
 *
 * This method removes bluetooth support from VMF.
 */
+(void) disableBTBridge;

/**
 * Disable Bluetooth Bridge Status.
 *
 * This method returns bluetooth disabled flag.
 */
+(BOOL) disabledBTBridge;

+(BOOL) notConnected;


+(void) setNoDisconnect:(BOOL)val;
+(BOOL) noDisconnect;



@end
