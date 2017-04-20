//
//  Product.h
//  POSSystem-ios
//
//  Created by Hemant Saini on 14/04/17.
//  Copyright © 2017 Hemant Saini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Product : JSONModel
@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSNumber *price;
@end
