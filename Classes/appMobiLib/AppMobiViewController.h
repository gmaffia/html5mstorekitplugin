#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class AppMobiWebView;

@interface AppMobiViewController : UIViewController {
    AppMobiWebView *webView;
}

+ (AppMobiViewController*)masterViewController;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation; 
- (AppMobiWebView *)getWebView;

@end
