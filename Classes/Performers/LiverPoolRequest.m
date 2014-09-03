//
//  LiverPoolRequest.m
//  LiverPoolClient
//
//  Created by Gonet on 03/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LiverPoolRequest.h"
#import "FindItemModel.h"
#import "Promotions.h"
#import "Seller.h"
#import "Card.h"
#import "Session.h"
#import "PromotionGroup.h"
#import "Tools.h"
#import "MesaDeRegalo.h"
#import "RefundData.h"
#import "WithdrawData.h"
#import "WithdrawDataList.h"
#import "CardDataList.h"

@implementation LiverPoolRequest
@synthesize receivedData,requestType,delegate;

- (void)startRequest{
	
	if (receivedData) 
	{
		[receivedData release];
		receivedData=nil;
	}
	receivedData=[[NSMutableData alloc] init]; //30.0
	timerRequest = [NSTimer scheduledTimerWithTimeInterval: 30.0 target:self selector:@selector(timerRequestValidation) userInfo:nil repeats: YES];
}


#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	//NSString* dataAsString = [[[NSString alloc] initWithData: data encoding: NSASCIIStringEncoding] autorelease];
	//DLog(@"dataAsString: %@",dataAsString);
	[receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	DLog(@"didReceiveResponse...");
	
	[self invalidateTimer];
	
	NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
	
	DLog(@"getResponseCode: %d",[httpResponse statusCode]);
	DLog(@"Response: %@",[httpResponse textEncodingName]);
	DLog(@"AllHeaderFields: %@",[httpResponse allHeaderFields]);
	NSString* locationReal=[[httpResponse allHeaderFields] objectForKey:@"Location"];
	DLog(@"Location: %@",locationReal);
	DLog(@"Description: %@",[httpResponse description]);
	
	
	DLog(@"didReceiveResponse...");
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSHTTPURLResponse *)response {
	DLog(@"************************");
	NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
	
	DLog(@"getResponseCode: %d",[httpResponse statusCode]);
	DLog(@"Response:: %@",[httpResponse textEncodingName]);
	DLog(@"Location:: %@",[httpResponse allHeaderFields]);
	DLog(@"Location:: %@",[[httpResponse allHeaderFields] objectForKey:@"Location"]);
	DLog(@"Description %@",[httpResponse description]);
	DLog(@"Received redirect Response: %@ %@", [response allHeaderFields], [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]]);
	int statusCode=[httpResponse statusCode];
	
	DLog(@"************************ %d.",statusCode);
	return request;
}

-(void) sendRequest:(NSString*) requestName forParameters:(NSArray*)parameters forRequestType:(RequestType) reqType
{
	requestType=reqType;
	[self startRequest];
	
	NSString * soapmessage=[self createEnvelope:requestName forParameters:parameters];
	//[soapmessage retain];
	
	//172.22.209.172:8080
	
	//NSURL *url=[NSURL URLWith	String:@"http://172.16.12.56:8090/MyLiverpool/LiverpoolWebService?wsdl"];//Ambiente Paty
	//NSURL *url=[NSURL URLWithString:@"http://201.148.157.185:8080/MyLiverpool/LiverpoolWebService?wsdl"];//Ambiente Gonet
	//NSURL *url=[NSURL URLWithString:@"http://172.22.209.172:8080/MyLiverpool/LiverpoolWebService?wsdl"];//Tomcat Liverpool
	//NSURL *url=[NSURL URLWithString:@"http://172.29.3.24:8080/MyLiverpool/LiverpoolWebService?wsdl"];//Tomcat Liverpool instalado Interlomas
	//NSURL *url=[NSURL URLWithString:@"http://172.22.209.161:8080/MyLiverpool/LiverpoolWebService?wsdl"];//Tomcat Liverpool instalado
	NSString *stringURL=[NSString stringWithFormat:@"http://%@:8080/MyLiverpool/LiverpoolWebService?wsdl",[Session getServerAddress]];
    NSURL *url=[NSURL URLWithString:stringURL];
    
   DLog(@"stringURL %@",stringURL);
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
	NSString *msgLength=[NSString stringWithFormat:@"%d", [soapmessage length]];
	
	[request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];	
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[soapmessage dataUsingEncoding:NSUTF8StringEncoding]];
	NSURLConnection *connection=[[[NSURLConnection alloc] initWithRequest:request delegate:self]autorelease];

	[connection start];

	DLog(@"soapmessage: %@",soapmessage);
}		

