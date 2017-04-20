//
//  productDescriptionCell.h
//  POSSystem-ios
//
//  Created by Hemant Saini on 17/04/17.
//  Copyright © 2017 Hemant Saini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDescriptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end
