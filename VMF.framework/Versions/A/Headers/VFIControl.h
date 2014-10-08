


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import	<ExternalAccessory/ExternalAccessory.h>
#import "VFISoftwareVersion.h"
#import "VFIKeypadVersion.h"
#import "VFIAccessoryMgr.h"
#import "VFIStream.h"

/** Protocol methods established for VFIControl class **/
@protocol VFIControlDelegate <NSObject>

@optional
- (void) controlLogEntry:(NSString*)logEntry withSeverity:(int)severity; //!<When VFIControl::logEnabled: is passed <c>TRUE</c>, this delegate will receive log entries.
//!< @param logEntry The log entry
//!< @param severity The severitry of the log entry, with 0 indicating highest priority


- (void) controlInitialized:(BOOL)isInitialized;//!<Notifies of initialization state changes in e210/e255/e315 Control Application
//!< @param isInitialized Device initialization state change
//!<- <c>TRUE</c> successfully initialized the control application,
//!<- <c>FALSE</c> control application went offline.

- (void) controlReconnectStarted;//!<When the External Accessory reports the control application is detected (but not initialized by framework),this delegate is called. This signifies the beginning of the framework initialization proess of the control application.

- (void) controlReconnectFinished;//!<This signifies the end of the framework initialization process for control application.

- (void) controlConnected:(BOOL)isConnected;//!<Notified of control connection/disconnection events.  A connect/disconnect can either be from a physical disconnection/connection with the External Accessory API, or from an application going to backround or returning to foreground.
//!< @param isConnected A new connection or disconnection was detected
//!<- <c>TRUE</c> The control application has connected.
//!<- <c>FALSE</c> The control application has disconnected.

- (void) controlSerialData:(NSData*)data  incoming:(BOOL)isIncoming; //!<All incoming/outgoing data going to the control application can be monitored through this delegate.
//!< @param data The serial data represented as a NSData object
//!< @param isIncoming The direction of the data
//!<- <c>TRUE</c> specifies data being received from control application,
//!<- <c>FALSE</c> indicates data being sent to control application.

- (void) controlDataReceived:(NSData*)data;//!<This delegate monitors all data received from Control Application.
//!< @param data A NSData binary object representing the incoming data from the control application.

- (void) controlDataSent:(NSData*)data;//!<This delegate monitors all data sent from Control Application.
//!< @param data A NSData binary object representing the outgoing data sent the control application.

- (void) controlBatteryLevel:(int)batteryLevel;
//!< @param batteryLevel A integer representing the battery level after calling queryBatteryLevel().

- (void) controlSoftwareVersion:(VFISoftwareVersion*)softwareVersion;
//!< @param softwareVersion VFISoftwareVersion() representing the software version after calling querySoftwareVersion().

- (void) controlKeypadVersion:(VFIKeypadVersion*)keypadVersion;
//!< @param keypadVersion VFIKeypadVersion() representing the keypad version after calling queryKeypadVersion().

@end

/**
 * POWER_STATUS structure.
 *
 * Structure to hold IAP Manager power status returned from getPowerStatus().
 */
typedef struct {
    bool HOST_PWR;                //!<On Battery Power
    bool EXT_PWR;                 //!<On External Power
    bool POWERSHARE_ON;           //!<Power Share Currently Active
    bool DATA_SYNC_EN;            //!<Data Sync is enabled
    bool IDEVICE_PRESENT;         //!<iDevice is connected to terminal
    bool GANG_CHARGER;            //!<terminal on gang charger
}POWER_STATUS;


/**
 * API methods for e210/e255/e315 Pinpad Control.
 *
 * Implementing this class will allow access to API calls that will perform e210/e255/e315 Pinpad control, such as keypad beep on or off.
 */
@interface VFIControl : NSObject < EAAccessoryDelegate, NSStreamDelegate,UIApplicationDelegate> {
	
	id <VFIControlDelegate> delegate;


}
/**
 * Creates an instance of VFIControl class.
 *
 * @retval <id> of VFIControl class
 *
 * Example Usage:
 * @code
 *    VFIControl* control = [[VFIControl alloc] init];
 * @endcode
 */

-(id)init;

/**
 * Initializes the control application.
 *
 * This is executed after the instance is created with init. If any of the optional protocols will be used, setDelegate should first be executed.
 *
 * Example Usage:
 * @code
 *    VFIControl* control = [[VFIControl alloc] init];
 *    [control setDelegate:self];
 *    [control initDevice];
 * @endcode
 */
-(void) initDevice;
/*
 * Initializes the control application via a remote socket connection. The initial connection must have already been established through VFIPinpad initDeviceOnServer:(NSString*)address port:(int)port
 *
 * This is executed after the instance is created with init. If any of the optional protocols will be used, setDelegate should first be executed.
 *
 * Example Usage:
 * @code
 *    VFIControl* control = [[VFIControl alloc] init];
 *    [control setDelegate:self];
 *    [control initDevice];
 * @endcode
 */
