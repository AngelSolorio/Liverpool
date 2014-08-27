//
//  CloseTerminalData.h
//  CardReader
//
//  Created by SERVICIOS LIVERPOOL on 02/08/12.
//  Copyright (c) 2012 Gonet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloseTerminalData : NSObject
{
    BOOL isError;
	NSString *message;
	NSString *errorCode;
    NSString *computador;
	NSString *devolucion;
	NSString *diferencia;
    NSString *entregado;
    NSString *cierreDocto;
    NSString *puntosRifa;
    NSString *valesPapel;
    NSString *transGuardadas;

}

@property (nonatomic)           BOOL isError;
@property (nonatomic,retain) 	NSString *message;
@property (nonatomic,retain) 	NSString *errorCode;
@property (nonatomic,retain) 	NSString *computador;
@property (nonatomic,retain) 	NSString *devolucion;
@property (nonatomic,retain) 	NSString *diferencia;
@property (nonatomic,retain) 	NSString *entregado;
@property (nonatomic,retain) 	NSString *cierreDocto;
@property (nonatomic,retain) 	NSString *puntosRifa;
@property (nonatomic,retain) 	NSString *valesPapel;
@property (nonatomic,retain) 	NSString *transGuardadas;


@end

