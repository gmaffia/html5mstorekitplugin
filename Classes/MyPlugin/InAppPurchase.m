#import "InAppPurchase.h"

@implementation InAppPurchase

+ (InAppPurchase *)sharedInstance {
    static dispatch_once_t once;
    static InAppPurchase * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"SamplePurchaseIdA",
                                      @"SamplePurchaseIdB",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end