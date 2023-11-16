//
//  ViewController.h
//  AdmobCMPExample
//
//  Created by mac 2019 on 11/16/23.
//

#import <UIKit/UIKit.h>
#import "ConsentManager.h"
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (void)onConsentGathered:(Status) consentStatus;
@end

