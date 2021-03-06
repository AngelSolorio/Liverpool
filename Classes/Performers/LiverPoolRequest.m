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
#import "NSString+XML.h"
#import "SomsListParser.h"
#import "Contact.h"

@implementation LiverPoolRequest
@synthesize receivedData,requestType,delegate;

+(LiverPoolRequest *)sharedInstance
{
    static LiverPoolRequest *sharedInstance=nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
        NSLog(@"Alloc");
        
    });
    return sharedInstance;
}

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
	//NSMutableString* s = [NSMutableString string];
	//[s appendString: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
	//[s appendString: @"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:tns=\"http://us.liverpool.mx/\">"];
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

	//[s appendString: @"<soap:Body>"];
	//[s appendFormat:@"<tns:%@>",method];
	//[s appendString:[self buildParameterBody:params]];
	//[s appendFormat:@"</tns:%@>",method];
	//[s appendString: @"</soap:Body>"];
	//[s appendString: @"</soap:Envelope>"];
    NSLog(@"Method name %@",method);
    NSString *xmlConstructor = [[NSBundle mainBundle] pathForResource:@"xmlConstructor" ofType:@"xml"];
    NSString *xmlContent = [[NSMutableString alloc] initWithContentsOfFile:xmlConstructor encoding:NSUTF8StringEncoding error:nil];
    xmlContent = [xmlContent stringByReplacingOccurrencesOfString:@"#body#" withString:[self buildParameterBody:params]];
    xmlContent = [xmlContent stringByReplacingOccurrencesOfString:@"#request_name#" withString:method];
    xmlContent = [xmlContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    xmlContent = [xmlContent stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSLog(@"Xml content %@",xmlContent);
	return xmlContent;
}
-(NSString *)createXMLForWarranty:(FindItemModel *)fim{
    NSString *warrantyPath = [[NSBundle mainBundle] pathForResource:@"warrantyBodyRequest" ofType:@"xml"];
    NSString *warrantyContent = [[NSString alloc] initWithContentsOfFile:warrantyPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Fim warranty %@",fim.warranty);
    if (fim.warranty == NULL) {
        warrantyContent = NULL;
        NSLog(@"Warranty is null");
    } else{
        warrantyContent = [warrantyContent stringByReplacingXMLOcurrencesOfString:@"#warranty_id#" withValidString:fim.warranty.warrantyId];
        warrantyContent = [warrantyContent stringByReplacingXMLOcurrencesOfString:@"#cost#" withValidString:fim.warranty.cost];
        warrantyContent = [warrantyContent stringByReplacingXMLOcurrencesOfString:@"#detail#" withValidString:fim.warranty.detail];
        warrantyContent = [warrantyContent stringByReplacingXMLOcurrencesOfString:@"#percentage#" withValidString:fim.warranty.percentage];
        warrantyContent = [warrantyContent stringByReplacingXMLOcurrencesOfString:@"#sku#" withValidString:fim.warranty.sku];
    }
    NSLog(@"Warranty content %@",warrantyContent);
    return warrantyContent;
}
/* build the methods and parameters of the specified method*/
-(NSString*) buildParameterBody:(NSArray*)parameters
{
    NSMutableString *xmlFormat=[NSMutableString string];
	NSArray *params= [self buildParameterNodes];
    NSLog(@"Params %@",parameters);
	for (NSObject* par in parameters) {
		if ([par isKindOfClass:[NSArray class]]){
			if ([((NSArray*)par) count]>0 ) {
				NSObject* obj=[((NSArray*)par) objectAtIndex:0];
                
                
                for(id item in (NSArray *)par){
                    if ([item isKindOfClass:[FindItemModel class]]) {
                        FindItemModel *itemF = item;
                        NSLog(@"Read item model");
                            NSMutableString *itemBody = [[[NSMutableString alloc] init] autorelease];
                            NSString *itemFindPath = [[NSBundle mainBundle] pathForResource:@"itemBodyFindRequest" ofType:@"xml"];
                            NSString *itemFindContent = [[NSString alloc] initWithContentsOfFile:itemFindPath encoding:NSUTF8StringEncoding error:nil];
                            itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#product_id#" withValidString:itemF.barCode];
                            itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#category#" withValidString:itemF.department];
                            itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#price#" withValidString:itemF.price];
                            itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#description#" withValidString:[itemF getXMLdescription]];
                            itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#line_type#" withValidString:itemF.lineType];
                            itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#promotion#" withValidString:itemF.promo?@"true":@"false"];
                            itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#gift#" withValidString:itemF.itemForGift?@"true":@"false"];
                            itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#quantity#" withValidString:itemF.itemCount];
                            itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#extended_price#" withValidString:itemF.priceExtended];
                            itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#delivery_date#" withValidString:itemF.deliveryDate];
                            itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#warranty_flag#" withValidString:@"false"];
                            itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#free#" withValidString:itemF.isFree ? @"true" : @"false"];
                            NSLog(@"Find item content %@",itemFindContent);
                            [itemBody appendString:itemFindContent];
                            
                            for (Promotions *promo in itemF.discounts) {
                                NSString *promotionsPath = [[NSBundle mainBundle] pathForResource:@"itemPromotionsRequest" ofType:@"xml"];
                                NSString *promotionsContent = [[NSString alloc] initWithContentsOfFile:promotionsPath encoding:NSUTF8StringEncoding error:nil];
                                NSLog(@"Promo type %@",promo.promoTypeBenefit);
                                promotionsContent = [promotionsContent stringByReplacingXMLOcurrencesOfString:@"#type#" withValidString:promo.promoTypeBenefit];
                                promotionsContent = [promotionsContent stringByReplacingXMLOcurrencesOfString:@"#percentage#" withValidString:promo.promoDiscountPercent];
                                promotionsContent = [promotionsContent stringByReplacingXMLOcurrencesOfString:@"#description#" withValidString:promo.promoDescription];
                                promotionsContent = [promotionsContent stringByReplacingXMLOcurrencesOfString:@"#term#" withValidString:promo.promoInstallmentSelected];
                                promotionsContent = [promotionsContent stringByReplacingXMLOcurrencesOfString:@"#id_plan#" withValidString:promo.planId];
                                [itemBody appendString:promotionsContent];
                            }
                            NSString *itemBodyPath = [[NSBundle mainBundle] pathForResource:@"itemConstructorFindRequest" ofType:@"xml"];
                            NSString *itemBodyContent = [[NSString alloc] initWithContentsOfFile:itemBodyPath encoding:NSUTF8StringEncoding error:nil];
                            itemBodyContent = [itemBodyContent stringByReplacingXMLOcurrencesOfString:@"#product_body#" withValidString:itemBody];
                            [xmlFormat appendString:itemBodyContent];
                    } else if ([item isKindOfClass:[Warranty class]]){
                        NSLog(@"Read warranty");
                        Warranty *itemW = item;
                        NSMutableString *itemBody = [[[NSMutableString alloc] init] autorelease];
                        NSString *itemFindPath = [[NSBundle mainBundle] pathForResource:@"itemBodyFindRequest" ofType:@"xml"];
                        NSString *itemFindContent = [[NSString alloc] initWithContentsOfFile:itemFindPath encoding:NSUTF8StringEncoding error:nil];
                        itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#product_id#" withValidString:itemW.sku];
                        itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#category#" withValidString:itemW.department];
                        itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#price#" withValidString:itemW.cost];
                        itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#description#" withValidString:itemW.detail];
                        itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#line_type#" withValidString:@""];
                        itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#promotion#" withValidString:@"false"];
                        itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#gift#" withValidString:itemW.warrantyForGift ? @"true" : @"false"];
                        itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#quantity#" withValidString:itemW.quantity];
                        itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#extended_price#" withValidString:[NSString stringWithFormat:@"%f",[itemW.cost floatValue]*[itemW.quantity floatValue]]];
                        itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#delivery_date#" withValidString:@""];
                        itemFindContent = [itemFindContent stringByReplacingXMLOcurrencesOfString:@"#warranty_flag#" withValidString:@"true"];
                        NSLog(@"Find warranty content %@",itemFindContent);
                        [itemBody appendString:itemFindContent];
                        NSString *itemBodyPath = [[NSBundle mainBundle] pathForResource:@"itemConstructorFindRequest" ofType:@"xml"];
                        NSString *itemBodyContent = [[NSString alloc] initWithContentsOfFile:itemBodyPath encoding:NSUTF8StringEncoding error:nil];
                        itemBodyContent = [itemBodyContent stringByReplacingXMLOcurrencesOfString:@"#product_body#" withValidString:itemBody];
                        [xmlFormat appendString:itemBodyContent];
                    }
                }
			}
		}
		if ([par isKindOfClass:[NSString class]] || [par isKindOfClass:[NSNumber class]]) {
            NSLog(@"Read Login Data");
            NSLog(@"Par %@",par);
			int index=[parameters indexOfObjectIdenticalTo:par];
            NSLog(@"Index %i parameter %@",index,[params objectAtIndex:index]);
			[xmlFormat appendFormat:@"<%@>%@</%@>",[params objectAtIndex:index],[parameters objectAtIndex:index],[params objectAtIndex:index]];
            NSLog(@"XML data %@",xmlFormat);
		}
     
		// card space
        if ([par isKindOfClass:[Card class]])
        {   NSLog(@"Read Card");
            Card *cardData=(Card*) par;
            NSString *cardDataPath = [[NSBundle mainBundle] pathForResource:@"cardDataRequest" ofType:@"xml"];
            NSString *cardDataContent = [[NSString alloc] initWithContentsOfFile:cardDataPath encoding:NSUTF8StringEncoding error:NULL];
            cardDataContent = [cardDataContent stringByReplacingXMLOcurrencesOfString:@"#card_number#" withValidString:cardData.cardNumber];
            cardDataContent = [cardDataContent stringByReplacingXMLOcurrencesOfString:@"#card_type#" withValidString:cardData.cardType];
            cardDataContent = [cardDataContent stringByReplacingXMLOcurrencesOfString:@"#track1#" withValidString:cardData.track1];
            cardDataContent = [cardDataContent stringByReplacingXMLOcurrencesOfString:@"#track2#" withValidString:cardData.track2];
            cardDataContent = [cardDataContent stringByReplacingXMLOcurrencesOfString:@"#track3#" withValidString:cardData.track3];
            cardDataContent = [cardDataContent stringByReplacingXMLOcurrencesOfString:@"#ds#" withValidString:cardData.authCode];
            cardDataContent = [cardDataContent stringByReplacingXMLOcurrencesOfString:@"#expiration#" withValidString:cardData.expireDate];
            cardDataContent = [cardDataContent stringByReplacingXMLOcurrencesOfString:@"#wallet#" withValidString:cardData.monederoNumber]; //
            cardDataContent = [cardDataContent stringByReplacingXMLOcurrencesOfString:@"#plan#" withValidString:cardData.planId];
            cardDataContent = [cardDataContent stringByReplacingXMLOcurrencesOfString:@"#term#" withValidString:cardData.planInstallment];
            cardDataContent = [cardDataContent stringByReplacingXMLOcurrencesOfString:@"#plan_description#" withValidString:cardData.planDescription];
            cardDataContent = [cardDataContent stringByReplacingXMLOcurrencesOfString:@"#ammount#" withValidString:cardData.amountToPay];
            [xmlFormat appendString:cardDataContent];
        }
        if ([par isKindOfClass:[Contact class]]) {
            NSLog(@"Read Contact");
            Contact *contact=(Contact *) par;
            NSString *contactDataPath = [[NSBundle mainBundle] pathForResource:@"contactDataRequest" ofType:@"xml"];
            NSString *contactDataContent = [[NSString alloc] initWithContentsOfFile:contactDataPath encoding:NSUTF8StringEncoding error:nil];
            contactDataContent = [contactDataContent stringByReplacingXMLOcurrencesOfString:@"#phone#" withValidString:contact.telephone];
            contactDataContent = [contactDataContent stringByReplacingXMLOcurrencesOfString:@"#birthday#" withValidString:contact.birthday];
            [xmlFormat appendString:contactDataContent];
        }
        //---------
		if ([par isKindOfClass:[Seller class]])
		{   NSLog(@"Read Seller");
            Seller *seller=(Seller*) par;
			NSString *terminal=[Session getTerminal];
            NSString *sellerPath = [[NSBundle mainBundle] pathForResource:@"sellerRequest" ofType:@"xml"];
            NSString *sellerContent = [[NSString alloc] initWithContentsOfFile:sellerPath encoding:NSUTF8StringEncoding error:nil];
            sellerContent = [sellerContent stringByReplacingXMLOcurrencesOfString:@"#user#" withValidString:seller.userName];
            sellerContent = [sellerContent stringByReplacingXMLOcurrencesOfString:@"#password#" withValidString:seller.password];
            sellerContent = [sellerContent stringByReplacingXMLOcurrencesOfString:@"#terminal#" withValidString:terminal];
            sellerContent = [sellerContent stringByReplacingXMLOcurrencesOfString:@"#store#" withValidString:[Session getIdStore]];
            [xmlFormat appendString:sellerContent];
		}
		if ([par isKindOfClass:[PromotionGroup class]])
		{   NSLog(@"Read promotion group");
            PromotionGroup *promoGroup=(PromotionGroup*) par;
            NSMutableString *promotionsBody = [[[NSMutableString alloc] init] autorelease];
            NSString *promotionGroupPath = [[NSBundle mainBundle] pathForResource:@"promotionGroupRequest" ofType:@"xml"];
            NSString *promotionGroupContent = [[NSString alloc] initWithContentsOfFile:promotionGroupPath encoding:NSUTF8StringEncoding error:nil];
            promotionGroupContent = [promotionGroupContent stringByReplacingXMLOcurrencesOfString:@"#selected_group#" withValidString:[NSString stringWithFormat:@"%i",promoGroup.section]];
            [promotionsBody appendString:promotionGroupContent];
			
			for (Promotions *promo in promoGroup.promotionGroupArray) {
                NSLog(@"Read promotions array");
                NSLog(@"%@ %@ %@ %@ %@",promo.promoTypeBenefit,promo.promoDescription,promo.promoInstallmentSelected,promo.planId,promo.promoBaseAmount);
                NSString *promotionPath = [[NSBundle mainBundle] pathForResource:@"promotionBodyRequest" ofType:@"xml"];
                NSString *promotionContent = [[NSString alloc] initWithContentsOfFile:promotionPath encoding:NSUTF8StringEncoding error:nil];
                promotionContent = [promotionContent stringByReplacingXMLOcurrencesOfString:@"#type#" withValidString:promo.promoTypeBenefit];
                promotionContent = [promotionContent stringByReplacingXMLOcurrencesOfString:@"#percentage#" withValidString:promo.promoDiscountPercent];
                promotionContent = [promotionContent stringByReplacingXMLOcurrencesOfString:@"#description#" withValidString:promo.promoDescription];
                promotionContent = [promotionContent stringByReplacingXMLOcurrencesOfString:@"#term#" withValidString:promo.promoInstallmentSelected];
                promotionContent = [promotionContent stringByReplacingXMLOcurrencesOfString:@"#plan_id#" withValidString:promo.planId];
                promotionContent = [promotionContent stringByReplacingXMLOcurrencesOfString:@"#base_ammount#" withValidString:promo.promoBaseAmount];
                [promotionsBody appendString:promotionContent];
			}
            NSString *promotionsBodyPath = [[NSBundle mainBundle] pathForResource:@"promotionsConstructorGroupRequest" ofType:@"xml"];
            NSString *promotionsBodyContent = [[NSString alloc] initWithContentsOfFile:promotionsBodyPath encoding:NSUTF8StringEncoding error:nil];
            promotionsBodyContent = [promotionsBodyContent stringByReplacingXMLOcurrencesOfString:@"#promotions_body#" withValidString:promotionsBody];
            [xmlFormat appendString:promotionsBodyContent];
		}
        if ([par isKindOfClass:[MesaDeRegalo class]])
		{   NSLog(@"Read mesa de regalo");
            MesaDeRegalo *mesa=(MesaDeRegalo*) par;
            NSString *giftTablePath = [[NSBundle mainBundle] pathForResource:@"giftTableRequest" ofType:@"xml"];
            NSString *giftTableContent = [[NSString alloc] initWithContentsOfFile:giftTablePath encoding:NSUTF8StringEncoding error:nil];
            giftTableContent = [giftTableContent stringByReplacingXMLOcurrencesOfString:@"#father_name#" withValidString:mesa.fatherName];
            giftTableContent = [giftTableContent stringByReplacingXMLOcurrencesOfString:@"#mother_name#" withValidString:mesa.momName];
            giftTableContent = [giftTableContent stringByReplacingXMLOcurrencesOfString:@"#r_name#" withValidString:mesa.nameR];
            [xmlFormat appendString:giftTableContent];
		}
        
        if ([par isKindOfClass:[RefundData class]])
		{   NSLog(@"Read refund data");
            RefundData *refund=(RefundData*) par;
            NSString *refundDataPath = [[NSBundle mainBundle] pathForResource:@"refundDataRequest" ofType:@"xml"];
            NSString *refundDataContent = [[NSString alloc] initWithContentsOfFile:refundDataPath encoding:NSUTF8StringEncoding error:nil];
            refundDataContent = [refundDataContent stringByReplacingXMLOcurrencesOfString:@"#original_date#" withValidString:refund.saleDate];
            refundDataContent = [refundDataContent stringByReplacingXMLOcurrencesOfString:@"#original_terminal#" withValidString:refund.originalTerminal];
            refundDataContent = [refundDataContent stringByReplacingXMLOcurrencesOfString:@"#original_store_number#" withValidString:refund.originalStore];
            refundDataContent = [refundDataContent stringByReplacingXMLOcurrencesOfString:@"#original_ticket_number#" withValidString:refund.originalDocto];
            refundDataContent = [refundDataContent stringByReplacingXMLOcurrencesOfString:@"#original_employee#" withValidString:refund.originalSeller];
            refundDataContent = [refundDataContent stringByReplacingXMLOcurrencesOfString:@"#refund_cause_number#" withValidString:refund.refundCauseNumber];
            refundDataContent = [refundDataContent stringByReplacingXMLOcurrencesOfString:@"#refund_type#" withValidString:refund.refundReason];
            [xmlFormat appendString:refundDataContent];
		}

        if ([par isKindOfClass:[WithdrawDataList class]])
		{   NSLog(@"Read Withdraw data list");
            WithdrawDataList *drawList=(WithdrawDataList*) par;
            NSMutableString *withdrawDataListBody = [[[NSMutableString alloc] init] autorelease];

			for (WithdrawData *data in [drawList withdrawList]) {
                NSString *withdrawDataListPath = [[NSBundle mainBundle] pathForResource:@"withdrawDataListRequest" ofType:@"xml"];
                NSString *withdrawDataListContent = [[NSString alloc] initWithContentsOfFile:withdrawDataListPath encoding:NSUTF8StringEncoding error:nil];
                withdrawDataListContent = [withdrawDataListContent stringByReplacingXMLOcurrencesOfString:@"#quantity#" withValidString:data.quantity];
                withdrawDataListContent = [withdrawDataListContent stringByReplacingXMLOcurrencesOfString:@"#designation#" withValidString:data.amount];
                [withdrawDataListBody appendString:withdrawDataListContent];
            }
            [xmlFormat appendString:withdrawDataListBody];
		}
        
        if ([par isKindOfClass:[CardDataList class]])
		{   NSLog(@"Read card data list");
            CardDataList *cardList=(CardDataList*) par;
            NSMutableString *cardDataListBody = [[[NSMutableString alloc] init] autorelease];
            
			for (Card *cardData in [cardList getCardList]) {
                NSString *cardDataListPath = [[NSBundle mainBundle] pathForResource:@"cardDataListRequest" ofType:@"xml"];
                NSString *cardDataListContent = [[NSString alloc] initWithContentsOfFile:cardDataListPath encoding:NSUTF8StringEncoding error:nil];
                cardDataListContent = [cardDataListContent stringByReplacingXMLOcurrencesOfString:@"#card_number#" withValidString:cardData.cardNumber];
                cardDataListContent = [cardDataListContent stringByReplacingXMLOcurrencesOfString:@"#card_type#" withValidString:cardData.cardType];
                cardDataListContent = [cardDataListContent stringByReplacingXMLOcurrencesOfString:@"#track1#" withValidString:cardData.track1];
                cardDataListContent = [cardDataListContent stringByReplacingXMLOcurrencesOfString:@"#track2#" withValidString:cardData.track2];
                cardDataListContent = [cardDataListContent stringByReplacingXMLOcurrencesOfString:@"#track3#" withValidString:cardData.track3];
                cardDataListContent = [cardDataListContent stringByReplacingXMLOcurrencesOfString:@"#ds#" withValidString:cardData.authCode];
                cardDataListContent = [cardDataListContent stringByReplacingXMLOcurrencesOfString:@"#expiration#" withValidString:cardData.expireDate];
                cardDataListContent = [cardDataListContent stringByReplacingXMLOcurrencesOfString:@"#wallet#" withValidString:cardData.monederoNumber];
                cardDataListContent = [cardDataListContent stringByReplacingXMLOcurrencesOfString:@"#plan#" withValidString:cardData.planId];
                cardDataListContent = [cardDataListContent stringByReplacingXMLOcurrencesOfString:@"#term#" withValidString:cardData.planInstallment];
                cardDataListContent = [cardDataListContent stringByReplacingXMLOcurrencesOfString:@"#plan_description#" withValidString:cardData.planDescription];
                cardDataListContent = [cardDataListContent stringByReplacingXMLOcurrencesOfString:@"#ammount#" withValidString:cardData.amountToPay];
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
		NSArray *parameters=[NSArray arrayWithObjects:@"idProducto",@"precio",@"terminal",@"garantiasActivadas",nil];
        NSLog(@"Consult sku");
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
    switch (requestType) {
        case SOMSListRequest:
            NSLog(@"Start soms request");
            [self somsItemsRequestParsing:receivedData];
            break;
            
        default:
            NSLog(@"Default");
            [delegate performResults:receivedData :requestType];
            break;
    }
}

-(void) timerRequestValidation
{
	[self invalidateTimer];
	[Tools stopActivityIndicator];
	[Tools displayAlert:@"Aviso" message:@"Se ha excedido el tiempo de respuesta"];
    
    [delegate performResults:nil :requestType]; //patch 1.4.5

}

-(void)requestDataType:(RequestType)reqType withParameters:(NSDictionary *)params
{
    switch (reqType) {
        case SOMSListRequest:
            [self startSOMSRequest];
            break;
            
        default:
            break;
    }
}
-(void)startSOMSRequest
{
    if ([[Session getSomsOrder] isEqualToString:@""])
        return;
	//*** SOMS request code ***/
    NSString  *somsOrder=[Session getSomsOrder];
    
    //SELLER
    Seller *seller=[[Seller alloc] init];
    seller.password=[Session getPassword];
    seller.userName=[Session getUserName];
    
    //Account employee
	NSString *accountEmployee=[Session getEmployeeAccount];
    
    
	NSArray *params=[NSArray arrayWithObjects:somsOrder,seller,accountEmployee,nil];
	[self sendRequest:@"listaSOMS" forParameters:params forRequestType:SOMSListRequest];
    [seller release];
}

-(void)somsItemsRequestParsing:(NSData*) data
{
    NSNumber *success;
    SomsListParser *somsParser=[[SomsListParser alloc] init];
	[somsParser startParser:data];
	//if the transaction was succesful.
	if ([somsParser getStateOfMessage]) {
		DLog (@"sucess sale payparser */*/*/*");
        success =[NSNumber numberWithBool:YES];
	}
	else
	{
        //[scanDevice removeDelegate:self];
        success = [NSNumber numberWithBool:NO];
		//[Tools displayAlert:@"Error" message:[somsParser getMessageResponse] withDelegate:self];
        NSLog(@"Dismiss tab bar c");
        
	}
    NSLog(@"Soms group %@",somsParser.somsGroup);
    NSDictionary *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithInteger:SOMSListRequest],@"request_type" ,
                                                         [somsParser returnSaleProductList],@"soms_list",
                                                              [somsParser getMessageResponse],@"message",
                                                                      somsParser.somsGroup,@"soms_group",
                                                                                     success, @"success",
                                                                                                    nil];
    [self finishedDataTypeRequest:dicInfo];
}

-(void)finishedDataTypeRequest:(NSDictionary *)params
{
    RequestType reqType = (RequestType)[[params objectForKey:@"request_type"] integerValue];
    switch (reqType) {
        case SOMSListRequest:
            [[NSNotificationCenter defaultCenter] postNotificationName:GETSOMSLIST_NOTIFICATION object:self userInfo:params];
            break;
            
        default:
            break;
    }
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
