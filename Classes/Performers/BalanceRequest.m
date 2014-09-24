//
//  BalanceRequest.m
//  CardReader

#import "BalanceRequest.h"


@implementation BalanceRequest

-(void) sendRequest:(NSString*) requestName forParameters:(NSArray*)parameters forRequestType:(RequestType) reqType
{
	requestType=reqType;
	[self startRequest];
	
	NSString * soapmessage=[self createEnvelope:requestName forParameters:parameters];

	
	
	//http://172.27.203.25:7080/wbi/cicstran // produccion
	//http://172.16.204.79:7080/wbi/cicstran //otro
    //172.27.203.25
	
    NSURL *url=[NSURL URLWithString:@"http://172.16.204.254:7080/wbi/cicstran"];//Web Services desarrollo

    //NSURL *url=[NSURL URLWithString:@"  "];//Web Services produccion
	
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
	[s appendString: @"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:intf=\"http://liverpool.com.mx/schemas/wbi\">"];

	[s appendString: @"<soap:Body>"];

	
	[s appendFormat:@"<intf:%@>",method];
	[s appendString:[self buildParameterBody:params]];
	[s appendFormat:@"</intf:%@>",method];
	[s appendString: @"</soap:Body>"];
	[s appendString: @"</soap:Envelope>"];
	return s;
}
/* build the methods and parameters of the specified method*/
-(NSString*) buildParameterBody:(NSArray*)parameters
{
	NSMutableString *s=[[[NSMutableString alloc] init] autorelease];
	NSArray *params= [self buildParameterNodes];
	int index=0;
	for (NSObject* par in parameters) {
		
		NSLog(@"Parametros %@",par);
		if ([par isKindOfClass:[NSString class]]) {

			[s appendFormat:@"<%@>%@</%@>",[params objectAtIndex:index],[parameters objectAtIndex:index],[params objectAtIndex:index]];
		}
		//TEST delete after
		//parameter called when is airtime request, it doesnt need an array
		index++;
		
	}
	return s;
}

//* returns the parameters names in the request <NAME> </NAME" */
-(NSArray*) buildParameterNodes
{

	if (requestType==bRequest) {
		NSArray *parameters=[NSArray arrayWithObjects:@"intf:IP",@"intf:numeroCuenta",@"intf:pin",@"intf:noValidaPin",nil];
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
	[delegate performResults:nil :requestType];//development only
}

@end
