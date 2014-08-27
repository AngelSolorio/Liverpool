//
//  MesaDeRegalo.m
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 25/07/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import "MesaDeRegalo.h"

@implementation MesaDeRegalo

@synthesize nameR;
@synthesize fatherName;
@synthesize momName;
@synthesize regaloNumber;


-(void) dealloc
{
    [super dealloc];
    [nameR release];
    [fatherName release];
    [momName release];
    [regaloNumber release];
}
@end
