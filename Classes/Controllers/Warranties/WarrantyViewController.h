//
//  WarrantyViewController.h
//  CardReader
//
//  Created by Arturo Jaime Guerrero on 15/10/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WARRANTYSELECTED_NOTIFICATION @"setSelectedWarranty"

@interface WarrantyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *warrantiesTableView;
@property (retain, nonatomic) IBOutlet UIButton *registerButton;
@property (retain, nonatomic) NSMutableArray *warrantiesList;
@property (retain, nonatomic) NSString *productName;
@end
