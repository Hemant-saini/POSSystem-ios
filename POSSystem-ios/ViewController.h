//
//  ViewController.h
//  POSSystem-ios
//
//  Created by Hemant Saini on 14/04/17.
//  Copyright © 2017 Hemant Saini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UITextField *txtGenerateQRCode;

@property (nonatomic, weak) IBOutlet UIView *qrImageScanView;
@property (nonatomic, weak) IBOutlet UILabel *qrCodeCopyLabel;
@property (nonatomic, weak) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UITextField *rendomNumberText;
@property (weak, nonatomic) IBOutlet UITableView *menuTabel;
@property (weak, nonatomic) IBOutlet UITableView *productTabel;
@property (weak, nonatomic) IBOutlet UITextField *generateLocationText;
@property (weak, nonatomic) IBOutlet UIButton *locationCaptureButton;

//btn,tbl,txtv,txt,vw,scr,img

- (IBAction)startScanningButton:(id)sender;
- (IBAction)generateBarCodeButton:(id)sender;
- (IBAction)locationSaveButton:(id)sender;
- (IBAction)btnLocation:(id)sender;
- (IBAction)btnCheckIN:(id)sender;
- (IBAction)btnRedeein:(id)sender;



@end

