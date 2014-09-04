//
//  NSString+Validation.m
//  CardReader
//
//  Created by Jonathan Esquer on 04/09/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import "NSString+XML.h"

@implementation NSString (XML)
-(NSString *)stringByReplacingXMLOcurrencesOfString:(NSString *)stringToReplace withValidString:(NSString *)stringToAdd
{
    NSString *validString;
    validString = [stringToAdd length]==0 ? [self stringByReplacingOccurrencesOfString:stringToReplace withString:@""] : [self stringByReplacingOccurrencesOfString:stringToReplace withString:stringToAdd];
    return validString;
}
@end
