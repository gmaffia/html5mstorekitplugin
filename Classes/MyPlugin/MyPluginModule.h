
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppMobiModule.h"

@interface MyPluginModule : AppMobiModule {
	
}

- (void)setup:(AppMobiWebView*) webView;
- (void)initialize:(AppMobiWebView*) webView;

@end
