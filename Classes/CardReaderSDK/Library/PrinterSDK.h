/** @defgroup G_PRINTER Printer SDK
 Provides access to PP-60, DPP-250 and DPP-350 printers.
 In order to use PrinterSDK in your program, several steps have to be performed:
 - Include PrinterSDK.h and libdtdev.a in your project.
 - Go to Frameworks and add ExternalAccessory framework
 - Edit your program plist file, add new element and select "Supported external accessory protocols" from the list, then add two items to it -
 com.datecs.printer.escpos and com.datecs.iserial.communication
 @{
 */

#import <UIKit/UIKit.h>

#define PRINTER_NO_EXCEPTIONS

/**
 Connection state
 */
#ifndef STRUCTURES_DEFINED
#define STRUCTURES_DEFINED
enum CONNSTATES{
	CONN_DISCONNECTED=0,
	CONN_CONNECTING,
	CONN_CONNECTED,
	CONN_CONNECT_FAILED
};

/**
 Filtering bluetooth devices to discover
 */
typedef enum {
    /**
     Include all supported devices (default)
     */
	BLUETOOTH_FILTER_ALL=-1,
    /**
     Include supported printers
     */
	BLUETOOTH_FILTER_PRINTERS=1,
    /**
     Include supported pinpads
     */
	BLUETOOTH_FILTER_PINPADS=2,
    /**
     Include supported barcode scanners
     */
	BLUETOOTH_FILTER_BARCODE_SCANNERS=4,
}BLUETOOTH_FILTER;
#endif

/*******************************************************************************
 printLogo function constants
 *******************************************************************************/
/**
 Prints the logo at 203x203 DPI
 */
#define LOGO_NORMAL			0
/**
 Prints the logo at 101x203 DPI
 */
#define LOGO_DOUBLEWIDTH	1
/**
 Prints the logo at 203x101 DPI
 */
#define LOGO_DOUBLEHEIGHT	2
/**
 Prints the logo at 101x101 DPI
 */
#define LOGO_DWDH			3

/*******************************************************************************
 getInfo function constants
 *******************************************************************************/
/**
 Returns printer's battery voltage
 */
#define INFO_BATVOLT		0
/**
 Returns printer's battery in percent.
 
 @note Due to the way battery discharge, this information is not 100% accurate.
 */
#define INFO_BATPERCENT		1
/**
 Returns printer's head temperature in Celsius
 */
#define INFO_TEMPC			2
/**
 Returns printer's head temperature in Fahrenheit
 */
#define INFO_TEMPFR			3
/**
 Returns printer's firmware version
 */
#define INFO_PRINTERVERSION	4
/**
 Returns printer's model, one of the PRINTER_* constants
 */
#define INFO_PRINTERMODEL	5
/**
 Returns printer's paper width in pixels (203DPI)
 */
#define INFO_PAPERWIDTH		6
/**
 Returns printer's virtual page height in pixels (203DPI)
 */
#define INFO_PAGEHEIGHT		7

/*******************************************************************************
 Printer types
 *******************************************************************************/
#define PRINTER_CMP10		0
#define PRINTER_DPP350		1
#define PRINTER_DPP250		2
#define PRINTER_PP60		3
#define PRINTER_DPP450		4
#define PRINTER_EP60		5
#define PRINTER_BL112		10

/*******************************************************************************
 Data channels
 *******************************************************************************/
#define CHANNEL_PRN			1
#define CHANNEL_SMARTCARD	2
#define CHANNEL_GPRS		5
#define CHANNEL_ENCMSR		14
#define CHANNEL_MIFARE		16

/*******************************************************************************
 PRINTER STATUS CODES
 *******************************************************************************/ 
#define PRN_STAT_BATTERY_LOW	8
#define PRN_STAT_OVERHEAT		16
#define PRN_STAT_PAPER_OUT		32

/*******************************************************************************
 MIFARE STATUS CODES
 *******************************************************************************/ 
#define MF_STAT_OK				0
#define MF_STAT_TIMEOUT			-1
#define MF_STAT_COLLISION		-2
#define MF_STAT_PARITY_ERROR	-3
#define MF_STAT_FRAMING_ERROR	-4
#define MF_STAT_CRC_ERROR		-5 
#define MF_STAT_FIFO_OVERFLOW	-6
#define MF_STAT_EEPROM_ERROR	-7
#define MF_STAT_INVALID_KEY		-8
#define MF_STAT_UNKNOWN_ERROR	-9
#define MF_STAT_AUTH_ERROR		-10
#define MF_STAT_CODE_ERROR		-11
#define MF_STAT_BITCOUNT_ERROR	-12
#define MF_STAT_NOT_AUTH		-13
#define MF_STAT_VALUE_ERROR		-14

/*******************************************************************************
 MIFARE VALUE OPERATIONS
 *******************************************************************************/ 
#define MF_OPERATION_INCREMENT	0xC0
#define MF_OPERATION_DECREMENT	0xC1
#define MF_OPERATION_RESTORE	0xC2

/*******************************************************************************
 SMARTCARD FUNCTIONS RESULT CODES
 *******************************************************************************/ 
#define SCERR_NONE				0
#define SCERR_FAILED			-1
#define SCERR_FILE_NOT_FOUND	-2
#define SCERR_RECORD_NOT_FOUND	-3
#define SCERR_INVALID_LENGTH	-4
#define SCERR_NO_FILE_SELECTED	-5

/*******************************************************************************
 BARCODE MODULE SPECIFIC CONSTANTS
 *******************************************************************************/ 
// Barcode Printing Types
/**
 Prints UPC-A barcode
 */
#define BAR_PRN_UPCA		0
/**
 Prints UPC-E barcode
 */
#define BAR_PRN_UPCE		1
/**
 Prints EAN-13 barcode
 */
#define BAR_PRN_EAN13		2
/**
 Prints EAN-8 barcode
 */
#define BAR_PRN_EAN8		3
/**
 Prints CODE39 barcode
 */
#define BAR_PRN_CODE39		4
/**
 Prints ITF barcode
 */
#define BAR_PRN_ITF			5
/**
 Prints CODABAR barcode
 */
#define BAR_PRN_CODABAR		6
/**
 Prints CODE93 barcode
 */
#define BAR_PRN_CODE93		7
/**
 Prints CODE128 barcode
 */
#define BAR_PRN_CODE128		8
/**
 Prints 2D PDF-417 barcode
 */
#define BAR_PRN_PDF417		9
/**
 Prints CODE128 optimized barcode. Supported only on DPP-350 and DPP-250 printers, it makes the barcode lot smaller especially when numbers only are used
 */
#define BAR_PRN_CODE128AUTO	10
/**
 Prints EAN128 optimized barcode. Supported only on DPP-350 and DPP-250 printers, it makes the barcode lot smaller especially when numbers only are used
 */
#define BAR_PRN_EAN128AUTO	11

// Barcode Text Positopn
#define BAR_TEXT_NONE		0
#define BAR_TEXT_ABOVE		1
#define BAR_TEXT_BELOW		2
#define BAR_TEXT_BOTH		3


