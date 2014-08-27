//
//  CloseTerminalData.m
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 02/08/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import "CloseTerminalData.h"

@implementation CloseTerminalData
@synthesize isError;
@synthesize message;
@synthesize errorCode;
@synthesize computador;
@synthesize devolucion;
@synthesize diferencia;
@synthesize entregado;
@synthesize cierreDocto;
@synthesize puntosRifa;
@synthesize valesPapel;
@synthesize transGuardadas;

-(void) dealloc
{
    [super dealloc];
    [message release];
    [errorCode release];
    [computador release];
    [devolucion release];
    [diferencia release];
    [entregado release];
    [cierreDocto release];
    [puntosRifa release];
    [valesPapel release];
    [transGuardadas release];
}
@end
