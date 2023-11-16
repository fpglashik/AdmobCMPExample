//
//  ConsentManager.h
//  AdmobCMPExample
//
//  Created by mac 2019 on 11/16/23.
//

#import <Foundation/Foundation.h>

typedef enum {
    notGathered = 1,
    isBeingGathered,
    hasBeenGathered,
    
    requestingError,
    presentingError,
    codingError
} Status;

@interface ConsentManager : NSObject
{
    void (^_completionHandler)(Status consentStatus);
}
+ shared;

- (void) gatherConsentInfo:(void(^)(Status))handler;

@property Status _consentStatus;
@end



