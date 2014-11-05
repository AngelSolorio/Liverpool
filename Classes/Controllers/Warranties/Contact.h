//
//  NSActiveRecodValidation.h
//  CardReader
//
//  Created by Arturo Jaime Guerrero on 20/10/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject
-(id)initWithTelephone:(id)telephone telephoneConfirmation:(NSString *)telephoneConfirmation birthday:(NSString *)birthday;
-(BOOL)valid;
-(NSMutableString *)completeErrors;
@property (retain , nonatomic) NSString *telephone;
@property (retain, nonatomic) NSString *telephoneConfirmation;
@property (retain, nonatomic) NSString *birthday;

@end
