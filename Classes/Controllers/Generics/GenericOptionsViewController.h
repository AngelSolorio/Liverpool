//
//  GenericOptionsViewController.h
//  CardReader
//
//  Created by Jonathan Esquer on 10/01/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GenericOptionDelegate <NSObject>
-(void) performOptionAction:(int) index :(NSString*) value ;

@end

@interface GenericOptionsViewController : UIViewController <UITableViewDataSource,
UITableViewDelegate>
{
    NSArray *optionsArray;
    id <GenericOptionDelegate> delegate;
    
}

@property (nonatomic,retain)    NSArray *optionsArray;
@property (nonatomic,retain)	id <GenericOptionDelegate> delegate;

@end