// Barcode Reading Types
#define BAR_BOOKLAND			0x16
#define BAR_CODABAR				0x02
#define BAR_CODE11				0x0C
#define BAR_CODE32				0x20
#define BAR_CODE128				0x03
#define BAR_CODE39				0x01
#define BAR_CODE39_FULLASCII	0x13
#define BAR_CODE93				0x07
#define BAR_COMPOSITE			0x1D
#define BAR_COUPON				0x17
#define BAR_D25					0x04
#define BAR_DATAMATRIX			0x1B
#define BAR_EAN_128				0x0F
#define BAR_EAN_13				0x0B
#define BAR_EAN_13_PLUS_2		0x4B
#define BAR_EAN_13_PLUS_5		0x8B
#define BAR_EAN_8				0x0A
#define BAR_EAN_8_PLUS_2		0x4A
#define BAR_EAN_8_PLUS_5		0x8A
#define BAR_IATA				0x05
#define BAR_ISBT_128			0x19
#define BAR_ISBT_128_CONCATENETED	0x21
#define BAR_ITF					0x06
#define BAR_MACROPDF			0x28
#define BAR_MSI					0x0E
#define BAR_PDF_417				0x11
#define BAR_BAR_POSTBAR_CANADA	0x26
#define BAR_POSTNET_US			0x1E
#define BAR_POSTAL_AUSTRALIA	0x23
#define BAR_POSTAL_JAPAN		0x22
#define BAR_POSTAL_UK			0x27
#define BAR_QR_CODE				0x1C
#define BAR_RSS_LIMITED			0x31
#define BAR_RSS_14				0x30
#define BAR_RSS_EXPANDED		0x32
#define BAR_SIGNATURE			0x24
#define BAR_TRIOPTICCODE39		0x15
#define BAR_UPCA				0x08
#define BAR_UPCA_PLUS_2			0x48
#define BAR_UPCA_PLUS_5			0x88
#define BAR_UPCE				0x09
#define BAR_UPCE_PLUS_2			0x49
#define BAR_UPCE_PLUS_5			0x89
#define BAR_UPCE1				0x10
#define BAR_UPCE1_PLUS_2		0x50
#define BAR_UPCE1_PLUS_5		0x90


/* ResetDefaults Flags */
#define RESET_PRINTSETTINGS		1
#define RESET_FONTSETTINGS		2
#define RESET_BARCODESETTINGS	4
#define RESET_DONTSETPRINTER	0x80

/* Align Flags */
#define ALIGN_LEFT				0
#define ALIGN_CENTER			1
#define ALIGN_RIGHT				2
#define ALIGN_JUSTIFY			3

#define TEXT_WORDWRAP			1

#define TEXT_ROTATE_0			0
#define TEXT_ROTATE_90			1
#define TEXT_ROTATE_180			2

#define LINESPACE_DEFAULT		0x22

#define BLACKMARK_TRESHOLD_DEFAULT	0x68

/* Table Flags */
#define TABLE_BORDERS_HORIZONTAL	1
#define TABLE_BORDERS_VERTICAL		2
#define TABLE_COLUMN_COMPACT		4

/**
 Horizontal printing, starting from the top-left, continuing to the right. Newline goes down
 */
#define PAGE_HORIZONTAL_TOPLEFT		0
/**
 Vertical printing, starting from bottom-left, going upwards, newline goes right
 */
#define PAGE_VERTICAL_BOTTOMLEFT	1
/**
 Horizontal printing, starting from the bottom-right, continuing to the left. Newline goes up
 */
#define PAGE_HORIZONTAL_BOTTOMRIGHT	2
/**
 Vertical printing, starting from top-right, going downwards, newline goes left
 */
#define PAGE_VERTICAL_TOPRIGHT		3

#ifndef XCOLORS_DEFINED
#define XCOLORS_DEFINED
typedef enum {
    COLOR_WHITE=0,
    COLOR_BLACK,
    COLOR_INVERT,
}COLORS;
#endif

/* Encryptions */
#define ALG_AES256		0
#define ALG_EH_ECC      1
#define ALG_EH_AES256   2
#define ALG_EH_IDTECH   3

/**
 Authentication key
 */
#define KEY_AUTHENTICATION 0x00
/**
 Encryption key, if set magnetic card data will be encrypted
 */
#define KEY_ENCRYPTION 0x01
/**
 Encrypted head key loading key
 */
#define KEY_EH_AES256_LOADING 0x02
/**
 Encrypted head TMK key
 */
#define KEY_EH_TMK_AES 0x10
/**
 Encrypted head DUKPT master key
 */
#define KEY_EH_DUKPT_MASTER 0x20


#if !__has_feature(objc_arc)
#ifndef FINANCIALCARD_DEFINED
#define FINANCIALCARD_DEFINED
typedef struct
{
    NSString *accountNumber;
    NSString *cardholderName;
    int  expirationYear;
    int  expirationMonth;
    NSString *serviceCode;
    NSString *discretionaryData;
    NSString *firstName;
    NSString *lastName;
}financialCard; 
#endif
#endif

/**
 Protocol describing various notifications that PrinterSDK can send.
 @ingroup G_PRINTER
 */
@protocol PrinterDelegate
@optional
/** @defgroup G_PRNDELEGATE Delegate Notifications
 @ingroup G_PRINTER
 Notifications sent by the sdk on various events - barcode scanned, magnetic card data, communication status, etc
 @{
 */

/**
 Notifies about the current connection state
 @param state - connection state, one of:
 <table>
 <tr><td>CONN_DISCONNECTED</td><td>there is no connection to the printer and the sdk will not try to make one even if the device is attached</td></tr>
 <tr><td>CONN_CONNECTING</td><td>Printer is not currently connected, but the sdk is actively trying to</td></tr>
 <tr><td>CONN_CONNECTED</td><td>Printer is connected</td></tr>
 </table>
 **/
-(void)prnConnectionState:(int)state;

/**
 Notification sent when printer's paper sensor changes
 @param present TRUE if paper is present, FALSE if printer is out of paper or cover is open
 **/
-(void)paperStatus:(BOOL)present;

/**
 Notification sent when barcode is successfuly read
 @param barcode - string containing barcode data
 @param type - barcode type, one of the BAR_* constants
 **/
-(void)barcodeData:(NSString *)barcode type:(int)type;

/**
 Notification sent when magnetic card is successfuly read
 @param track1 - data contained in track 1 of the magnetic card or nil
 @param track2 - data contained in track 2 of the magnetic card or nil
 @param track3 - data contained in track 3 of the magnetic card or nil
 **/
-(void)magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3;

/**
 Notification sent when magnetic card is successfuly. The data is encrypted via the selected encryption algorithm.
 
 After decryption, the result data will be as follows:
 - Random data (4 bytes)
 - Device identification text (16 ASCII characters, unused bytes are 0)
 - Processed track data in the format: 0xF1 (track1 data), 0xF2 (track2 data) 0xF3 (track3 data). It is possible some of the
 tracks will be empty, then the identifier will not be present too, for example 0xF1 (track1 data) 0xF3 (track3 data)
 - End of track data (byte 0x00)
 - CRC16 (2 bytes) - the CRC is performed from the start of the encrypted block (the Random Data block) to the end of the track data (including the 0x00 byte).
 The data block is rounded to 16 bytes
 
 In the more secure way, where the decryption key resides in a server only, the card read process will look something like:
 - (User) swipes the card 
 - (iOS program) receives the data via magneticCardEncryptedData and sends to the server
 - (iOS program)[optional] sends current printer serial number along with the data received from magneticCardEncryptedData. This can
 be used for data origin verification
 - (Server) decrypts the data, extracts all the information from the fields
 - (Server)[optional] if the ipod program have sent the printer serial number before, the server compares the received serial number
 with the one that's inside the encrypted block 
 - (Server) checks if the card data is the correct one, i.e. all needed tracks are present, card is the same type as required, etc
 and sends back notification to the ipod program. 
 @param encryption encryption algorithm used, one of:
 <table>
 <tr><td>0</td><td>AES 256</td></tr>
 </table>
 @param tracks shows which tracks have been read and inside the encrypted array, bits 0-2 represents track 1-3
 @param data contains the encrypted card data
 **/
-(void)magneticCardEncryptedData:(int)encryption tracks:(int)tracks data:(NSData *)data;

/**
 Notification sent when bluetooth discovery finds new bluetooth device
 @param success true if the discovery complete successfully, even if it not resulted in any device found, false if there was an error communicating with the bluetooth module
 **/
-(void)bluetoothDiscoverComplete:(BOOL)success;

/**
 Notification sent when bluetooth discovery finds new bluetooth device
 @param btAddress bluetooth address of the device
 @param btName bluetooth name of the device
 **/
