//
//  ViewController.m
//  AdmobCMPExample
//
//  Created by mac 2019 on 11/16/23.
//

#import "ViewController.h"
#import "ConsentManager.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)onInitPressed:(UIButton *)sender {
    printf("%s\n", [@"init pressed" UTF8String]);
    [self gatherConsent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) gatherConsent{
    [[ConsentManager shared] gatherConsentInfo:^(Status consentStatus){
        [self onConsentGathered:consentStatus];
    }];
}

- (void)onConsentGathered:(Status)consentStatus {
    printf("Received consent status  %d\n", consentStatus);
    
    for (int i = 0; i < 5; i++) {
        if (i == (int)consentStatus) {
            break;
        }
    }
    
    switch (consentStatus) {
        case notGathered:
            self.statusLabel.text = @"Consent Not Gathered"; break;
        case isBeingGathered:
            self.statusLabel.text = @"Consent Is Being Gathered"; break;
        case hasBeenGathered:
            self.statusLabel.text = @"Consent Has Been Gathered"; break;
        case requestingError:
            self.statusLabel.text = @"Error While Requesting Consent"; break;
        case presentingError:
            self.statusLabel.text = @"Error While Presenting Consent Dialogue"; break;
        case codingError:
            self.statusLabel.text = @"Internal Error"; break;
        default:
            self.statusLabel.text = @""; break;
    }
    
    if (consentStatus != hasBeenGathered){
        NSTimeInterval delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self gatherConsent];
        });
    }
}
@end
