#import "IAPHelper.h"
#import "AppMobiWebView.h"
#import "AppMobiViewController.h"
#import <StoreKit/StoreKit.h>

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPHelper {
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    
    NSSet * _productIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;

        // Add self as transaction observer
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        NSLog(@"Finished Adding myself as a transaction observer...");
        
    }
    return self;
    
}

- (void)setWebView:(AppMobiWebView *)myWebView {
    webView = myWebView;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}

#pragma mark SKPaymentTransactionOBserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"Restoring transactions..");
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction]; 
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    NSString *js = [NSString stringWithFormat:@"var e = document.createEvent('Events');e.initEvent('myplugin.workbuyproductsuccess',true,true);e.productIdentifier = '%@';document.dispatchEvent(e);", transaction.originalTransaction.payment.productIdentifier];
    NSLog(@"%@",js);    
    [webView injectJS:js];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    NSString *js = [NSString stringWithFormat:@"purchases.push('%@');", transaction.originalTransaction.payment.productIdentifier];
    NSLog(@"%@",js);
    [webView injectJS:js];    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    js = [NSString stringWithFormat:@"var e = document.createEvent('Events');e.initEvent('myplugin.workrestorepurchases',true,true);document.dispatchEvent(e);"];
    NSLog(@"%@",js);
    [webView injectJS:js];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
        NSString *js = [NSString stringWithFormat:@"var e = document.createEvent('Events');e.initEvent('myplugin.workbuyproductfail',true,true);document.dispatchEvent(e);"];
        NSLog(@"%@",js);
        [webView injectJS:js];
    }
        
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"Restore Purchase has failed...");
    NSString * js = [NSString stringWithFormat:@"var e = document.createEvent('Events');e.initEvent('myplugin.workrestorepurchases',true,true);document.dispatchEvent(e);"];
    NSLog(@"%@",js);
    [webView injectJS:js];
}

@end