-(void)bluetoothDeviceDiscovered:(NSString *)btAddress name:(NSString *)btName;

/**
 Indicates if bluetooth printing is supported, which happens when iSerial B accessory is connected
 @param supported - TRUE if bluetooth printing is supported and bt* functions can be used
 **/
-(void)bluetoothPrintingSupported:(BOOL)supported;

/**@}*/
@end

/**
 Provides access to printer functions.
 */
@interface Printer : NSObject


/** @defgroup G_PRNGENERAL General functions
 @ingroup G_PRINTER
 Functions to connect/disconnect, set delegate, print graphic and text
 @{
 */

/**
 Creates and initializes new Printer class instance or returns already initalized one. Use this function, if you want to access the class from different places
 @return shared class instance
 **/
+(id)sharedDevice;

/**
 Allows unlimited delegates to be added to a single class instance. This is useful in the case of global
 class and every view can use addDelegate when the view is shown and removeDelegate when no longer needs to monitor events
 @param newDelegate the delegate that will be notified of Printer events
 **/
-(void)addDelegate:(id)newDelegate;

/**
 Removes delegate, previously added with {@link #addDelegate:(id)newDelegate}
 @param newDelegate the delegate that will be no longer be notified of printer events
 **/
-(void)removeDelegate:(id)newDelegate;

/**
 Connects to the device. Connection status will be passed via the delegate.
 The sdk will manage direct connections automatically, for example PP-60 connecting to the iOS device will trigger
 connection event. If you plug and unplug iSerial cable, connected to DPP-250 or DPP-350 it will be automatically detected too,
 but connection and disconnections from the other end of the iSerial cable cannot be autodetected. Calling this function will
 force try to detect the printer. If you are using the DPP-250 and DPP-350 printers via iSerial cable, it might be good idea
 to provide connect/disconnect buttons in the program, if the user is expected to disconnect the printers from the iSerial cable
 at random time.
 **/
-(void)connect;

/**
 Tries to find and connect to a printer via communication streams. This differs from the normal connect function - it is synchronious
 function and does not continue to automatically connect in the background. The use for this function is to connect to the printer via
 bluetooth streams (from Linea for example)
 @param inStream input stream (bluetooth/socket/etc)
 @param outStream output stream (bluetooth/socket/etc)
 @param error returns error information, you can pass nil if you don't want it
 @return true if connection was successful and printer is ready to receive information, false otherwise
 **/
-(BOOL)connectWithStreams:(NSInputStream *)inStream outputStream:(NSOutputStream *)outStream error:(NSError **)error;

/**
 Disconnects from the device. Connection status will be passed via the delegate
 **/
-(void)disconnect;

/*
 Checks if accessory is presnet - either already connected, or physically attached, even if not connected to
 @return true if the accessory is either connected or physically attached
 */
-(BOOL)isPresent;

/**
 Forces data still in the sdk buffers to be sent directly to the printer
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)flushCache:(NSError **)error;
/**
 Waits specified timeout for the printout to complete. It is best to call this function with the complete timeout you are willing
 to wait, rather than calling it in a loop
 @param timeout the timeout to wait for the job to finish
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE if printer have successfully finished printing and ready to accept new data, FALSE if communication problem or the printer
 is still busy
 */
-(BOOL)waitPrintJob:(NSTimeInterval)timeout error:(NSError **)error;
/**
 Retrieves current printer status. This function is useful on printers having no automatic status notifications like DPP-250 and DPP-350.
 @param error returns error information, you can pass nil if you don't want it
 @return one or more of the PRN_STAT_* constants or -1 if function failed
 */