- (NSString*) createEnvelope: (NSString*) method forParameters: (NSArray*) params 
{
	NSMutableString* s = [NSMutableString string];
	[s appendString: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
	[s appendString: @"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:tns=\"http://us.liverpool.mx/\">"];
	/*if(headers != nil && headers.count > 0) {
		[s appendString: @"<soap:Header>"];
		for(id key in [headers allKeys]) {
			if([[headers objectForKey: key] isMemberOfClass: [SoapNil class]]) {
				[s appendFormat: @"<%@ xsi:nil=\"true\"/>", key];
			} else {
				[s appendString:[Soap serializeHeader:headers forKey:key]];
			}
		}
		[s appendString: @"</soap:Header>"];
	}*/
	//[s appendFormat: @"<%@>%@</%@>", method,[params stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"], method];
	//[s appendFormat:@"<idProducto>%@</idProducto>",params];

	[s appendString: @"<soap:Body>"];
	[s appendFormat:@"<tns:%@>",method];
	[s appendString:[self buildParameterBody:params]];
	[s appendFormat:@"</tns:%@>",method];
	[s appendString: @"</soap:Body>"];
	[s appendString: @"</soap:Envelope>"];
    
    NSString *xmlConstructor = [[NSBundle mainBundle] pathForResource:@"xmlConstructor" ofType:@"xml"];
    NSString *xmlContent = [[NSMutableString alloc] initWithContentsOfFile:xmlConstructor encoding:NSUTF8StringEncoding error:nil];
    xmlContent = [xmlContent stringByReplacingOccurrencesOfString:@"#body#" withString:[self buildParameterBody:params]];
    xmlContent = [xmlContent stringByReplacingOccurrencesOfString:@"#request_name#" withString:method];
    xmlContent = [xmlContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    xmlContent = [xmlContent stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSLog(@"Xml content %@",xmlContent);
	return xmlContent;
}
/* build the methods and parameters of the specified method*/
-(NSString*) buildParameterBody:(NSArray*)parameters
{
    NSMutableString *xmlFormat=[NSMutableString string];
	NSArray *params= [self buildParameterNodes];
    
	for (NSObject* par in parameters) {
		if ([par isKindOfClass:[NSArray class]]){
			if ([((NSArray*)par) count]>0 ) {
				NSObject* obj=[((NSArray*)par) objectAtIndex:0];
				if ([obj isKindOfClass:[FindItemModel class]]) {
                    NSMutableString *itemBody = [[[NSMutableString alloc] init] autorelease];
					for (FindItemModel* fim in (NSArray*) par) {
                        NSString *itemFindPath = [[NSBundle mainBundle] pathForResource:@"itemBodyFindRequest" ofType:@"xml"];
                        NSString *itemFindContent = [[NSString alloc] initWithContentsOfFile:itemFindPath encoding:NSUTF8StringEncoding error:nil];
                        itemFindContent = [itemFindContent stringByReplacingOccurrencesOfString:@"#product_id#" withString:fim.barCode];
                        itemFindContent = [itemFindContent stringByReplacingOccurrencesOfString:@"#category#" withString:fim.department];
                        itemFindContent = [itemFindContent stringByReplacingOccurrencesOfString:@"#price#" withString:fim.price];
                        itemFindContent = [itemFindContent stringByReplacingOccurrencesOfString:@"#description#" withString:[fim getXMLdescription]];
                        itemFindContent = [itemFindContent stringByReplacingOccurrencesOfString:@"#line_type#" withString:fim.lineType];
                        itemFindContent = [itemFindContent stringByReplacingOccurrencesOfString:@"#promotion#" withString:fim.promo?@"true":@"false"];
                        itemFindContent = [itemFindContent stringByReplacingOccurrencesOfString:@"#gift#" withString:fim.itemForGift?@"true":@"false"];
                        itemFindContent = [itemFindContent stringByReplacingOccurrencesOfString:@"#quantity#" withString:fim.itemCount];
                        itemFindContent = [itemFindContent stringByReplacingOccurrencesOfString:@"#extended_price#" withString:fim.priceExtended];
                        itemFindContent = [itemFindContent stringByReplacingOccurrencesOfString:@"#delivery_date#" withString:fim.deliveryDate];
                        [itemBody appendString:itemFindContent];

						for (Promotions *promo in fim.discounts) {
                            NSString *promotionsPath = [[NSBundle mainBundle] pathForResource:@"itemPromotionsRequest" ofType:@"xml"];
                            NSString *promotionsContent = [[NSString alloc] initWithContentsOfFile:promotionsPath encoding:NSUTF8StringEncoding error:nil];
                            promotionsContent = [promotionsContent stringByReplacingOccurrencesOfString:@"#type#" withString:promo.promoTypeBenefit];
                            promotionsContent = [promotionsContent stringByReplacingOccurrencesOfString:@"#percentage#" withString:promo.promoDiscountPercent];
                            promotionsContent = [promotionsContent stringByReplacingOccurrencesOfString:@"#description#" withString:promo.promoDescription];
                            promotionsContent = [promotionsContent stringByReplacingOccurrencesOfString:@"#term#" withString:promo.promoInstallmentSelected];
                            promotionsContent = [promotionsContent stringByReplacingOccurrencesOfString:@"#id_plan#" withString:promo.planId];
                            [itemBody appendString:promotionsContent];
						}
                        NSString *itemBodyPath = [[NSBundle mainBundle] pathForResource:@"itemConstructorFindRequest" ofType:@"xml"];
                        NSString *itemBodyContent = [[NSString alloc] initWithContentsOfFile:itemBodyPath encoding:NSUTF8StringEncoding error:nil];
                        itemBodyContent = [itemBodyContent stringByReplacingOccurrencesOfString:@"#product_body#" withString:itemBody];
                        [xmlFormat appendString:itemBodyContent];
					}
				}

			}
		}
		if ([par isKindOfClass:[NSString class]]) {
			int index=[parameters indexOfObjectIdenticalTo:par];
			[xmlFormat appendFormat:@"<%@>%@</%@>",[params objectAtIndex:index],[parameters objectAtIndex:index],[params objectAtIndex:index]];
		}
     
		// card space
        if ([par isKindOfClass:[Card class]])
        {
            Card *cardData=(Card*) par;
            NSString *cardDataPath = [[NSBundle mainBundle] pathForResource:@"cardDataRequest" ofType:@"xml"];
            NSString *cardDataContent = [[NSString alloc] initWithContentsOfFile:cardDataPath encoding:NSUTF8StringEncoding error:NULL];
            cardDataContent = [cardDataContent stringByReplacingOccurrencesOfString:@"#card_number#" withString:cardData.cardNumber];
            cardDataContent = [cardDataContent stringByReplacingOccurrencesOfString:@"#card_type#" withString:cardData.cardType];
            cardDataContent = [cardDataContent stringByReplacingOccurrencesOfString:@"#track1#" withString:cardData.track1];
            cardDataContent = [cardDataContent stringByReplacingOccurrencesOfString:@"#track2#" withString:cardData.track2];
            cardDataContent = [cardData.track3 length]==0 ? [cardDataContent stringByReplacingOccurrencesOfString:@"#track3#" withString:@""] : [cardDataContent stringByReplacingOccurrencesOfString:@"#track3#" withString:cardData.track3];
            cardDataContent = [cardData.authCode length]==0 ? [cardDataContent stringByReplacingOccurrencesOfString:@"#ds#" withString:@""] : [cardDataContent stringByReplacingOccurrencesOfString:@"#ds#" withString:cardData.authCode];
            cardDataContent = [cardData.expireDate length]==0 ? [cardDataContent stringByReplacingOccurrencesOfString:@"#expiration#" withString:@""] : [cardDataContent stringByReplacingOccurrencesOfString:@"#expiration#" withString:cardData.expireDate];
            cardDataContent = [cardDataContent stringByReplacingOccurrencesOfString:@"#wallet#" withString:cardData.monederoNumber]; //
            cardDataContent = [cardDataContent stringByReplacingOccurrencesOfString:@"#plan#" withString:cardData.planId];
            cardDataContent = [cardDataContent stringByReplacingOccurrencesOfString:@"#term#" withString:cardData.planInstallment];
            cardDataContent = [cardDataContent stringByReplacingOccurrencesOfString:@"#plan_description#" withString:cardData.planDescription];
            cardDataContent = [cardDataContent stringByReplacingOccurrencesOfString:@"#ammount#" withString:cardData.amountToPay];
            [xmlFormat appendString:cardDataContent];
        }
        //---------
		if ([par isKindOfClass:[Seller class]])
		{   NSLog(@"Seller");
            Seller *seller=(Seller*) par;
			NSString *terminal=[Session getTerminal];
            NSString *sellerPath = [[NSBundle mainBundle] pathForResource:@"sellerRequest" ofType:@"xml"];
            NSString *sellerContent = [[NSString alloc] initWithContentsOfFile:sellerPath encoding:NSUTF8StringEncoding error:nil];
            sellerContent = [sellerContent stringByReplacingOccurrencesOfString:@"#user#" withString:seller.userName];
            sellerContent = [sellerContent stringByReplacingOccurrencesOfString:@"#password#" withString:seller.password];
            sellerContent = [sellerContent stringByReplacingOccurrencesOfString:@"#terminal#" withString:terminal];
            sellerContent = [sellerContent stringByReplacingOccurrencesOfString:@"#store#" withString:[Session getIdStore]];
            [xmlFormat appendString:sellerContent];
		}
		if ([par isKindOfClass:[PromotionGroup class]])
		{
            PromotionGroup *promoGroup=(PromotionGroup*) par;
            NSMutableString *promotionsBody = [[[NSMutableString alloc] init] autorelease];
            NSString *promotionGroupPath = [[NSBundle mainBundle] pathForResource:@"promotionGroupRequest" ofType:@"xml"];
            NSString *promotionGroupContent = [[NSString alloc] initWithContentsOfFile:promotionGroupPath encoding:NSUTF8StringEncoding error:nil];
            promotionGroupContent = [promotionGroupContent stringByReplacingOccurrencesOfString:@"#selected_group#" withString:[NSString stringWithFormat:@"%i",promoGroup.section]];
            [promotionsBody appendString:promotionGroupContent];
			
			for (Promotions *promo in promoGroup.promotionGroupArray) {
                NSString *promotionPath = [[NSBundle mainBundle] pathForResource:@"promotionBodyRequest" ofType:@"xml"];
                NSString *promotionContent = [[NSString alloc] initWithContentsOfFile:promotionPath encoding:NSUTF8StringEncoding error:nil];
                promotionContent = [promotionContent stringByReplacingOccurrencesOfString:@"#type#" withString:promo.promoTypeBenefit];
                promotionContent =  [promo.promoDiscountPercent length]==0 ? [promotionContent stringByReplacingOccurrencesOfString:@"#percentage#" withString:@""] : [promotionContent stringByReplacingOccurrencesOfString:@"#percentage#" withString:promo.promoDiscountPercent];
                promotionContent = [promotionContent stringByReplacingOccurrencesOfString:@"#description#" withString:promo.promoDescription];
                promotionContent = [promotionContent stringByReplacingOccurrencesOfString:@"#term#" withString:promo.promoInstallmentSelected];
                promotionContent = [promotionContent stringByReplacingOccurrencesOfString:@"#plan_id#" withString:promo.planId];
                promotionContent = [promotionContent stringByReplacingOccurrencesOfString:@"#base_ammount#" withString:promo.promoBaseAmount];
                [promotionsBody appendString:promotionContent];
			}
            NSString *promotionsBodyPath = [[NSBundle mainBundle] pathForResource:@"promotionsConstructorGroupRequest" ofType:@"xml"];
            NSString *promotionsBodyContent = [[NSString alloc] initWithContentsOfFile:promotionsBodyPath encoding:NSUTF8StringEncoding error:nil];
            promotionsBodyContent = [promotionsBodyContent stringByReplacingOccurrencesOfString:@"#promotions_body#" withString:promotionsBody];
            [xmlFormat appendString:promotionsBodyContent];
		}
        if ([par isKindOfClass:[MesaDeRegalo class]])
		{
            MesaDeRegalo *mesa=(MesaDeRegalo*) par;
            NSString *giftTablePath = [[NSBundle mainBundle] pathForResource:@"giftTableRequest" ofType:@"xml"];
            NSString *giftTableContent = [[NSString alloc] initWithContentsOfFile:giftTablePath encoding:NSUTF8StringEncoding error:nil];
            giftTableContent = [giftTableContent stringByReplacingOccurrencesOfString:@"#father_name#" withString:mesa.fatherName];
            giftTableContent = [giftTableContent stringByReplacingOccurrencesOfString:@"#mother_name#" withString:mesa.momName];
            giftTableContent = [giftTableContent stringByReplacingOccurrencesOfString:@"#r_name#" withString:mesa.nameR];
            [xmlFormat appendString:giftTableContent];
		}
        
        if ([par isKindOfClass:[RefundData class]])
		{
            RefundData *refund=(RefundData*) par;
            NSString *refundDataPath = [[NSBundle mainBundle] pathForResource:@"refundDataRequest" ofType:@"xml"];
            NSString *refundDataContent = [[NSString alloc] initWithContentsOfFile:refundDataPath encoding:NSUTF8StringEncoding error:nil];
            refundDataContent = [refundDataContent stringByReplacingOccurrencesOfString:@"#original_date#" withString:refund.saleDate];
            refundDataContent = [refundDataContent stringByReplacingOccurrencesOfString:@"#original_terminal#" withString:refund.originalTerminal];
            refundDataContent = [refundDataContent stringByReplacingOccurrencesOfString:@"#original_store_number#" withString:refund.originalStore];
            refundDataContent = [refundDataContent stringByReplacingOccurrencesOfString:@"#original_ticket_number#" withString:refund.originalDocto];
            refundDataContent = [refundDataContent stringByReplacingOccurrencesOfString:@"#original_employee#" withString:refund.originalSeller];
            refundDataContent = [refundDataContent stringByReplacingOccurrencesOfString:@"#refund_cause_number#" withString:refund.refundCauseNumber];
            refundDataContent = [refundDataContent stringByReplacingOccurrencesOfString:@"#refund_type#" withString:refund.refundReason];
            [xmlFormat appendString:refundDataContent];
		}

        if ([par isKindOfClass:[WithdrawDataList class]])
		{
            WithdrawDataList *drawList=(WithdrawDataList*) par;
            NSMutableString *withdrawDataListBody = [[[NSMutableString alloc] init] autorelease];

			for (WithdrawData *data in [drawList withdrawList]) {
                NSString *withdrawDataListPath = [[NSBundle mainBundle] pathForResource:@"withdrawDataListRequest" ofType:@"xml"];
                NSString *withdrawDataListContent = [[NSString alloc] initWithContentsOfFile:withdrawDataListPath encoding:NSUTF8StringEncoding error:nil];
                withdrawDataListContent = [withdrawDataListContent stringByReplacingOccurrencesOfString:@"#quantity#" withString:data.quantity];
                withdrawDataListContent = [withdrawDataListContent stringByReplacingOccurrencesOfString:@"#designation#" withString:data.amount];
                [withdrawDataListBody appendString:withdrawDataListContent];
            }
            [xmlFormat appendString:withdrawDataListBody];
		}
        
        if ([par isKindOfClass:[CardDataList class]])
		{
            CardDataList *cardList=(CardDataList*) par;
            NSMutableString *cardDataListBody = [[[NSMutableString alloc] init] autorelease];
            
			for (Card *cardData in [cardList getCardList]) {
                NSString *cardDataListPath = [[NSBundle mainBundle] pathForResource:@"cardDataListRequest" ofType:@"xml"];
                NSString *cardDataListContent = [[NSString alloc] initWithContentsOfFile:cardDataListPath encoding:NSUTF8StringEncoding error:nil];
                cardDataListContent = [cardDataListContent stringByReplacingOccurrencesOfString:@"#card_number#" withString:cardData.cardNumber];
                cardDataListContent = [cardDataListContent stringByReplacingOccurrencesOfString:@"#card_type#" withString:cardData.cardType];
                cardDataListContent = [cardDataListContent stringByReplacingOccurrencesOfString:@"#track1#" withString:cardData.track1];
                cardDataListContent = [cardDataListContent stringByReplacingOccurrencesOfString:@"#track2#" withString:cardData.track2];
                cardDataListContent = [cardDataListContent stringByReplacingOccurrencesOfString:@"#track3#" withString:cardData.track3];
                cardDataListContent = [cardDataListContent stringByReplacingOccurrencesOfString:@"#ds#" withString:cardData.authCode];
                cardDataListContent = [cardDataListContent stringByReplacingOccurrencesOfString:@"#expiration#" withString:cardData.expireDate];
                cardDataListContent = [cardDataListContent stringByReplacingOccurrencesOfString:@"#wallet#" withString:cardData.monederoNumber];
                cardDataListContent = [cardDataListContent stringByReplacingOccurrencesOfString:@"#plan#" withString:cardData.planId];
                cardDataListContent = [cardDataListContent stringByReplacingOccurrencesOfString:@"#term#" withString:cardData.planInstallment];
                cardDataListContent = [cardDataListContent stringByReplacingOccurrencesOfString:@"#plan_description#" withString:cardData.planDescription];
                cardDataListContent = [cardDataListContent stringByReplacingOccurrencesOfString:@"#ammount#" withString:cardData.amountToPay];
                [cardDataListBody appendString:cardDataListContent];
            }
            [xmlFormat appendString:cardDataListBody];
		}
	}
	return xmlFormat;
}

//* returns the parameters names in the request <NAME> </NAME" */
-(NSArray*) buildParameterNodes
{
	if (requestType==buyRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"productos",@"tarjeta",@"vendedor",nil];
		return parameters;

	}
//	if (requestType==firstPaymentRequest||requestType==secondPaymentRequest) { //agregar el amount
//		NSArray *parameters=[NSArray arrayWithObjects:@"productos",@"promociones",@"tarjeta",@"vendedor",@"monto",nil];
//		return parameters;
//		
//	}
	if (requestType==findRequest||requestType==consultSKURequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"idProducto",@"precio",@"terminal",nil];
		return parameters;

	}
//	if (requestType==printingRequest) {
//		NSArray *parameters=[NSArray arrayWithObjects:@"productos",@"firma",@"term",@"docto",@"tda",@"vend",@"atendio",@"tipoBanco",@"card1",@"card2",nil];
//		return parameters;
//	}
	if (requestType==findPromoRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"idProducto",nil];
		return parameters;
	}
	if (requestType==loginRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"usuario",@"password",@"terminal",nil];
		return parameters;
	}
	if (requestType==airtimeRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"numeroTelefonico",@"producto",@"tarjeta",@"vendedor",nil];
		return parameters;
	}
	if (requestType==logoutRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"vendedor",@"tipoDeVenta",nil];
		return parameters;
	}
	if (requestType==loginPrinterRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"user",@"pass",nil];
		return parameters;
	}
	if (requestType==totalizeRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"productos",@"vendedor",@"cuentaEmpleado",nil];
		return parameters;
	}
	if (requestType==buyRequest2) {
		NSArray *parameters=[NSArray arrayWithObjects:@"productos",@"promociones",@"tarjeta",@"vendedor",@"cuentaEmpleado",@"promoFlag",nil];
		return parameters;
	}
    if (requestType==addressRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"terminal",nil];
		return parameters;
	}
    if (requestType==storeListRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"",nil];
		return parameters;
	}
    if (requestType==adminLoginRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"admin",@"password",nil];
		return parameters;
	}
    if (requestType==unregisterRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"terminal",nil];
		return parameters;
	}
    if (requestType==SOMSListRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"numeroSOMS",@"vendedor",@"cuentaEmpleado",nil];
		return parameters;
	}
    if (requestType==SOMSRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"productos",@"promociones",@"tarjeta",@"vendedor",@"cuentaEmpleado",@"mesaRegalo",@"ordenSOMS",nil];
		return parameters;
	}
    if (requestType==closeTerminalRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"vendedor",@"cerrar",nil];
		return parameters;
	}
    if (requestType==restaurantListRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"comanda",@"vendedor",nil];
		return parameters;
	}
    if (requestType==restaurantRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"tarjeta",@"vendedor",@"comanda",@"productos",nil];
		return parameters;
	}
    if (requestType==cancelRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"noTransaccionOriginal",@"montoOriginal",@"vendedor",@"eglobals",nil];
		return parameters;
	}
	if (requestType==refundRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"productos",@"promociones",@"tarjeta",@"vendedor",@"datosDevolucion",@"cuentaEmpleado",nil];
		return parameters;
	}
    if (requestType==cancel_Payment) {
		NSArray *parameters=[NSArray arrayWithObjects:@"vendedor",@"tipoDeVenta",nil];
		return parameters;
	}
    if (requestType==withdraw_Request) {
		NSArray *parameters=[NSArray arrayWithObjects:@"retiros",@"tipoTender",@"vendedor",@"cancelFlag",nil];
		return parameters;
	}
	else
	{
		NSArray *parameters=[NSArray arrayWithObjects:@"",nil];
		return parameters;
	}
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	DLog(@"La Conexion compra ha fallado");
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{	
	DLog(@"La Conexion ha sido completada");
	NSString* dataAsString = [[[NSString alloc] initWithData: receivedData encoding: NSASCIIStringEncoding] autorelease];
	DLog(@"RESPUESTA SERVIDOR: %@",dataAsString);
	//call the delegate method for each class to respond and parse the received data
	[delegate performResults:receivedData :requestType];
}

-(void) timerRequestValidation
{
	[self invalidateTimer];
	[Tools stopActivityIndicator];
	[Tools displayAlert:@"Aviso" message:@"Se ha excedido el tiempo de respuesta"];
    
    [delegate performResults:nil :requestType]; //patch 1.4.5

}

-(void)invalidateTimer
{
	[timerRequest invalidate];
	timerRequest = nil;
}

- (void)dealloc {
	[delegate release];
	[receivedData release];
    [super dealloc];
}
@end
