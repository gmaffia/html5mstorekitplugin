
#import "MyPluginWorker.h"
#import "AppMobiWebView.h"
#import "AppMobiViewController.h"
#import "InAppPurchase.h"
#import <StoreKit/StoreKit.h>

@implementation MyPluginWorker

- (void)restorePurchasesWork:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    InAppPurchase * inApp = [InAppPurchase sharedInstance];
    [inApp setWebView:webView];
    
    [inApp requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            
            [inApp restoreCompletedTransactions];

        }
    }];

    
	
}


- (void)buyProductWork:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    
    InAppPurchase * inApp = [InAppPurchase sharedInstance];
    [inApp setWebView:webView];
	NSString *productIdentifier = (NSString *)[arguments objectAtIndex:0];
    NSLog(@"Requested to buy %@...", productIdentifier);
    [inApp requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            for (SKProduct * product in products) {
                NSLog(@"I wanna buy %@ but instead I have %@", productIdentifier, product.productIdentifier);
                if([productIdentifier isEqualToString:product.productIdentifier]) {
                    NSLog(@"Found product to buy %@...", product.productIdentifier);
                    [[InAppPurchase sharedInstance] buyProduct:product];
                }
            }
        }
    }];
    
	// Maybe you want to fire an event to the web view when it's done	
	NSString *js = [NSString stringWithFormat:@"var e = document.createEvent('Events');e.initEvent('myplugin.workbuyproduct',true,true);document.dispatchEvent(e);"];
	NSLog(@"%@",js);
	[webView injectJS:js];
}

@end