//
//  CustomCell.h
//  CardReader
//
//  Created by Jonathan Esquer on 04/10/13.
//  Copyright (c) 2013 Gonet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell


@property (assign,nonatomic) IBOutlet UILabel *lblQuantity;
@property (assign,nonatomic) IBOutlet UILabel *lblAmount;
@property (assign,nonatomic) IBOutlet UILabel *lblTotal;
@property (assign, nonatomic) IBOutlet UILabel *lblType;

@end
