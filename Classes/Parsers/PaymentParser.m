//
//  PaymentParser.m
//  CardReader


#import "PaymentParser.h"

@implementation PaymentParser
@synthesize msgResponse,currentElement;
@synthesize payment;
@synthesize productList;
@synthesize itemModel;
@synthesize promo;
@synthesize refundD;
@synthesize eGlobalsCard;

#define RETURN				@"return"
#define ISERROR				@"isError"
#define MESSAGE				@"message"
#define DOCTO				@"docto"
#define	INSTALLMENT_AMOUNT	@"installmentsAmount"
#define BANK				@"bank"
#define BALANCE_TO_PAY		@"balanceToPay"
#define CODIGO_AUTHORIZACION @"authorizationCode"
#define MONEDERO_BALANCE    @"monederoBalance"

#define PRODUCTOS			@"productos"
#define IDPRODUCTO			@"idProducto"
#define CATEGORIA			@"categoria"
#define DESCRIPCION			@"descripcion"
#define PRECIO				@"precio"
#define LINETYPE			@"lineType"
#define PROMO				@"promo"
#define REGALO				@"regalo"
#define CANTIDAD			@"cantidad"
#define PRECIO_EXTENDIDO	@"precioExtendido"
#define DELIVERY_TYPE       @"deliveryType"
#define DELIVERY_NUMBER     @"deliveryNumber"
#define HAS_DELIVERY_DATE   @"hasDeliveryDate"
#define FECHA_ENTREGA       @"fechaEntrega"
#define ORDER_DELIVERY_DATE @"orderDeliveryDate"
#define FREE                @"free"

#define WARRANTY            @"garantia"
#define REFERNCEWARRANTY    @"referenceWarranty"

#define PROMOCION			@"promocion"
#define PROMODESCRIPCION	@"promoDescripcion"
#define PLANID				@"planId"
#define PLAZO				@"plazo"
#define PORCENTAJE			@"porcentaje"
#define TIPO				@"tipo"
#define BASE_AMOUNT			@"baseAmount"

#define CODIGO_FACTURACION  @"billCode"

#define CAMBIO_EFECTIVO     @"cashReturned"

#define TOTAL_A_PAGAR       @"totalToPay"
#define CANTIDAD_PAGADA     @"amountPayed"

//Refund data
#define ORIGINAL_DATE           @"originalDate"
#define ORIGINAL_STORE_NUMBER   @"originalStoreNumber"
#define ORIGINAL_TERMINAL       @"originalTerminal"
#define ORIGINAL_TICKET_NUMBER  @"originalTicketNumber"
#define ORIGINAL_EMPLOYEE       @"originalEmployee"
#define REFUND_CAUSE_NUMBER     @"refundCauseNumber"
#define REFUND_TYPE             @"refundType"

//withdrawn data
#define TOTAL_AMOUNT_WITHDRAWN  @"totalAmountWithdrawn"

//cancel data
#define HAS_EGLOBAL_CARDS  @"hasEglobalCards"
#define EGLOBAL_CARDS           @"eglobalCards"


-(void) startParser:(NSData*) data
{
	//currentElement=[[NSString alloc] init];
	msgResponse=[[NSString alloc] init];
	payment=[[PaymentResponse alloc] init];
	[payment setMessage:[[NSString alloc] init]];
	[payment setIsError:true];
	
	productList=[[NSMutableArray alloc]init];
    eGlobalsCard=[[NSMutableArray alloc]init];
    
    //refundDAta
	refundD=[[RefundData alloc] init];
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	
    [parser setDelegate:self]; // The parser calls methods in this class
    [parser setShouldProcessNamespaces:NO]; 
    [parser setShouldReportNamespacePrefixes:NO]; //
    [parser setShouldResolveExternalEntities:NO]; 
	
    [parser parse]; // Parse that data..
	/*
	NSError *err;
    if (err && [parser parserError]) {
        err = [parser parserError];
    }*/

    [parser release];
}