-(int)getPrinterStatus:(NSError **)error;
/**
 Prints selftest
 @param longtest TRUE if you want complete test with fonts and codepage, FALSE for short one
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)selfTest:(BOOL)longtest error:(NSError **)error;
/**
 Forces printer to turn off
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)turnOff:(NSError **)error;
/**
 Feeds the paper X lines (1/203 of the inch) or as needed (different length based on the printer model) so it allows paper to be teared.
 @note If blackmark mode is active, this function searches for blackmark. If the paper is not blackmark one
 or the mark can not be found in 360mm, the printer will put itself into out of paper state and will need LF button to be pushed to continue. 
 @param lines the number of lines (1/203 of the inch) to feed or 0 to automatically feed the paper as much as needed to tear the paper.
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)feedPaper:(int)lines error:(NSError **)error;
/**
 Prints barcode
 @param bartype Barcode type, one of the BAR_PRN_* constants
 @param barcode barcode data to be printed
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)printBarcode:(int)bartype barcode:(NSData *)barcode error:(NSError **)error;
/**
 Prints the stored logo. You can upload log with {@link #loadLogo:(NSData *)logo} function
 @param mode logo mode, one of the LOGO_* constants
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)printLogo:(int)mode error:(NSError **)error;
/**
 Set various barcode parameters.
 @param scale width of each barcode column in pixels (1/203 of the inch) between 2 and 4, default is 3
 @param height barcode height in pixels between 1 and 255. Default is 77
 @param hriPosition barcode hri code position, one of the BAR_TEXT_* constants
 @param align barcode aligning, one of the ALIGN_* constants
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)setBarcodeSettings:(int)scale height:(int)height hriPosition:(int)hriPosition align:(int)align error:(NSError **)error;
/**
 Sets printer density level
 @param percent density level in percents (50%-200%)
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)setDensity:(int)percent error:(NSError **)error;
/**
 Sets the line "height" in pixels
 If the characters are 16 pixelx high for example, setting the linespace to 20 will make the printer leave 4 blank lines before next line of text starts.
 You cannot make text lines overlap.
 @param lineSpace linespace in pixels, or 0 for automatic calculation. Default is 0
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)setLineSpace:(int)lineSpace error:(NSError **)error;
/**
 Sets left margin
 @param margin left margin in pixels. Default is 0
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)setLeftMargin:(int)leftMargin error:(NSError **)error;
/**
 Prints text with specified font/styles.
 This function can act as both simple plain text printing and quite complex printing using internal tags to format the text.
 The function uses the currently font size and style (or default ones) as well as the aligning, however it allows modifications of them inside the text. Any modification of the settings using the tags will be reverted when function completes execution. For example if you have default font selected before using printText and set bold font inside, it will be reverted to plain when function completes.
 The tags are control commands used to modify the text printing parameters. They are surrounded by {} brackets. A list of all control tags follows:
 <ul>
 <li>{==} - reverts all settings to their defaults. It includes font size, style, aligning
 <li>{=Fx} - selects font size. x ranges from 0 to 1 as follows:
 <li>     0: FONT_9X16 (hieroglyph characters are using the same width as height, i.e. 16x16)
 <li>     1: FONT_12X24 (hieroglyph characters are using the same width as height, i.e. 24x24)
 <li>{=L} - left text aligning
 <li>{=C} - center text aligning
 <li>{=R} - right text aligning
 <li>{=Rx} - text rotation as follows:
 <li>     0: not rotated
 <li>     1: rotated 90 degrees
 <li>     2: rotated 180 degrees
 <li>{+/-B} - sets or unsets bold font style
 <li>{+/-I} - sets or unsets italic font style
 <li>{+/-U} - sets or unsets underline font style
 <li>{+/-V} - sets or unsets inverse font style
 <li>{+/-W} - sets or unsets text word-wrapping
 <li>{+/-DW} - sets or unsets doubled font width
 <li>{+/-DH} - sets or unsets doubled font height
 </ul><p>
 An example of using tags "{=C}Plain centered text\n{=L}Left centered\n{+B}...bold...{-B}{+I}or ITALIC"
 @param textString the text to print
 @param encoding the encoding to use when converting the string to format suitable to the printer. Default encoding should be NSWindowsCP1252StringEncoding. Currently double-byte encodings like JIS are not supported.
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
*/
-(bool)printText:(NSString *)textString usingEncoding:(NSStringEncoding)encoding error:(NSError **)error;
/**
 Prints text with specified font/styles.
 This function can act as both simple plain text printing and quite complex printing using internal tags to format the text.
 The function uses the currently font size and style (or default ones) as well as the aligning, however it allows modifications of them inside the text. Any modification of the settings using the tags will be reverted when function completes execution. For example if you have default font selected before using printText and set bold font inside, it will be reverted to plain when function completes.
 The tags are control commands used to modify the text printing parameters. They are surrounded by {} brackets. A list of all control tags follows:
 <ul>
 <li>{==} - reverts all settings to their defaults. It includes font size, style, aligning
 <li>{=Fx} - selects font size. x ranges from 0 to 1 as follows:
 <li>     0: FONT_9X16 (hieroglyph characters are using the same width as height, i.e. 16x16)
 <li>     1: FONT_12X24 (hieroglyph characters are using the same width as height, i.e. 24x24)
 <li>{=L} - left text aligning
 <li>{=C} - center text aligning
 <li>{=R} - right text aligning
 <li>{=Rx} - text rotation as follows:
 <li>     0: not rotated
 <li>     1: rotated 90 degrees
 <li>     2: rotated 180 degrees
 <li>{+/-B} - sets or unsets bold font style
 <li>{+/-I} - sets or unsets italic font style
 <li>{+/-U} - sets or unsets underline font style
 <li>{+/-V} - sets or unsets inverse font style
 <li>{+/-W} - sets or unsets text word-wrapping
 <li>{+/-DW} - sets or unsets doubled font width
 <li>{+/-DH} - sets or unsets doubled font height
 </ul><p>
 An example of using tags "{=C}Plain centered text\n{=L}Left centered\n{+B}...bold...{-B}{+I}or ITALIC"
 @param textString the text to print
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)printText:(NSString *)textString error:(NSError **)error;
/**
 Prints the delimiter character at the whole width of the paper, adjusting itself to the paper width. The character is printed with font 12x24
 @param delimiter character to print
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)printDelimiter:(char)delimchar error:(NSError **)error;
/**
 Returns different information about printer status/settings
 @param infocmd information type requested, one of the INFO_* constants
 @param data upon success stores the answer from the imfo command
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)getInfo:(int)infocmd data:(int *)data error:(NSError **)error;
/**
 Returns printer unique serial number
 @return serial number
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(NSString *)getPrinterSerialNumber:(NSError **)error;
/**
 Returns blackmark sensor treshold or UnsupportedOperationException if printer is not in blackmark mode.
 This value tells the printer how dark a spot on the paper needs to be in order to be considered as blackmark.
 @param treshold upon success stores the current blackmark treshold
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)getBlackMarkTreshold:(int *)treshold error:(NSError **)error;
/**
 Sets blackmark sensor treshold or UnsupportedOperationException if printer is not in blackmark mode.
 This value tells the printer how dark a spot on the paper needs to be in order to be considered as blackmark.
 @param treshold value between 0x20 and 0xc0, default is 0x68
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(bool)setBlackMarkTreshold:(int)treshold error:(NSError **)error;
/**
 Provides blackmark sensor calibration by scaning 200mm of paper for possible black marks and adjust the sensor treshold.
 Make sure you have put the right paper before calling this function.
 @return returns new trashold value for the scanned paper. The trashold is already stored in printer's flash memory so no
 additional set is needed.
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)calibrateBlackMark:(int *)treshold error:(NSError **)error;
/**
 Makes short beep on the printer
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)beep:(NSError **)error;
/**
 Loads logo into printer's memory. The logo is persistent and can be deleted only if battery is removed
 @param logo logo bitmap data
 @param align logo alignment, one of the ALIGN_* constants
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)loadLogo:(UIImage *)logo align:(int)align error:(NSError **)error;
/**
 Prints Bitmap object. You can print color bitmaps, as they will be converted to black and white using error diffusion and dithering to achieve best results. On older devices this can take some time
 @param image UIImage object
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(void)printImage:(UIImage *)image;
/**
 Prints Bitmap object using specified alignment. You can print color bitmaps, as they will be converted to black and white using error diffusion and dithering to achieve best results. On older devices this can take some time
 @param image UIImage object
 @param align image alighment, one of the ALIGN_* constants
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)printImage:(UIImage *)image align:(int)align error:(NSError **)error;
/**@}*/


/** @defgroup G_PRNPAGEMODE Page Mode Functions
 Functions to work with the printer's page mode. Page mode is a special operation mode, that allows you to define a virtual page
 and then draw inside text, graphics, barcodes and print it all at once. Page mode allows for extended positioning of the elements,
 rotation, inversion and basic graphics elements.
 @ingroup G_PRINTER
 @{
 */
/**
 Returns TRUE if page mode is supported on the connected device
 */
-(bool)pageIsSupported;
/**
 Creates a new virtual page using the maximum supported page height.
 Use {@link #getInfo:(int)infocmd} to get the maximum page height supported.
 See {@link #pageStart} for more detailed information
 The page mode allows constructing a virtual page inside the printer, draw text, graphics,
 and performs some basic graphics operations (draw rectangles, frames, invert parts of the page)
 at any place, rotated or not, then print the result.
 Page mode is useful if you want to create some non-standart printout, or print vertically.
 Tables functions also work in page mode allowing a huge tables to be created and printed vertically.
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
*/
-(bool)pageStart:(NSError **)error;
/**
 Prints the content of the virtual page.
 @note The white space from the top and bottom is not printed so the print ends at the last black dot.
 If you want to feed the paper use the {@link #feedPaper:(int)lines} function
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)pagePrint:(NSError **)error;
/**
 Exits page mode
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)pageEnd:(NSError **)error;
/**
 Sets a working area and orientation inside the virtual page. No drawing can ever occur outside the said area
 @param left, top, width, height working area rectangle in absolute pixels (i.e. does not depend on the page orientation)
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)pageSetWorkingArea:(int)left top:(int)top width:(int)width height:(int)height error:(NSError **)error;
/**
 Sets a working area and orientation inside the virtual page. No drawing can ever occur outside the said area
 @param left, top, width, height working area rectangle in absolute pixels (i.e. does not depend on the page orientation)
 @param orientation one of the PAGE_* constants
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)pageSetWorkingArea:(int)left top:(int)top width:(int)width heigth:(int)height orientation:(int)orientation error:(NSError **)error;
/**
 Fills the current working area (or whole page if none is set) with the specified color
 @param color one of the COLOR_* constants
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)pageFillRectangle:(int)color error:(NSError **)error;
/**
 Fills a rectangle inside the current working area with specified color
 @param left, top, width, height rectangle coordinates
 @param color one of the COLOR_* constants
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)pageFillRectangle:(int)left top:(int)top width:(int)width height:(int)height color:(int)color error:(NSError **)error;
/**
 Draws a rectangle frame inside the current working area with specified color
 @param left, top, width, height rectangle coordinates
 @param framewidth width of the frame (1-64)
 @param color one of the COLOR_* constants
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)pageRectangleFrame:(int)left top:(int)top width:(int)width height:(int)height framewidth:(int)framewidth color:(int)color error:(NSError **)error;
/**@}*/

 
/** @defgroup G_PRNBARCODEREADER Barcode Reader Functions
 Functions for scanning barcodes and direct control of the barcode engine
 @ingroup G_PRINTER
 @{
 */
/**
 Helper function to return string name of barcode type
 @param barcodeType 
 @return barcode type name
 */
-(NSString *)barcodeType2Text:(int)barcodeType;
/**
 Scans barcode using the built-in barcode scanning engine
 @param barcodeType upon success barcode type, one of the BAR_* constants will be stored
 @param timeout maximum time to wait for a barcode
 @param error returns error information, you can pass nil if you don't want it
 @return barcode string or nil if function failed or no barcode was read
 */
