//
//  Vx600.h
//  CardReaderVerifone
//
//  Created by Arturo Jaime Guerrero on 07/09/14.
//  Copyright (c) 2014 Creadtibe Soluciones Tecnológicas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VMF/VMFramework.h>
#import  <ExternalAccessory/ExternalAccessory.h>

@interface VFDevice : NSObject
+(VFIPinpad *)pinPad;
+(VFIControl *)control;
+(VFIBarcode *)barcode;
+(void)initVFDevices;
+(void)setBarcodeInitialization;
@end
