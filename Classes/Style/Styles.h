//
//  Styles.h
//  TokenVirtual
//
//  Created by Martha Patricia Sagahón Azúa on 20/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface Styles : NSObject {

}
+(void) estiloGeneralDelBoton:(UIButton*)aBoton;
+(void) cornerView:(UIView*)aView;
+(void) bgGradientColorPurple:(UIView*) aView;
+(void) bgGradientButtonEmpty:(UIButton*) aButton;
+(void) bgGradientButtonBusy:(UIButton*) aButton;
+(void) bgGradientButtonSelected:(UIButton*) aButton;
//+(void) menuButtonStyle:(UIButton*)aButton;
+(void) scanReaderViewStyle:(UIView*) aView;
+(void) purpleButtonStyle:(UIButton*) aButton;
+(void) silverButtonStyle:(UIButton*) aButton;
+(void)	purpleLabelText:(UILabel*)aLabel;
+(void)	purpleLabelBackground:(UILabel*)aLabel;
+(void) menuTransactionButtonStyle:(UIButton*) aButton;

@end