-(void) parserDidStartDocument:(NSXMLParser *)parser
{
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
	DLog(@"Finalizo parser");
	DLog(@"productlist %i ,%@",[productList count],productList );
	for (FindItemModel *item in productList) {
		DLog(@"itemmodel ,%@",item.description );
		for (Promotions *promos in item.discounts) {
			DLog(@"promos in itemmodel %i ,%@", [item.discounts count],promos.promoDescription );
			DLog(@"promos in itemmodel %@", promos.promoBaseAmount );
			DLog(@"promos in itemmodel %@", promos.promoDiscountPercent );
			DLog(@"promos in itemmodel %@", promos.promoTypeBenefit );

		}
	}
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	currentElement=elementName;
	
	if ([currentElement isEqualToString:PRODUCTOS]) {
		itemModel =[[FindItemModel alloc]init];
		[productList addObject:itemModel];
		[itemModel release];
		DLog(@"currentelement payparser producto: %@",currentElement);
		
	}
	else if ([currentElement isEqualToString:PROMOCION]) {
		promo=[[Promotions alloc]init];
		[self.itemModel.discounts addObject:promo];
		[promo release];
		DLog(@"currentelement payparser promocion: %@",currentElement);

    } else if ([currentElement isEqualToString:WARRANTY]) {
        NSLog(@"Did start warranty %@",currentElement);
    }
	
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"end current element %@",elementName);
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (!string) {
		string=@"";
	}
	if ([currentElement isEqualToString:RETURN]) {
		msgResponse=[msgResponse stringByAppendingString:string];
	}else if ([currentElement isEqualToString:ISERROR]) {
		if([string isEqualToString:@"false"]){
			[payment setIsError:false];
		}else {
			[payment setIsError:true];
	
		}
	
	}else if ([currentElement isEqualToString:MESSAGE]) {
		[payment setMessage:[payment.message stringByAppendingString:string]];

	}else if ([currentElement isEqualToString:DOCTO]) {
		[payment setDocto:string];
	}
    else if ([currentElement isEqualToString:CODIGO_FACTURACION]) {
		[payment setRFCCode:string];
	}
	else if ([currentElement isEqualToString:INSTALLMENT_AMOUNT]) {
		[payment setMonthlyInterest:string];
	}
	else if ([currentElement isEqualToString:BANK]) {
		//[payment setBank:string];
        [payment setBank:([string length]==0)?@"":string];

	}
	else if ([currentElement isEqualToString:BALANCE_TO_PAY]) {
		[payment setBalanceToPay:string];
	}
    else if ([currentElement isEqualToString:MONEDERO_BALANCE]) {
		[payment setMonederoBalance:string];
	}
    else if ([currentElement isEqualToString:CAMBIO_EFECTIVO]) {
		[payment setCashReturned:string];
	}
    else if ([currentElement isEqualToString:TOTAL_A_PAGAR]) {
		[payment setTotalToPay:string];
	}
    else if ([currentElement isEqualToString:CANTIDAD_PAGADA]) {
		[payment setAmountPayed:string];
	}
	else if ([currentElement isEqualToString:CODIGO_AUTHORIZACION]) {
        //[payment setAuthorizationCode:string];
        [payment setAuthorizationCode:([string length]==0)?@"":string];

	}
    else if ([currentElement isEqualToString:DELIVERY_NUMBER]) {
		[payment setDeliveryNumber:string];
        
	}
    else if ([currentElement isEqualToString:DELIVERY_TYPE]) {
		[payment setDeliveryType:string];
	}
    else if ([currentElement isEqualToString:ORDER_DELIVERY_DATE]) {
		[payment setOrderDeliveryDate:string];
	}
    else if ([currentElement isEqualToString:HAS_DELIVERY_DATE]) {
		if([string isEqualToString:@"false"]){
			[payment setHasDeliveryDate:false];
		}else {
			[payment setHasDeliveryDate:true];
            
		}
    }
    ///******************withdraw**************************************
    else if ([currentElement isEqualToString:TOTAL_AMOUNT_WITHDRAWN]) {
		[payment setTotalAmountWithdrawn:string];
	}
	///******************product**************************************
	else if ([currentElement isEqualToString:IDPRODUCTO]) {
		[itemModel setBarCode:string];
	}
	else if ([currentElement isEqualToString:CATEGORIA]) {
		[itemModel setDepartment:string];
	}
	else if ([currentElement isEqualToString:DESCRIPCION]) {
		//[itemModel setDescription:string];
        itemModel.description=[itemModel.description stringByAppendingString:string]; //fix 1.4.4

	}
	else if ([currentElement isEqualToString:PRECIO]) {
		[itemModel setPrice:string];
	}
    else if ([currentElement isEqualToString:PRECIO_EXTENDIDO]) {
        [itemModel setPriceExtended:string];
	}
    else if ([currentElement isEqualToString:WARRANTY]) {
        [itemModel setIsWarranty:[string boolValue]];
    }
	else if ([currentElement isEqualToString:LINETYPE]) {
		[itemModel setLineType:string];
	}
	else if ([currentElement isEqualToString:PROMO]) {
		[itemModel setPromo:([string isEqualToString:@"true"] ? YES : NO)];
	}
    else if ([currentElement isEqualToString:REGALO]) {
		[itemModel setItemForGift:([string isEqualToString:@"true"] ? YES : NO)];
	}
    else if ([currentElement isEqualToString:CANTIDAD]) {
        [itemModel setItemCount:string];
        
	}
    else if ([currentElement isEqualToString:FECHA_ENTREGA]) {
        [itemModel setDeliveryDate:string];
    }
    else if ([currentElement isEqualToString:REFERNCEWARRANTY]){
        [payment setReferenceWarranty:[[string copy] autorelease]];
    }
    else if ([currentElement isEqualToString:FREE]) {
        if ([string isEqualToString:@"false"]) //patch 1.4.5 rev3 shorter response time
            itemModel.isFree = false;
        if ([string isEqualToString:@"true"])
            itemModel.isFree = true;
    }
    
	//----------------promo------------------------------------
	else if ([currentElement isEqualToString:PROMODESCRIPCION]) {
		[promo setPromoDescription:string];
	}
	else if ([currentElement isEqualToString:PLANID]) {
		[promo setPlanId:string];
	}
	else if ([currentElement isEqualToString:PLAZO]) {
		[promo setPromoInstallmentSelected:string];
	}
	else if ([currentElement isEqualToString:PORCENTAJE]) {
		[promo setPromoDiscountPercent:string];
	}
	else if ([currentElement isEqualToString:TIPO]) {
		[promo setPromoTypeBenefit:string];
		[self assignPromoType:string];
	}
    else if ([currentElement isEqualToString:BASE_AMOUNT]) {
		[promo setPromoBaseAmount:string];
	}

	//------------------Refund-----------------------------------------
    else if ([currentElement isEqualToString:ORIGINAL_DATE]) {
		[refundD setSaleDate:string];
	}
    else if ([currentElement isEqualToString:ORIGINAL_STORE_NUMBER]) {
		[refundD setOriginalStore:string];
	}
    else if ([currentElement isEqualToString:ORIGINAL_TERMINAL]) {
		[refundD setOriginalTerminal:string];
	}
    else if ([currentElement isEqualToString:ORIGINAL_TICKET_NUMBER]) {
		[refundD setOriginalDocto:string];
	}
    else if ([currentElement isEqualToString:ORIGINAL_EMPLOYEE]) {
		[refundD setOriginalSeller:string];
	}
    else if ([currentElement isEqualToString:REFUND_CAUSE_NUMBER]) {
		[refundD setRefundCauseNumber:string];
	}
    else if ([currentElement isEqualToString:REFUND_TYPE]) {
		[refundD setRefundReason:string];
	}
    
    //----------------------cancel data-------------------
    else if ([currentElement isEqualToString:HAS_EGLOBAL_CARDS]) {
		[payment setHasEglobalCards:([string isEqualToString:@"true"] ? YES : NO)];
	}
    else if ([currentElement isEqualToString:EGLOBAL_CARDS]) {
		[eGlobalsCard addObject:string];
	}
}

-(void) assignPromoType:(NSString*)promoTypeBenefit {
      if ([promoTypeBenefit isEqualToString:@"FactorLoyaltyBenefit"]) {
            [promo setPromoType:1];
        }
        if ([promoTypeBenefit isEqualToString:@"descuentoTeclaPorcentaje"]||[promoTypeBenefit isEqualToString:@"PercentageDiscount"]) {
            [promo setPromoType:3];
        }
        else if ([promoTypeBenefit isEqualToString:@"descuentoTeclaMonto"]) {
            [promo setPromoType:4];
        }
    
}
-(NSString*) getMessageResponse{
	return [payment message];
}
-(BOOL) getStateOfMessage{
	DLog(@"payparserMesagge %@", payment.message);
	if(![payment isError])
		return YES;
	else 
		return NO;
}
-(NSMutableArray*) returnSaleProductList
{
	
	return productList;
}
-(void)dealloc
{
    [eGlobalsCard release];
    [refundD release];
	//[promo release];
	//[productList release];
	//[itemModel release];
	[payment release],payment=nil;
	//[msgResponse release];
	//[currentElement release];
	[super dealloc];
}
@end
