//
//  NSActiveRecodValidation.m
//  CardReader
//
//  Created by Arturo Jaime Guerrero on 20/10/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import "Contact.h"
#define TELEPHONEMISMATCH_ERROR @"Los teléfonos no coinciden."
#define TELEPHONEISBLANK_ERROR @"Teléfono no puede estar en blanco."
#define TELEPHONECONFIRMATIONISBLANK_ERROR  @"Confirmación de teléfono no puede estar en blanco."
#define BIRTHDAYISBLANK_ERROR @"Cumpleaños no puede estar en blanco."

@interface Contact ()
@property (retain, nonatomic) NSMutableString *errors;
@end

@implementation Contact
@synthesize telephone = _telephone;
@synthesize telephoneConfirmation = _telephoneConfirmation;
@synthesize birthday = _birthday;
@synthesize errors = _errors;

-(NSMutableString *)errors{
    if(!_errors) _errors = [NSMutableString string];
    return _errors;
}

-(id)initWithTelephone:(id)telephone telephoneConfirmation:(NSString *)telephoneConfirmation birthday:(NSString *)birthday;
{
    if (self = [super init]) {
        self.birthday = birthday;
        self.telephone = telephone;
        self.telephoneConfirmation = telephoneConfirmation;
    }
    return self;
}

-(BOOL)valid{
    BOOL isValid;
    if (self.birthday.length>0 && self.telephone.length>0 && self.telephoneConfirmation.length>0) {
        if ([self.telephone isEqualToString:self.telephoneConfirmation]) {
            isValid = YES;
        } else{
            [self.errors appendString:TELEPHONEMISMATCH_ERROR];
            isValid =NO;
        }
    } else {
        if(self.telephone.length == 0) [self.errors appendString:[NSString stringWithFormat:@"%@\n",TELEPHONEISBLANK_ERROR]];
        if(self.telephoneConfirmation.length == 0) [self.errors appendString:[NSString stringWithFormat:@"%@\n", TELEPHONECONFIRMATIONISBLANK_ERROR]];
        if(self.birthday.length == 0) [self.errors appendString:[NSString stringWithFormat:@"%@\n", BIRTHDAYISBLANK_ERROR]];
        isValid = NO;
        NSLog(@"errors %@",self.errors);
    }
    return isValid;
}

-(NSString *)birthday{
    if (!_birthday) _birthday = [[NSString alloc] init];
    return _birthday;
}

-(NSString *)telephone{
    if(!_telephone) _telephone = [[NSString alloc] init];
    return _telephone;
}

-(NSMutableString *)completeErrors{
    return [self errors];
}
@end
