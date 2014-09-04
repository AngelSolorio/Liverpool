//
//  NSString+Validation.h
//  CardReader
//
//  Created by Jonathan Esquer on 04/09/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XML)
//Returns a string with an empty string that replaces stringToReplace if stringToAdd is null, otherwise it replaces the stringToReplace with the stringToAdd value.
-(NSString *)stringByReplacingXMLOcurrencesOfString:(NSString *)stringToReplace withValidString:(NSString *)stringToAdd;
@end
