#import <StoreKit/StoreKit.h>
#import "AppMobiCommand.h"

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : AppMobiCommand

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;
- (void)restoreCompletedTransactions;
- (void)setWebView:(AppMobiWebView *)myWebView;

@end