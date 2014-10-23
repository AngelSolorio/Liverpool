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
@property (strong , nonatomic) NSString *telephone;
@property (strong, nonatomic) NSString *telephoneConfirmation;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSMutableString *errors;
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
        _birthday = birthday;
        _telephone = telephone;
        _telephoneConfirmation = telephoneConfirmation;
    }
    return self;
}

-(BOOL)valid{
    BOOL isValid;
    if (_birthday.length>0 && _telephone.length>0 && _telephoneConfirmation.length>0) {
        if ([_telephone isEqualToString:_telephoneConfirmation]) {
            isValid = YES;
        } else{
            [self.errors appendString:TELEPHONEMISMATCH_ERROR];
            isValid =NO;
        }
    } else {
        if(_telephone.length == 0) [self.errors appendString:[NSString stringWithFormat:@"%@\n",TELEPHONEISBLANK_ERROR]];
        if(_telephoneConfirmation.length == 0) [self.errors appendString:[NSString stringWithFormat:@"%@\n", TELEPHONECONFIRMATIONISBLANK_ERROR]];
        if(_birthday.length == 0) [self.errors appendString:[NSString stringWithFormat:@"%@\n", BIRTHDAYISBLANK_ERROR]];
        isValid = NO;
        NSLog(@"errors %@",self.errors);
    }
    return isValid;
}

-(NSString *)birthday{
    return _birthday;
}

-(NSString *)telephone{
    return _telephone;
}

-(NSMutableString *)completeErrors{
    return [self errors];
}
@end