-(void) initDeviceOnServer;
/**
 * Terminates stream connection to Control application
 *
 * This method will shut down the connection to the Control stream. An initDevice() will need to be executed again to engage a new stream connection.
 */
-(void) closeDevice;

/**
 * Send a string command to Control application
 *
 * Sends a command represented by the provide string object to the control application through the accessory protocol.
 *
 * @param cmd NSString representation of command to execute
 */
-(void) sendCommand:(NSString*)cmd;

/**
 * Send a string command to Control application
 *
 * Sends a command represented by the provide command string to the control application through the accessory protocol. An LRC is calculated and appended to the command string sent.
 *
 * @param cmd NSString representation of command to execute
 */
-(void) sendCommandLRC:(NSString*)cmd;

/**
 * API method to disable keypad when USB power is plugged in.
 *
 * @param isDisabled
 * - <c>TRUE</c> Disable keypad on USB Power
 * - <c>FALSE</c> Enable keypad on USB Power
 */
-(void) disableKeypadOnUSBPower:(BOOL)isDisabled;

/**
 * API method to enable or disable the keypad. This method is for e210 only.  Has no function on e255/e315
 *
 * @param isEnabled 
 * - <c>TRUE</c> Enable keypad
 * - <c>FALSE</c> Disable keypad
 */
-(void) keypadEnabled:(BOOL)isEnabled;

/**
 * API method to enable or disable the iOS device charging from e210/e255/e315 battery.
 *
 * @param isEnabled
 * - <c>TRUE</c> iOS device will use e210/e255/e315 to charge internal iOS battery.
 * - <c>FALSE</c> iOS device will NOT use e210/e255/e315 to charge internal iOS battery.
 */
-(void) hostPowerEnabled:(BOOL)isEnabled;

/**
 * API method to enable or disable the keypad beep that sounds whenever a key is pressed on the e210/e255/e315 PINPad.
 *
 * @param isEnabled
 * - <c>TRUE</c> Enable beep
 * - <c>FALSE</c> Disable beep
 */
-(void) keypadBeepEnabled:(BOOL)isEnabled;

/**
 * API method to power down e210/e255/e315.
 */
-(void) powerDown;

/**
 * Queries e210/e255/e315 for current battery level.  Result in battery percentage 0-100 stored in VFIControl property batteryLevel()
 */
-(void) queryBatteryLevel;

/**
 * Queries e210/e255/e315 for current control software version.  Result as VFISoftwareVersion stored in VFIControl property vfiSoftwareVersion()
 */
-(void) querySoftwareVersion;

/**
 * Queries e210/e255/e315 for current e210/e255/e315 keypad version.  Result as VFIKeypadVersion stored in VFIControl property vfiKeypadVersion()
 */
-(void) queryKeypadVersion;

/**
 Get Keypad State
 
 * Queries e210/e255/e315 for current keypad state.  Result as returned as a two-digit NSString
 
 @retval 2 Digit Code for Keypad State- Enable_State-Beep_State
  - Enable_State: 0 if keypad is disabled, 1 if keypad is enabled and awake, 2 if keypad is enabled, but still waking up.
  - Beep_State: 0 if beeps are disabled, 1 if beeps are enabled.
 
 Example, "10" is keypad enabled, beeps disabled.
 */
-(NSString*) getKeypadState;

/**
 Get Bluetooth Firmware Version
 
 * Queries e255 to read the firmware version of the Bluetooth module.
 
 @retval An ASCII string containing the version information.
 */
-(NSString*) getBTFirmwareVersion;

/**
 Get Bluetooth Friendly Name
 
This command allows the phone to read the friendly name of the Bluetooth module. The friendly name is the name that is displayed when discovering and pairing to e255. Use the *BT_NAME variable to change the name.
 
 @retval An ASCII string containing the friendly name.
 */
-(NSString*) getBTFriendlyName;

/**
 Get Bluetooth PIN
 
This command allows the phone to read the PIN number of the Bluetooth module. The pin number may not be required when Secure Simple Pairing is enabled. Use the *BT_PIN variable to change the PIN.
 
 @retval A 4 digit numeric ASCII PIN number string.
 */
-(NSString*) getBTPIN;

/**
 Get Power Status
 
 Returns IAP Manager power status.
 
 @retval A POWER_STATUS structure populated with IAP Manager Power Status.
 */
-(POWER_STATUS) getPowerStatus;
/**
 Get Bluetooth SPP Enable
 
This command allows the phone to read the enable state of the Secure Simple Pairing mode in the Bluetooth module. Enabling SSP allows some devices to pair to e255 without a PIN number. Some devices require SSP to be disabled in order to pair. Use the *BT_SSP_EN variable to change the setting.
 
 @retval TRUE = SPP Enabled, FALSE = SPP Disabled
 */
-(BOOL) getBTSPPEnable;


