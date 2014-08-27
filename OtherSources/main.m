//
//  main.m
//  CardReader


#import <UIKit/UIKit.h>
#import "CardReaderAppDelegate.h"
/*
int main(int argc, char *argv[])
{
	int retVal = 0;
	
	@autoreleasepool {
		
	    retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([CardReaderAppDelegate class]));
	
	}
	
	return retVal;
}
*/
int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
