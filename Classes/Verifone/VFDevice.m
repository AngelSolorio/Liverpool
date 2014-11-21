//
//  Vx600.m
//  CardReaderVerifone
//
//  Created by Arturo Jaime Guerrero on 07/09/14.
//  Copyright (c) 2014 Creadtibe Soluciones Tecnológicas. All rights reserved.
//

#import "VFDevice.h"

@implementation VFDevice
+(VFIPinpad *)pinPad
{
    static VFIPinpad *_pinPad=nil;
    if (_pinPad==nil) {
        _pinPad = [[VFIPinpad alloc] init];
    }
    return _pinPad;
}

+(VFIBarcode *)barcode
{
    static VFIBarcode *_barcode=nil;
    if (_barcode==nil) {
        _barcode=[[VFIBarcode alloc] init];
    }
    return _barcode;
}

+(VFIControl *)control
{
    static VFIControl *_control=nil;
    if (_control==nil) {
        _control=[[VFIControl alloc] init];
    }
    return _control;
}

+(void)initVFDevices
{   NSLog(@"Init the devices");
    [[self pinPad] initDevice];
    [[self barcode] initDevice];
    [[self control] initDevice];
}

+(void)setBarcodeInitialization
{
    [[VFDevice barcode] mStartScan];
    [[self barcode] setLevel];
    [[self barcode] setBeepOn];
    [[self barcode] includeAllBarcodeTypes];
    [[self barcode] barcodeTypeEnabled:YES];
    [[self barcode] mTriggerMode:1];
}

+(void)setPinPadInitialization
{
    [[self pinPad] enableMSRDualTrack];
}

+(void)clearPheri
@end
