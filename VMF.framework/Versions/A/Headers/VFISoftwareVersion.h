

#import <Foundation/Foundation.h>

/**
 * Encapsulating data class utilized by VFIControl
 */
@interface VFISoftwareVersion : NSObject {
	NSString *AppMajor;                 //!< Software Version - Major
	NSString *AppMinor;                 //!< Software Version - Minor
	NSString *AppBuild;                 //!< Software Version - Build
	NSString *OSPlatform;               //!< Software OS Platform
	NSString *OSID;                     //!< Software Identification
	NSString *OSVersion;                //!< Software Version - Main
	NSString *OSSubVersion;             //!< Software Version - Sub
	
	
}
/**
 * clears all VFISoftwareVersion properties
 */
-(void)clear;



@property (nonatomic, retain) NSString *AppMajor;
@property (nonatomic, retain) NSString *AppMinor;
@property (nonatomic, retain) NSString *AppBuild;
@property (nonatomic, retain) NSString *OSPlatform;
@property (nonatomic, retain) NSString *OSID;
@property (nonatomic, retain) NSString *OSVersion;
@property (nonatomic, retain) NSString *OSSubVersion;

@end



