//
//  PbNavigationController.h
//  CardReader
//
//  Created by Arturo Jaime Guerrero on 29/10/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PbNavigationController : UINavigationController <UINavigationControllerDelegate>
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                completion:(void (^)(void))completion;
@end

