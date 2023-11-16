//
//  ConsentManager.m
//  AdmobCMPExample
//
//  Created by mac 2019 on 11/16/23.
//

#import "ConsentManager.h"
#include <UserMessagingPlatform/UserMessagingPlatform.h>

@implementation ConsentManager

static ConsentManager *singletonObject = nil;

+ (id) shared
{
    if (! singletonObject) {

        singletonObject = [[ConsentManager alloc] init];
        singletonObject._consentStatus = 1;
    }
    return singletonObject;
}

- (id)init
{
    if (! singletonObject) {

        singletonObject = [super init];
        // Uncomment the following line to see how many times is the init method of the class is called
        // NSLog(@"%s", __PRETTY_FUNCTION__);
    }
    return singletonObject;
}

-(void)gatherConsentInfo:(void(^)(Status))handler{
    
    self->_completionHandler = [handler copy];
    
    if (self._consentStatus == isBeingGathered || self._consentStatus == hasBeenGathered) {
        self->_completionHandler(self._consentStatus);
        return;
    }
    
    self._consentStatus = isBeingGathered;
    
    // Check if you can initialize the Google Mobile Ads SDK in parallel
    // while checking for new consent information. Consent obtained in
    // the previous session can be used to request ads.
    if (UMPConsentInformation.sharedInstance.canRequestAds) {
        self._consentStatus = hasBeenGathered;
        self->_completionHandler(self._consentStatus);
        return;
    }
    
//    UIViewController *controller = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        
    // Create a UMPRequestParameters object.
    UMPRequestParameters *parameters = [[UMPRequestParameters alloc] init];
    // Set tag for under age of consent. NO means users are not under age
    // of consent.
    parameters.tagForUnderAgeOfConsent = NO;

    __weak __typeof__(self) weakSelf = self;
    // Request an update for the consent information.
    [UMPConsentInformation.sharedInstance requestConsentInfoUpdateWithParameters:parameters completionHandler:^(NSError *_Nullable requestConsentError) {
        
        if (requestConsentError) {
            // Consent gathering failed.
            NSLog(@"Error: %@", requestConsentError.localizedDescription);
            self._consentStatus = requestingError;
            self->_completionHandler(self._consentStatus);
            return;
        }
        
        __strong __typeof__(self) strongSelf = weakSelf;
        if (!strongSelf) {
            self._consentStatus = codingError;
            self->_completionHandler(self._consentStatus);
            return;
        }

        [UMPConsentForm loadAndPresentIfRequiredFromViewController:controller completionHandler:^(NSError *loadAndPresentError) {
          
            if (loadAndPresentError) {
                // Consent gathering failed.
                NSLog(@"Error: %@", loadAndPresentError.localizedDescription);
                self._consentStatus = presentingError;
                self->_completionHandler(self._consentStatus);
                return;
            }
            __strong __typeof__(self) strongSelf = weakSelf;
            if (!strongSelf) {
              self._consentStatus = codingError;
              self->_completionHandler(self._consentStatus);
              return;
            }

            // Consent has been gathered.
            self._consentStatus = hasBeenGathered;
            self->_completionHandler(self._consentStatus);
          
        }];
    }];
}

@end