-(NSString *)scanBarcode:(int *)barcodeType timeout:(double)timeout error:(NSError **)error;
/**@}*/


/** @defgroup G_PRNMSREADER Magnetic Stripe Reader Functions
 Functions to work with the printer's magenetic card reader
 @ingroup G_PRINTER
 @{
 */

/**
 Reads magnetic stripe card. For PP-60, this function is not needed - the card data is passed via delegate whenever the user swipes a card.
 @param timeout timeout in seconds to read the card data. The actuall scan time may differ, but will be as close as possible to this value
 @param error returns error information, you can pass nil if you don't want it
 @return String[3] containing the 3 tracks or null if timeout elapses
 */
-(NSArray *)msReadCard:(double)timeout error:(NSError **)error;

/**
 Helper function to parse financial card and extract the data - name, number, expiration date.
 The function will extract as much information as possible.
 @param track1 - track1 information or nil
 @param track2 - track2 information or nil
 @return dictionary containing extracted data or nil if the data is invalid. Keys contained are:
 <table>
 <tr><td>"accountNumber"</td><td>Account number</td></tr>
 <tr><td>"cardholderName"</td><td>Cardholder name, as stored in the card</td></tr>
 <tr><td>"expirationYear"</td><td>Expiration date - year</td></tr>
 <tr><td>"expirationMonth"</td><td>Expiration date - month</td></tr>
 <tr><td>"serviceCode"</td><td>Service code (if any)</td></tr>
 <tr><td>"discretionaryData"</td><td>Discretionary data (if any)</td></tr>
 <tr><td>"firstName"</td><td>Extracted cardholder's first name</td></tr>
 <tr><td>"lastName"</td><td>Extracted cardholder's last name</td></tr>
 </table>
 **/
-(NSDictionary *)msProcessFinancialCard:(NSString *)track1 track2:(NSString *)track2;
/**@}*/



/** @defgroup G_PRNSCREADER SmartCard Reader Functions
 Functions to work with the printer's smart card reader
 @ingroup G_PRINTER
 @{
 */
/**
 Initializes and powers on the smartcard reader. Call this function before any other smartcard functions
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)scInit:(NSError **)error;
/**
 Powers down the smartcard reader
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)scClose:(NSError **)error;
/**
 Resets the smartcard and returns Answer To Reset. Call this function prior to performing APDU commands
 @param error returns error information, you can pass nil if you don't want it
 @return first byte is the protocol number (0=T0, 1=T1), the rest is ATR(Answer To Reset) data or nil if error occured
 */
-(NSData *)scReset:(NSError **)error;
/**
 Sends an APDU command to the smartcard. The smartcard have to be operational first by performing {@link #scInit} and {@link #scReset} commands on it.
 @param cla The CLA parameter uint8_t
 @param ins The INS parameter uint8_t
 @param p1 The P1 parameter uint8_t
 @param p2 The P2 parameter uint8_t
 @param data The data buffer you want to send with the command, optional, can be null
 @param maxrcvlen Defines the maximum number of uint8_ts you want to receive from the smartcard. Defaults to 0
 @param error returns error information, you can pass nil if you don't want it
 @return NSData with the smartcard response + 2 bytes of status or nil if command failed
 */
-(NSData *)scAPDU:(int)cla ins:(int)ins p1:(int)p1 p2:(int)p2 data:(NSData *)data maxrcvlen:(int)maxrcvlen error:(NSError **)error;
/**@}*/

/** @defgroup G_PRNMFREADER Mifare Reader Functions
 Functions to work with the printer's mifare cards reader
 @ingroup G_PRINTER
 @{
 */
/**
 Returns mifare engine identification. This is a way to query the engine and see it is there.
 @param error returns error information, you can pass nil if you don't want it
 @return identification string or nil if error occured
 */
-(NSString *)mfIdent:(NSError **)error;
/**
 Initializes and powers on the mifare reader module. Call this function before any other mifare functions.
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)mfInit:(NSError **)error;
/**
 Powers down mifare reader module. Call this function after you are done with the mifare reader.
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)mfClose:(NSError **)error;
/**
 Scans for mifare cards in the area
 @param allCards - true if you want all cards to be requested, or false for only not halted cards
 @param rq1 (optional) upon success, the request status RQ1 will be returned here
 @param rq2 (optional) upon success, the request status RQ2 will be returned here
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)mfRequestCards:(bool)allCards rq1:(uint8_t *)rq1 rq2:(uint8_t *)rq2 error:(NSError **)error;
/**
 Returns scanned card serial number
 @param serial upon success, card serial number will be returned here
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)mfAnticollision:(uint32_t *)serial error:(NSError **)error;
/**
 Select the card to use
 @param serial card serial number, received from {@link #mfAnticollision:(uint32_t *)serial}
 @param sack (optional) SACK parameter is returned upon success
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)mfSelectCard:(uint32_t)serial sack:(uint8_t *)sack error:(NSError **)error;
/**
 Authenticate card block with direct key data
 @param type key type, either 'A' or 'B'
 @param block block number
 @param key 6 bytes key
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)mfAuthByKey:(char)type block:(int)block key:(uint8_t[6])key error:(NSError **)error;
/**
 Reads a 16 byte block of data
 @param address the address of the block to read
 @param data data buffer, where returned block will be written
 @param error returns error information, you can pass nil if you don't want it
 @return received data or nil if error occured
 */
-(NSData *)mfRead:(int)address error:(NSError **)error;
/**
 Writes a 16 byte block of data
 @param address the address of where to write
 @param data data to write in the block
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)mfWrite:(int)address data:(NSData *)data error:(NSError **)error;
/**
 Performs increment/decrement/restore operations
 @param operation operation type, one if the {@link #MF_OPERATION_INCREMENT}, {@link #MF_OPERATION_DECREMENT} or {@link #MF_OPERATION_RESTORE}
 @param src_block source block number
 @param dst_block destination block number
 @param value value to be incremented/decremented with
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)mfValueOperation:(int)operation src_block:(int)src_block dst_block:(int)dst_block value:(uint32_t)value error:(NSError **)error;
/**
 Returns mifare reader serial number
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)mfGetReaderSerial:(uint32_t *)serial error:(NSError **)error;
/**
 Writes a 4 byte value in the card
 @param address address to write to
 @param value the data
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)mfWriteValue:(int)address value:(uint32_t)value error:(NSError **)error;
/**
 Stores key securely inside the mifare reader. The key can later be used to authenticate blocks
 @param keyID the index of the key (0-31)
 @param key key data
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)mfLoadKey:(int)keyID key:(uint8_t[6])key error:(NSError **)error;
/**
 Authenticate block by using previously stored key
 @param type key type, either 'A' or 'B'
 @param keyID the index of the key (0-31)
 @param block block to authenticate
 @param keyID the index of the key (0-31)
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)mfAuthByLoadedKey:(char)type block:(int)block keyID:(int)keyID error:(NSError **)error;
/**@}*/


/** @defgroup G_PRNTABLES Table Functions
 Functions to create, fill and print tables
 @ingroup G_PRINTER
 @{
 */
/**
 Checks if the currently connected printer supports tables
 @return TRUE if tables are supported
 */
