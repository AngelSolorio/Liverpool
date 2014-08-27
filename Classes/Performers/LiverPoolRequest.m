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
	return s;
}
/* build the methods and parameters of the specified method*/
-(NSString*) buildParameterBody:(NSArray*)parameters
{
	NSMutableString *s=[[[NSMutableString alloc] init] autorelease];
	NSArray *params= [self buildParameterNodes];
	
	for (NSObject* par in parameters) {

		if ([par isKindOfClass:[NSArray class]]){
			if ([((NSArray*)par) count]>0 ) {
				NSObject* obj=[((NSArray*)par) objectAtIndex:0];
				if ([obj isKindOfClass:[FindItemModel class]]) {
					for (FindItemModel* fim in (NSArray*) par) {
						[s appendString:@"<productos>"];
						[s appendFormat:@"<idProducto>%@</idProducto>",fim.barCode];
						[s appendFormat:@"<categoria>%@</categoria>",fim.department];
						[s appendFormat:@"<precio>%@</precio>",fim.price];
						[s appendFormat:@"<descripcion>%@</descripcion>",[fim getXMLdescription]];
						[s appendFormat:@"<lineType>%@</lineType>",fim.lineType];
						[s appendFormat:@"<promo>%@</promo>",fim.promo?@"true":@"false"];
                        [s appendFormat:@"<regalo>%@</regalo>",fim.itemForGift?@"true":@"false"];	
						[s appendFormat:@"<cantidad>%@</cantidad>",fim.itemCount];
						[s appendFormat:@"<precioExtendido>%@</precioExtendido>",fim.priceExtended];
						[s appendFormat:@"<fechaEntrega>%@</fechaEntrega>",fim.deliveryDate];

						for (Promotions *promo in fim.discounts) {
							[s appendString:@"<promocion>"];
							[s appendFormat:@"<tipo>%@</tipo>",promo.promoTypeBenefit];
							[s appendFormat:@"<porcentaje>%@</porcentaje>",promo.promoDiscountPercent];
							[s appendFormat:@"<descripcion>%@</descripcion>",promo.promoDescription];
							[s appendFormat:@"<plazo>%@</plazo>",promo.promoInstallmentSelected];
							[s appendFormat:@"<planId>%@</planId>",promo.planId];
							[s appendString:@"</promocion>"];
						}
						[s appendString:@"</productos>"];
					}
                    
                    
				}

			}

		}
		if ([par isKindOfClass:[NSString class]]) {
			int index=[parameters indexOfObjectIdenticalTo:par];
			[s appendFormat:@"<%@>%@</%@>",[params objectAtIndex:index],[parameters objectAtIndex:index],[params objectAtIndex:index]];
		}
     
		// card space
        if ([par isKindOfClass:[Card class]])
        {	Card *cardData=(Card*) par;
            [s appendString:@"<tarjeta>"];
            [s appendFormat:@"<noTarjeta>%@</noTarjeta>",cardData.cardNumber];
            [s appendFormat:@"<tipoTarjeta>%@</tipoTarjeta>",cardData.cardType];
            [s appendFormat:@"<track1>%@</track1>",cardData.track1];
            [s appendFormat:@"<track2>%@</track2>",cardData.track2];
            [s appendFormat:@"<track3>%@</track3>",cardData.track3];
            [s appendFormat:@"<ds>%@</ds>",cardData.authCode];
            [s appendFormat:@"<expiracion>%@</expiracion>",cardData.expireDate];
            [s appendFormat:@"<monedero>%@</monedero>",cardData.monederoNumber];
            [s appendFormat:@"<plan>%@</plan>",cardData.planId];
            [s appendFormat:@"<plazo>%@</plazo>",cardData.planInstallment];
            [s appendFormat:@"<planDescripcion>%@</planDescripcion>",cardData.planDescription];
            [s appendFormat:@"<monto>%@</monto>",cardData.amountToPay];
            
            [s appendString:@"</tarjeta>"];
        }
        //---------
		if ([par isKindOfClass:[Seller class]])
		{	Seller *seller=(Seller*) par;
			NSString *terminal=[Session getTerminal];
			[s appendString:@"<vendedor>"];
			[s appendFormat:@"<usuario>%@</usuario>",seller.userName];
			[s appendFormat:@"<password>%@</password>",seller.password];
			[s appendFormat:@"<terminal>%@</terminal>",terminal];
            [s appendFormat:@"<tienda>%@</tienda>",[Session getIdStore]];
			[s appendString:@"</vendedor>"];
		}
		if ([par isKindOfClass:[PromotionGroup class]])
		{	PromotionGroup *promoGroup=(PromotionGroup*) par;
			[s appendString:@"<promociones>"];
			[s appendFormat:@"<grupoSeleccionado>%i</grupoSeleccionado>",promoGroup.section];
			
			for (Promotions *promo in promoGroup.promotionGroupArray) {
				[s appendString:@"<promocion>"];
				[s appendFormat:@"<tipo>%@</tipo>",promo.promoTypeBenefit];
				[s appendFormat:@"<porcentaje>%@</porcentaje>",promo.promoDiscountPercent];
				[s appendFormat:@"<descripcion>%@</descripcion>",promo.promoDescription];
				[s appendFormat:@"<plazo>%@</plazo>",promo.promoInstallmentSelected];
				[s appendFormat:@"<planId>%@</planId>",promo.planId];
				[s appendFormat:@"<baseAmount>%@</baseAmount>",promo.promoBaseAmount];
				[s appendString:@"</promocion>"];
			}
			
			[s appendString:@"</promociones>"];
		}
        if ([par isKindOfClass:[MesaDeRegalo class]])
		{	MesaDeRegalo *mesa=(MesaDeRegalo*) par;
			[s appendString:@"<mesaRegalo>"];
			[s appendFormat:@"<fatherName>%@</fatherName>",mesa.fatherName];
			[s appendFormat:@"<momName>%@</momName>",mesa.momName];
			[s appendFormat:@"<nameR>%@</nameR>",mesa.nameR];
			[s appendString:@"</mesaRegalo>"];
		}
        
        if ([par isKindOfClass:[RefundData class]])
		{	RefundData *refund=(RefundData*) par;
			[s appendString:@"<datosDevolucion>"];
			[s appendFormat:@"<originalDate>%@</originalDate>",refund.saleDate];
            [s appendFormat:@"<originalTerminal>%@</originalTerminal>",refund.originalTerminal];
			[s appendFormat:@"<originalStoreNumber>%@</originalStoreNumber>",refund.originalStore];
			[s appendFormat:@"<originalTicketNumber>%@</originalTicketNumber>",refund.originalDocto];
            [s appendFormat:@"<originalEmployee>%@</originalEmployee>",refund.originalSeller];
            [s appendFormat:@"<refundCauseNumber>%@</refundCauseNumber>",refund.refundCauseNumber];
			[s appendFormat:@"<refundType>%@</refundType>",refund.refundReason]; //<<<<<<<<<
			[s appendString:@"</datosDevolucion>"];
		}

        if ([par isKindOfClass:[WithdrawDataList class]])
		{	WithdrawDataList *drawList=(WithdrawDataList*) par;
            DLog(@"entrando retiros al wsdl");

			for (WithdrawData *data in [drawList withdrawList]) {
                [s appendString:@"<retiros>"];
                [s appendFormat:@"<cantidad>%@</cantidad>",data.quantity];
                [s appendFormat:@"<denominacion>%@</denominacion>",data.amount];
                DLog(@"agregando retiros al wsdl");
                [s appendString:@"</retiros>"];


            }
			
		}
        
        if ([par isKindOfClass:[CardDataList class]])
		{	CardDataList *cardList=(CardDataList*) par;
            DLog(@"entrando lista Eglobal list wsdl");
            
			for (Card *cardData in [cardList getCardList]) {
                [s appendString:@"<eglobals>"];
                [s appendFormat:@"<noTarjeta>%@</noTarjeta>",cardData.cardNumber];
                [s appendFormat:@"<tipoTarjeta>%@</tipoTarjeta>",cardData.cardType];
                [s appendFormat:@"<track1>%@</track1>",cardData.track1];
                [s appendFormat:@"<track2>%@</track2>",cardData.track2];
                [s appendFormat:@"<track3>%@</track3>",cardData.track3];
                [s appendFormat:@"<ds>%@</ds>",cardData.authCode];
                [s appendFormat:@"<expiracion>%@</expiracion>",cardData.expireDate];
                [s appendFormat:@"<monedero>%@</monedero>",cardData.monederoNumber];
                [s appendFormat:@"<plan>%@</plan>",cardData.planId];
                [s appendFormat:@"<plazo>%@</plazo>",cardData.planInstallment];
                [s appendFormat:@"<planDescripcion>%@</planDescripcion>",cardData.planDescription];
                [s appendFormat:@"<monto>%@</monto>",cardData.amountToPay];
                
                [s appendString:@"</eglobals>"];            }
			
		}

	}

	return s;
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
