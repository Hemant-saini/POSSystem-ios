//
//  ViewController.m
//  POSSystem-ios
//
//  Created by Hemant Saini on 14/04/17.
//  Copyright © 2017 Hemant Saini. All rights reserved.
//


#import "ViewController.h"
#import "MenuItemsCell.h"
#import "productDescriptionCell.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVCaptureMetadataOutputObjectsDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isLocationBarcodeScanned;

@end

@implementation ViewController{
    NSArray * arrMenu;
    NSMutableArray * arrProduct;
    BOOL *buttonToggled;
}

@synthesize description;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *img = [UIImage imageNamed:@"imgPunchh"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [imgView setImage:img];
    // setContent mode aspect fit
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;

    arrMenu = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Pizza",@"name",@"$5.99",@"rate",@"5%",@"tax",@"1",@"id",nil],
               [NSDictionary dictionaryWithObjectsAndKeys:@"Burgar",@"name",@"$6.99",@"rate",@"6%",@"tax",@"2",@"id",nil],
               [NSDictionary dictionaryWithObjectsAndKeys:@"Sandwich",@"name",@"$7.99",@"rate",@"7%",@"tax",@"3",@"id",nil],
               [NSDictionary dictionaryWithObjectsAndKeys:@"Brown Rice",@"name",@"$8.99",@"rate",@"8%",@"tax",@"4",@"id",nil],
               [NSDictionary dictionaryWithObjectsAndKeys:@"Shake",@"name",@"$9.99",@"rate",@"9%",@"tax",@"5",@"id",nil],
               [NSDictionary dictionaryWithObjectsAndKeys:@"Ice Cream",@"name",@"$10.99",@"rate",@"10%",@"tax",@"6",@"id",nil],
               nil];
    
    arrProduct= [NSMutableArray array];
   
    self.txtGenerateQRCode.userInteractionEnabled = YES;
    self.txtGenerateQRCode.text = @"";
    self.generateLocationText.text =@"";
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _productTabel) {
       return [arrProduct count];
    } else {
        return  [arrMenu count];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _menuTabel) {
        static NSString *simpleTableIdentifier = @"MenuItemCell";
        
        MenuItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        if (cell == nil) {
            cell = [[MenuItemsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[[arrMenu objectAtIndex:indexPath.row] valueForKey:@"name"],[[arrMenu objectAtIndex:indexPath.row] valueForKey:@"rate"]];
        
        return cell;
        
    } else {
        static NSString *simpleTableIdentifier = @"ProductDescriptionCell";
        ProductDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        if (cell == nil) {
            cell = [[ProductDescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ %@",[[arrProduct objectAtIndex:indexPath.row] valueForKey:@"name"],[[arrProduct objectAtIndex:indexPath.row] valueForKey:@"rate"]];
        cell.subTotalLabel.text = [NSString stringWithFormat:@"%@",[[arrProduct objectAtIndex:indexPath.row] valueForKey:@"total"]];
        cell.taxLabel.text = [NSString stringWithFormat:@"%@",[[arrProduct objectAtIndex:indexPath.row] valueForKey:@"tax"]];
        cell.totalLabel.text = [NSString stringWithFormat:@"%@",[[arrProduct objectAtIndex:indexPath.row] valueForKey:@"totalAfterTax"]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _menuTabel) {
            for (int i =0; i<arrProduct.count; i++) {
                if ([[[arrProduct objectAtIndex:i] valueForKey:@"id"] isEqualToString:[[arrMenu objectAtIndex:indexPath.row] valueForKey:@"id"]]) {
                    NSInteger productQauntity = [[[arrProduct objectAtIndex:i] valueForKey:@"quantity"] integerValue];
                    id objectAtSelectedIndex = [arrMenu objectAtIndex:indexPath.row];
                    productQauntity+=1;
                    NSInteger total = [[[objectAtSelectedIndex valueForKey:@"rate"] stringByReplacingOccurrencesOfString:@"$" withString:@""] integerValue] * productQauntity;
                    NSInteger totalAfterTax =  ([[[objectAtSelectedIndex valueForKey:@"rate"] stringByReplacingOccurrencesOfString:@"$" withString:@""] integerValue] * total) / 100 + total;
                    [arrProduct removeObjectAtIndex:i];
                    [arrProduct insertObject:[NSDictionary dictionaryWithObjectsAndKeys:[objectAtSelectedIndex valueForKey:@"name"],@"name",[objectAtSelectedIndex valueForKey:@"rate"],@"rate",[objectAtSelectedIndex valueForKey:@"tax"],@"tax",[ NSNumber numberWithInteger: total],@"total",[NSNumber numberWithInteger:totalAfterTax],@"totalAfterTax",[objectAtSelectedIndex valueForKey:@"id"],@"id",[NSNumber numberWithInteger:productQauntity],@"quantity", nil] atIndex:i];
                    break;
                    //  [arrProduct addObject:[NSDictionary dictionaryWithObjectsAndKeys:<#(nonnull id), ...#>, nil]]
                } else {
                    NSInteger productQauntity = 1;
                    id objectAtSelectedIndex = [arrMenu objectAtIndex:indexPath.row];
                    NSInteger total = [[[objectAtSelectedIndex valueForKey:@"rate"] stringByReplacingOccurrencesOfString:@"$" withString:@""] integerValue] * productQauntity;
                    NSInteger totalAfterTax =  ([[[objectAtSelectedIndex valueForKey:@"rate"] stringByReplacingOccurrencesOfString:@"$" withString:@""] integerValue] * total) / 100 + total;
                    [arrProduct addObject:[NSDictionary dictionaryWithObjectsAndKeys:[objectAtSelectedIndex valueForKey:@"name"],@"name",[objectAtSelectedIndex valueForKey:@"rate"],@"rate",[objectAtSelectedIndex valueForKey:@"tax"],@"tax",[ NSNumber numberWithInteger: total],@"total",[NSNumber numberWithInteger:totalAfterTax],@"totalAfterTax",[objectAtSelectedIndex valueForKey:@"id"],@"id",[NSNumber numberWithInteger:productQauntity],@"quantity", nil]];
                    
                }
        
    }
        if (!(arrProduct.count > 0)) {
            NSInteger productQauntity = 1;
            id objectAtSelectedIndex = [arrMenu objectAtIndex:indexPath.row];
            NSInteger total = [[[objectAtSelectedIndex valueForKey:@"rate"] stringByReplacingOccurrencesOfString:@"$" withString:@""] integerValue] * productQauntity;
            NSInteger totalAfterTax =  ([[[objectAtSelectedIndex valueForKey:@"rate"] stringByReplacingOccurrencesOfString:@"$" withString:@""] integerValue] * total) / 100 + total;
            [arrProduct addObject:[NSDictionary dictionaryWithObjectsAndKeys:[objectAtSelectedIndex valueForKey:@"name"],@"name",[objectAtSelectedIndex valueForKey:@"rate"],@"rate",[objectAtSelectedIndex valueForKey:@"tax"],@"tax",[ NSNumber numberWithInteger: total],@"total",[NSNumber numberWithInteger:totalAfterTax],@"totalAfterTax",[objectAtSelectedIndex valueForKey:@"id"],@"id",[NSNumber numberWithInteger:productQauntity],@"quantity", nil]];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [_productTabel reloadData];

       // }
    }
}


#pragma mark - Camera scanning
- (IBAction)startScanningButton:(id)sender {
    self.isReading ? [self stopReading] : [self startReading];
    self.isReading = !self.isReading;
    if ([(UIButton *)sender tag]== 100) {
        _isLocationBarcodeScanned = true;
    } else {
        _isLocationBarcodeScanned = false;
    }
}

#pragma mark - Random Bar code generate
- (IBAction)generateBarCodeButton:(id)sender {
    long randomNumber = arc4random() % 9000000000000 + 1000000000000;
    NSLog(@"random num====%ld",randomNumber);
    self.rendomNumberText.text = [NSString stringWithFormat:@"%ld",randomNumber];
}

- (long)getRandomNumberBetween:(long)from to:(long)to {
    
   return ((long)rand() / RAND_MAX * 9999999999999);
}

#pragma mark - change Button Text
- (IBAction)locationSaveButton:(id)sender {
    if (!buttonToggled) {
        [sender setTitle:@"SAVE" forState:UIControlStateNormal];
        buttonToggled = true;
    }
    else {
        [sender setTitle:@"UPDATE" forState:UIControlStateNormal];
        buttonToggled = false;
    }
    NSString *valueToSave = _generateLocationText.text;
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"preferenceName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"preferenceName"];
}

- (IBAction)btnLocation:(id)sender {
}

- (IBAction)btnCheckIN:(id)sender {
}

- (IBAction)btnRedeein:(id)sender {
}
- (BOOL)startReading {
    NSError *error;
    [self qrCodeCopyLabel];
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetadataOutput];
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    NSArray *scannableCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                                    AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                                    AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeQRCode];
    [captureMetadataOutput setMetadataObjectTypes:scannableCodeTypes];    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.qrImageScanView.layer.bounds];
    [self.qrImageScanView.layer addSublayer:self.videoPreviewLayer];
    [self.captureSession startRunning];
    return YES;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSArray *meta = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                                        AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                                        AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeQRCode];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@", [metadataObj stringValue]);
                if (self.isLocationBarcodeScanned) {
                    [self.generateLocationText setText:[metadataObj stringValue]];
                    [self stopReading];
                    self.isReading = NO;
                } else {
                [self.txtGenerateQRCode setText:[metadataObj stringValue]];
                [self stopReading];
                self.isReading = NO;
                }
            });
     //   }
    }
}

- (void)stopReading {
    [self.captureSession stopRunning];
    self.captureSession = nil;
    [self.videoPreviewLayer removeFromSuperlayer];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        self.view.frame = f;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}






@end