-(bool)tableIsSupported;
/**
 Create a new table using custom flags
 @param flags one or more of the TABLE_BORDERS_* constants
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)tableCreate:(int)flags error:(NSError **)error;
/**
 Create a new table using default settings - both horizontal and vertical borders around it
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)tableCreate:(NSError **)error;
/**
 Adds a new column using default settings - 12x24 font, plain, vertical border between the cells, left aligning
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)tableAddColumn:(NSError **)error;
/**
 Adds a new column using default settings - plain text, vertical border between the cells, left aligning
 @param font one of the FONT_size constants
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)tableAddColumn:(int)font error:(NSError **)error;
/**
 Adds a new column using custom font and vertical border between the cells
 @param font one of the FONT_size constants
 @param style one or more of the font style constants (FONT_BOLD, FONT_ITALIC, etc)
 @param alignment text alignment inside the cell, one of the ALIGN_* constants
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)tableAddColumn:(int)font style:(int)style alignment:(int)alignment error:(NSError **)error;
/**
 Adds a new column
 @param font one of the FONT_size constants
 @param style one or more of the font style constants (FONT_BOLD, FONT_ITALIC, etc)
 @param alignment text alignment inside the cell, one of the ALIGN_* constants
 @param flags one or more of the TABLE_BORDERS_* constants
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)tableAddColumn:(int)font style:(int)style alignment:(int)alignment flags:(int)flags error:(NSError **)error;
/**
 Adds a new cell using the font size and style and aligning of the column that cell belongs to
 @param data string data
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)tableAddCell:(NSString *)data error:(NSError **)error;
/**
 Adds a new cell using the font style and aligning of the column that cell belongs to
 @param data string data
 @param font font size, one of the FONT_size constants
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)tableAddCell:(NSString *)data font:(int)font error:(NSError **)error;
/**
 Adds a new cell using custom font size and style and aligning of the column that cell belongs to
 @param data string data
 @param font font size, one of the FONT_size constants
 @param style one or more of the font style constants (FONT_BOLD, FONT_ITALIC, etc)
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)tableAddCell:(NSString *)data font:(int)font style:(int)style error:(NSError **)error;
/**
 Adds a new cell using custom font size and style and aligning
 @param data string data
 @param font font size, one of the FONT_size constants
 @param style one or more of the font style constants (FONT_BOLD, FONT_ITALIC, etc)
 @param alignment date aligning, one of the ALIGN_* constants
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)tableAddCell:(NSString *)data font:(int)font style:(int)style alignment:(int)alignment error:(NSError **)error;
/**
 Adds aa horizontal black line to the entire row that separates it from the next
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)tableAddDelimiter:(NSError **)error;
/**
 Sets the row height that will be used by default for new cells added
 @param height row height, any value less than the characters height will be auto fixed. Default is LINESPACE_DEFAULT
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)tableSetRowHeight:(int)height error:(NSError **)error;
/**
 Prints current table or throws IllegalArgumentException if cell data cannot be fit into paper
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)tablePrint:(NSError **)error;
/**@}*/


/** @defgroup G_PRNCRYPTO Cryptographic & Security Functions
 Cryptographical functions - loading keys, magnetic card encryption and printer authentication. Currently that information is for the
 software cryptography in the printer firmware, not the hardware encrypted magnetic head.
 
 <br>An overview of the security, provided by the printers (see each of the crypto functions for further detail):
 
 <br>Firmware: 
 
 <br>For magnetic card encryption the printer is using AES256, which is the current industry standard encryption algorithm.
 Magnetic card data, along with device serial number and some random bytes (to ensure every packet will be different) are being sent
 to the iOS program in an encrypted way. 

 <br>Software: 
 
 <br>Currently there are 2 types of keys, that can be loaded into the printer: 
 - AUTHENTICATION KEY - used for device authentication (for example the program can lock itself to work with very specific printer)
 and encryption of the firmware 
 - ENCRYPTION KEY - used for magnetic card data encryption. To use msr encryption, you don't need to set the AUTHENTICATION KEY. 
 
 <br>Keys: The keys can be set/changed in two ways: 

 <br>1. Using plain key data - this method is easy to use, but less secure, as it relies on program running on iPod/iPhone to have the key
 inside, an attacker could compromise the system and extract the key from device's memory. Call cryptoSetKey to set the keys this way.
 If there is an existing key of the same type inside the printer, you have to pass it too. 
 
 <br>2. Using encrypted key data - this method is harder to implement, but provides better security - the key data, encrypted with old key
 data is sent from a server in secure environment to the program, running on the iOS, then the program forwards it to the printer.
 The program itself have no means to decrypt the data, so an attacker can't possibly extract the key. Refer to cryptoSetKey documentation
 for more detailed description of the loading process.
 
 <br>The initial loading of the keys should always be done in a secure environment. 
 
 <br>Magnetic card encryption:
 
 <br>Once ENCRYPTION KEY is set, all magnetic card data gets encrypted, and is now sent via magneticCardEncryptedData instead. The printer demo
 program contains sample code to decrypt the data block and extract the contents - the serial number and track data.
 
 <br>As with keys, card data can be extracted on the iOS device itself (less secure, the application needs to have the key inside) or be sent
 to a secure server to be processed.
 @note The encrypted data contains printer's serial number too, this can be used for Data Origin Verification, to be sure someone is not trying
 to mimic data, coming from another device. 
 @ingroup G_PRINTER
 @{
 */
/**
 Generates 16 byte block of random numbers, required for some of the other crypto functions.
 @param error returns error information, you can pass nil if you don't want it
 @return 16 bytes of random numbers or nil if error occured
 */
-(NSData *)cryptoRawGenerateRandomData:(NSError **)error;

/**
 @note RAW crypto functions are harder to use and require more code, but are created to allow no secret keys
 to reside on the device, but all the operations can be execuded with data, sent from a secure server. See
 cryptoSetKey if you plan to use the key in the mobile device.
 
 <br>Used to store AES256 keys into printer's internal memory. Valid keys that can be set:
 - KEY_AUTHENTICATION - if set, you can use authentication functions - {@link #cryptoRawAuthenticatePrinter:(NSData *)randomData}
 or {@link #cryptoAuthenticatePrinter:(NSData *)key}. Firmware updates will require authentication too
 - KEY_ENCRYPTION - if set, magnetic card data will come encrypted via magneticCardEncryptedData
 
 <br>Generally the key loading process, using "Raw" commands, a program on the iOS device and a server which holds the keys
 will look similar to:
 
 - (iOS program) calls {@link #cryptoRawGenerateRandomData} to get 16 bytes block of random data and send these to the server 
 - (Server) creates byte array of 48 bytes consisting of: [RANDOM DATA: 16 bytes][KEY DATA: 32 bytes] 
 - (Server) if there is current encryption key set in the printer (if you want to change existing key) the server encrypts
 the 48 bytes block with the OLD key 
 - (Server) sends the result data back to the program 
 - (iOS program) calls cryptoRawSetKey with KEY_ENCRYPTION and the data it received from the server
 - (Printer) tries to decrypt the key data if there was already key present, then extracts the key, verifies the random data
 and if everything is okay, sets the key 
 
 @param keyID the key type to set - KEY_AUTHENTICATION or KEY_ENCRYPTION
 @param encryptedData 48 bytes that consists of 16 bytes random numbers received via call to {@link #cryptoRawGenerateRandomData}
 and 32 byte AES256 key. If there has been previous key of the same type, then all 48 bytes should be encrypted with it.
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)cryptoRawSetKey:(int)keyID encryptedData:(NSData *)encryptedData error:(NSError **)error;

/**
 Used to store AES256 keys into printer's internal memory. Valid keys that can be set:
 - KEY_AUTHENTICATION - if set, you can use authentication functions - {@link #cryptoRawAuthenticatePrinter:(NSData *)randomData} or {@link #cryptoAuthenticatePrinter:(NSData *)key}.
 - KEY_ENCRYPTION - if set, magnetic card data will come encrypted via magneticCardEncryptedData
 @param keyID the key type to set - KEY_AUTHENTICATION or KEY_ENCRYPTION
 @param key 32 bytes AES256 key to set
 @param oldKey 32 bytes AES256 key that was previously used, or null if there was no previous key. The old key
 should match the new key, i.e. if you are setting KEY_ENCRYPTION, then you should pass the old KEY_ENCRYPTION.
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE upon success, FALSE otherwise
 */
-(bool)cryptoSetKey:(int)keyID key:(NSData *)key oldKey:(NSData *)oldKey error:(NSError **)error;