/**
 * Enabled logging to XCode Console.
 *
 * @param enable Setting \a TRUE enables additional logging to debug console window in iOS
 */
-(void) consoleEnabled:(BOOL)enable;

/**
 * Enabled logging to delegate.
 *
 * @param enable Setting \a TRUE enables logging to VFIControlDelegate::controlLogEntry:withSeverity:()
 */
-(void) logEnabled:(BOOL)enable;

/**
 * Controls the restart loop delay
 *
 * @param sec The amount of time in fractional sections to wait between attempts in establishing contact to e210/e255/e315 while waiting for initialization
 *
 * Default is 1.0 seconds.
 */
-(void) restartLoopDelay:(float)sec;

/**
 * Controls the amount of looping attempts to contact control application.
 *
 * @param loop The number of loops in establishing contact to e210/e255/e315 while waiting for initialization
 *
 * If the e210/e255/e315 is unresponsive, the framework will loop the specified number of times, with a delay of restartLoopDelay:() between each attempt. The default is 59 loops.
 */
-(void) setInitLoop:(int) loop;
/**
 * Renables default blocking on all API methods
 *
 * By default blocking is on. Most API calls will wait for a response from Control app before returning control to integrator.  This behavior can be turned off by calling disableBlocking()
 */
-(void) enableBlocking;

/**
 * Disables default blocking on all API methods
 *
 * By default blocking is on. Most API calls will wait for a response from Control app before returning control to integrator.  This behavior can be turned off by calling this method.  Default blocking can be turned back on by calling enableBlocking()
 */
-(void) disableBlocking;

/**
 * Get Power Mode
 *
 * This command returns the state of “Enable Host Power”.

 * @retval Power Mode:
 * - FALSE: Power to host device disabled
 * - TRUE: Host power enabled
 */
-(bool) isHostPowerEnabled;

/**
 * INTERNAL USE ONLY: Allows access for VFIBTBridge calls.
 *
 * Do not call this method directly.  This is exposed for VFIBTBridge to pass data to when communicating with e255
 *
 *
 */
-(void)processReceivedData:(NSData*)data;
/**
 * INTERNAL USE ONLY: Allows access for VFIBTBridge calls.
 *
 * Do not call this method directly.  This is exposed for VFIBTBridge to pass data to when communicating with e255
 *
 *
 */
+ (VFIControl *)sharedController;

/**
 * INTERNAL USE ONLY: Allows access for VFIBTBridge calls.
 *
 * Do not call this method directly.  This is exposed for VFIBTBridge to pass data to when communicating with e255
 *
 *
 */
-(void) ignoreDisconnect;

/**
 * INTERNAL USE ONLY: Allows access for VFIBTBridge calls.
 *
 * Do not call this method directly.  This is exposed for VFIBTBridge to pass data to when communicating with e255
 *
 *
 */
-(void) disableProtocol:(BOOL)disable;
/**
 * INTERNAL USE ONLY: Allows access for VFIBTBridge calls.
 *
 * Do not call this method directly.  This is exposed for VFIBTBridge to pass data to when communicating with e255
 *
 *
 */
- (void) sendData:(NSData*)data;


@property (retain) id<VFIControlDelegate>  delegate;                //!< Gets or Sets delegate for protocols
@property (nonatomic, readonly) NSString *controlName;              //!< Read Only name reported to External Accessory
@property (nonatomic, readonly) NSString *controlManufacturer;      //!< Read Only Manufacturer reported to External Accessory 
@property (nonatomic, readonly) NSString *controlModelNumber;       //!< Read Only Model Number reported to External Accessory
@property (nonatomic, readonly) NSString *controlSerialNumber;      //!< Read Only Serial Number reported to ExternalExternal AccessoryAccessory
@property (nonatomic, readonly) NSString *controlFirmwareRevision;  //!< Read Only Firmware Version reported to External Accessory
@property (nonatomic, readonly) NSString *controlHardwareRevision;  //!< Read Only Hardware Version reported to External Accessory
@property (readonly) int batteryLevel;                              //!< contains result after running VFIControl::queryBatteryLevel
@property (readonly) BOOL controlConnected;                         //!< Read Only Boolean control connection status
@property (readonly) BOOL connected;                                //!< Read Only Boolean control connection status
@property (nonatomic, readonly) EAAccessory *eaACC;                 //!< Read Only Connected Accessory
@property (readonly) BOOL BTconnected;                              //!< Read Only Boolean barcode e210/e255/e315 Bluetooth connection Status
@property (nonatomic, retain) VFISoftwareVersion *vfiSoftwareVersion;//!< contains result after running VFIControl::querySoftwareVersion
@property (nonatomic, retain) VFIKeypadVersion *vfiKeypadVersion;   //!< contains result after running VFIControl::queryKeypadVersion

@property (readonly) BOOL initialized;                              //!< Read Only Boolean control initialized
@property (readonly) BOOL isGen3;                                   //!< Read Only Boolean Gen3 Connected




@end

