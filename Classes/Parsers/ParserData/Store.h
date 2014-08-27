//
//  Store.h
//  TableSearch
//
//  Created by Martha Patricia Sagahon Azua on 03/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Store : NSObject {

	NSString* number;
	NSString* name;
	NSString* description;
	
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *description;
+ (id)productWithType:(NSString *)number name:(NSString *)name description:(NSString*)description;
@end