/**
 @note RAW crypto functions are harder to use and require more code, but are created to allow no secret keys
 to reside on the device, but all the operations can be execuded with data, sent from a secure server. See
 {@link #cryptoAuthenticatePrinter:(NSData *)key} if you plan to use the key in the mobile device.
 
 Encrypts a 16 bytes block of random data with the stored authentication key and returns the result.
 <br>The idea: if a program wants to work with specific printer, it sets AES256 authentication key once, then
 on every connect the program generates random 16 byte block of data, encrypts it internally with the said key,
 then encrypts it with the printer too and compares the result. If that printer no key, or
 the key is different, the resulting data will totally differ from the one generated.
 <br>This does not block the printer from operation, what action will be taken if devices mismatch depends on the program.
 @param randomData 16 bytes block of data (presumably random bytes)
 @param error returns error information, you can pass nil if you don't want it
 @return random data, encrypted with the printer's authentication key or nil if error occured
 */
-(NSData *)cryptoRawAuthenticatePrinter:(NSData *)randomData error:(NSError **)error;

/**
 @note Check out the {@link #cryptoRawAuthenticatePrinter:(NSData *)randomData} function, if you want to not use the key inside the mobile device.
 
 Generates random data, uses the key to encrypt it, then encrypts the same data with the stored authentication key
 inside the printer and returns true if both data matches.
 <br>The idea: if a program wants to work with specific printer, it sets AES256 authentication key once, then
 on every connect the program uses {@link #cryptoAuthenticatePrinter:(NSData *)key} with that key. If the printer contains no key, or
 the key is different, the function will return FALSE.
 <br>This does not block the printer from operation, what action will be taken if devices mismatch depends on the program.
 @param key 32 bytes AES256 key
 @param error returns error information, you can pass nil if you don't want it
 @return TRUE if the printer contains the same authentication key
 */
-(bool)cryptoAuthenticatePrinter:(NSData *)key error:(NSError **)error;

/**@}*/

/**
 Adds delegate to the class
 **/
@property(assign) id delegate;
/**
 Provides a list of currently registered delegates
 */
@property(readonly) NSMutableArray *delegates;

/**
 Returns current connection state
 **/
@property(readonly) int connstate;

/**
 Returns connected device name
 **/
@property(nonatomic,copy) NSString *deviceName;
/**
 Returns connected device model
 **/
@property(nonatomic,copy) NSString *deviceModel;
/**
 Returns connected device firmware version
 **/
@property(nonatomic,copy) NSString *firmwareRevision;
/**
 Returns connected device hardware version
 **/
@property(nonatomic,copy) NSString *hardwareRevision;
/**
 Returns connected device serial number
 **/
@property(nonatomic,copy) NSString *serialNumber;

/**
 SDK version number in format MAJOR*100+MINOR, i.e. version 1.15 will be returned as 115
 */
@property(readonly) int sdkVersion;

@end
/**@}*/

#ifndef PRINTER_NO_EXCEPTIONS

#pragma mark DEPRECATED

/** @defgroup G_DEP_PRINTER Printer Functions
 Deprecated functions, please check out NSError alternatives
 @{
 */

@interface Printer (PrinterDeprecated)

/** @defgroup G_DEP_PRNGENERAL General functions
 @ingroup G_DEP_PRINTER
 Functions to connect/disconnect, set delegate, print graphic and text
 @{
 */

/**
 Tries to find and connect to a printer via communication streams. This differs from the normal connect function - it is synchronious
 function and does not continue to automatically connect in the background. The use for this function is to connect to the printer via
 bluetooth streams (from Linea for example)
 @param inStream input stream (bluetooth/socket/etc)
 @param outStream output stream (bluetooth/socket/etc)
 @return TRUE if connection is successful or false if failed
 **/
-(BOOL)connectWithStreams:(NSInputStream *)inStream outputStream:(NSOutputStream *)outStream;

/**
 Waits specified timeout for the printout to complete. It is best to call this function with the complete timeout you are willing
 to wait, rather than calling it in a loop
 @return TRUE if printer have successfully finished printing and ready to accept new data, FALSE if communication problem or the printer
 is still busy
 */
-(BOOL)waitPrintJob:(NSTimeInterval)timeout;
/**
 Forces data still in the sdk buffers to be sent directly to the printer
 */
-(void)flushCache;
/**
 Retrieves current printer status. This function is useful on printers having no automatic status notifications like DPP-250 and DPP-350.
 @return one or more of the PRN_STAT_* constants or
 */
