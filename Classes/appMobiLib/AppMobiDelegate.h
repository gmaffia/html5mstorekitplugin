#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UINavigationController.h>
#import "JSON.h"

@class AppMobiWebView;
@class AppMobiViewController;

@interface AppMobiDelegate : NSObject < UIApplicationDelegate, UINavigationControllerDelegate>
{
	UIWindow *window;
	AppMobiWebView *webView;
	AppMobiViewController *viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) AppMobiViewController *viewController;

+ (AppMobiDelegate*) sharedDelegate;
+ (NSString*) rootDirectory;

@end