-(int)getPrinterStatus;
/**
 Prints selftest
 @param longtest TRUE if you want complete test with fonts and codepage, FALSE for short one
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)selfTest:(BOOL)longtest;
/**
 Forces printer to turn off
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)turnOff;
/**
 Feeds the paper X lines (1/203 of the inch) or as needed (different length based on the printer model) so it allows paper to be teared.
 @note If blackmark mode is active, this function searches for blackmark. If the paper is not blackmark one
 or the mark can not be found in 360mm, the printer will put itself into out of paper state and will need LF button to be pushed to continue. 
 @param lines the number of lines (1/203 of the inch) to feed or 0 to automatically feed the paper as much as needed to tear the paper.
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)feedPaper:(int)lines;
/**
 Prints barcode
 @param bartype Barcode type, one of the BAR_PRN_* constants
 @param barcode barcode data to be printed
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)printBarcode:(int)bartype barcode:(NSData *)barcode;
/**
 Prints the stored logo. You can upload log with {@link #loadLogo:(NSData *)logo} function
 @param mode logo mode, one of the LOGO_* constants
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)printLogo:(int)mode;
/**
 Set various barcode parameters.
 @param scale width of each barcode column in pixels (1/203 of the inch) between 2 and 4, default is 3
 @param height barcode height in pixels between 1 and 255. Default is 77
 @param hriPosition barcode hri code position, one of the BAR_TEXT_* constants
 @param align barcode aligning, one of the ALIGN_* constants
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)setBarcodeSettings:(int)scale height:(int)height hriPosition:(int)hriPosition align:(int)align;
/**
 Sets printer density level
 @param percent density level in percents (50%-200%)
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)setDensity:(int)percent;
/**
 Sets the line "height" in pixels
 If the characters are 16 pixelx high for example, setting the linespace to 20 will make the printer leave 4 blank lines before next line of text starts.
 You cannot make text lines overlap.
 @param lineSpace linespace in pixels, or 0 for automatic calculation. Default is 0
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)setLineSpace:(int)lineSpace;
/**
 Sets left margin
 @param margin left margin in pixels. Default is 0
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)setLeftMargin:(int)margin;
/**
 Prints text with specified font/styles.
 This function can act as both simple plain text printing and quite complex printing using internal tags to format the text.
 The function uses the currently font size and style (or default ones) as well as the aligning, however it allows modifications of them inside the text. Any modification of the settings using the tags will be reverted when function completes execution. For example if you have default font selected before using printText and set bold font inside, it will be reverted to plain when function completes.
 The tags are control commands used to modify the text printing parameters. They are surrounded by {} brackets. A list of all control tags follows:
 <ul>
 <li>{==} - reverts all settings to their defaults. It includes font size, style, aligning
 <li>{=Fx} - selects font size. x ranges from 0 to 1 as follows:
 <li>     0: FONT_9X16 (hieroglyph characters are using the same width as height, i.e. 16x16)
 <li>     1: FONT_12X24 (hieroglyph characters are using the same width as height, i.e. 24x24)
 <li>{=L} - left text aligning
 <li>{=C} - center text aligning
 <li>{=R} - right text aligning
 <li>{=Rx} - text rotation as follows:
 <li>     0: not rotated
 <li>     1: rotated 90 degrees
 <li>     2: rotated 180 degrees
 <li>{+/-B} - sets or unsets bold font style
 <li>{+/-I} - sets or unsets italic font style
 <li>{+/-U} - sets or unsets underline font style
 <li>{+/-V} - sets or unsets inverse font style
 <li>{+/-W} - sets or unsets text word-wrapping
 <li>{+/-DW} - sets or unsets doubled font width
 <li>{+/-DH} - sets or unsets doubled font height
 </ul><p>
 An example of using tags "{=C}Plain centered text\n{=L}Left centered\n{+B}...bold...{-B}{+I}or ITALIC"
 @param textString the text to print
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)printText:(NSString *)textString;
/**
 Prints text with specified font/styles.
 This function can act as both simple plain text printing and quite complex printing using internal tags to format the text.
 The function uses the currently font size and style (or default ones) as well as the aligning, however it allows modifications of them inside the text. Any modification of the settings using the tags will be reverted when function completes execution. For example if you have default font selected before using printText and set bold font inside, it will be reverted to plain when function completes.
 The tags are control commands used to modify the text printing parameters. They are surrounded by {} brackets. A list of all control tags follows:
 <ul>
 <li>{==} - reverts all settings to their defaults. It includes font size, style, aligning
 <li>{=Fx} - selects font size. x ranges from 0 to 1 as follows:
 <li>     0: FONT_9X16 (hieroglyph characters are using the same width as height, i.e. 16x16)
 <li>     1: FONT_12X24 (hieroglyph characters are using the same width as height, i.e. 24x24)
 <li>{=L} - left text aligning
 <li>{=C} - center text aligning
 <li>{=R} - right text aligning
 <li>{=Rx} - text rotation as follows:
 <li>     0: not rotated
 <li>     1: rotated 90 degrees
 <li>     2: rotated 180 degrees
 <li>{+/-B} - sets or unsets bold font style
 <li>{+/-I} - sets or unsets italic font style
 <li>{+/-U} - sets or unsets underline font style
 <li>{+/-V} - sets or unsets inverse font style
 <li>{+/-W} - sets or unsets text word-wrapping
 <li>{+/-DW} - sets or unsets doubled font width
 <li>{+/-DH} - sets or unsets doubled font height
 </ul><p>
 An example of using tags "{=C}Plain centered text\n{=L}Left centered\n{+B}...bold...{-B}{+I}or ITALIC"
 @param textString the text to print
 @param encoding the encoding to use when converting the string to format suitable to the printer. Currently double-byte encodings like JIS are not supported.
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)printText:(NSString *)textString usingEncoding:(NSStringEncoding)encoding;
/**
 Returns different information about printer status/settings
 @param infocmd information type requested, one of the INFO_* constants
 @return the answer specific to the infocmd command
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(int)getInfo:(int)infocmd;
/**
 Returns printer unique serial number
 @return serial number
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(NSString *)getPrinterSerialNumber;
/**
 Returns blackmark sensor treshold or UnsupportedOperationException if printer is not in blackmark mode.
 This value tells the printer how dark a spot on the paper needs to be in order to be considered as blackmark.
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(int)getBlackMarkTreshold;
/**
 Sets blackmark sensor treshold or UnsupportedOperationException if printer is not in blackmark mode.
 This value tells the printer how dark a spot on the paper needs to be in order to be considered as blackmark.
 @param treshold value between 0x20 and 0xc0, default is 0x68
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)setBlackMarkTreshold:(int)treshold;
/**
 Provides blackmark sensor calibration by scaning 200mm of paper for possible black marks and adjust the sensor treshold.
 Make sure you have put the right paper before calling this function.
 @return returns new trashold value for the scanned paper. The trashold is already stored in printer's flash memory so no
 additional set is needed.
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(int)calibrateBlackMark;
/**
 Makes short beep on the printer
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)beep;
/**
 Loads logo into printer's memory. The logo is persistent and can be deleted only if battery is removed
 @param logo logo bitmap data
 @param align logo alignment, one of the ALIGN_* constants
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)loadLogo:(UIImage *)logo align:(int)align;
/**
 Prints Bitmap object. You can print color bitmaps, as they will be converted to black and white using error diffusion and dithering to achieve best results. On older devices this can take some time
 @param image UIImage object
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)printImage:(UIImage *)image;
/**
 Prints Bitmap object using specified alignment. You can print color bitmaps, as they will be converted to black and white using error diffusion and dithering to achieve best results. On older devices this can take some time
 @param image UIImage object
 @param align image alighment, one of the ALIGN_* constants
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(void)printImage:(UIImage *)image align:(int)align;
/**@}*/ //G_DEP_PRNGENERAL


/** @defgroup G_DEP_PRNBARCODEREADER Barcode Reader Functions
 Functions for scanning barcodes and direct control of the barcode engine
 @ingroup G_DEP_PRINTER
 @{
 */
/**
 Helper function to return string name of barcode type
 @param barcodeType barcode type returned from scanBarcode
 @return barcode type name
 @throw NSPortTimeoutException if there is no connection to the printer
 @throw NSInvalidArgumentException if some of the input parameters are wrong
 */
-(NSString *)barcodeType2Text:(int)barcodeType;
/**
 Scans barcode using the built-in barcode scanning engine
 @return uint8_t array consisting of barcode type in the first uint8_t and barcode data following. Returns null if timeout elapsed
 @throw NSPortTimeoutException if there is no connection to the printer
 @throw NSInvalidArgumentException if some of the input parameters are wrong
 */
-(NSString *)scanBarcode:(int *)barcodeType timeout:(double)timeout;
/**@}*/ //G_DEP_PRNBARCODEREADER


/** @defgroup G_DEP_PRNMSREADER Magnetic Stripe Reader Functions
 Functions to work with the printer's magenetic card reader
 @ingroup G_DEP_PRINTER
 @{
 */

/**
 Reads magnetic stripe card. For PP-60, this function is not needed - the card data is passed via delegate whenever the user swipes a card.
 @param timeout timeout in seconds to read the card data. The actuall scan time may differ, but will be as close as possible to this value
 @return String[3] containing the 3 tracks or null if timeout elapses
 @throw NSPortTimeoutException if there is no connection to the printer
 */
-(NSArray *)msReadCard:(double)timeout;

/**
 Helper function to parse financial card and extract the data - name, number, expiration date.
 The function will extract as much information as possible, fields not found will be set to nil/0.
 @param data - pointer to financialCard structure, where the extracted data will be stored
 @param track1 - track1 information or nil
 @param track2 - track2 information or nil
 @return TRUE if the card tracks represent valid financial card and data was extracted
 @throw NSPortTimeoutException if there is no connection to the printer
 **/
#if !__has_feature(objc_arc)
-(BOOL)msProcessFinancialCard:(financialCard *)data track1:(NSString *)track1 track2:(NSString *)track2;
#endif

/**
 Helper function to parse financial card and extract the data - name, number, expiration date.
 The function will extract as much information as possible.
 @param track1 - track1 information or nil
 @param track2 - track2 information or nil
 @return dictionary containing extracted data or nil if the data is invalid. Keys contained are:
 <table>
 <tr><td>"accountNumber"</td><td>Account number</td></tr>
 <tr><td>"cardholderName"</td><td>Cardholder name, as stored in the card</td></tr>
 <tr><td>"expirationYear"</td><td>Expiration date - year</td></tr>
 <tr><td>"expirationMonth"</td><td>Expiration date - month</td></tr>
 <tr><td>"serviceCode"</td><td>Service code (if any)</td></tr>
 <tr><td>"discretionaryData"</td><td>Discretionary data (if any)</td></tr>
 <tr><td>"firstName"</td><td>Extracted cardholder's first name</td></tr>
 <tr><td>"lastName"</td><td>Extracted cardholder's last name</td></tr>
 </table>
 @throw NSPortTimeoutException if there is no connection to Linea
 **/
-(NSDictionary *)msProcessFinancialCard:(NSString *)track1 track2:(NSString *)track2;
/**@}*/ //G_DEP_PRNMSREADER

/**@}*/ //G_DEP_PRINTER

@end

#endif

/**@}*/ //G_PRINTER
