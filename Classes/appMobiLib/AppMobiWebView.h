
#import <UIKit/UIKit.h>

@class InvokedCommand;
@class AppMobiCommand;

@interface AppMobiWebView : UIWebView<UIWebViewDelegate>
{
	NSMutableDictionary *commandObjects;
	id<UIWebViewDelegate> userDelegate;
}

- (NSString *)appDirectory;
- (NSString *)baseDirectory;
- (void)injectJS:(NSString *)js;

- (id) getCommandInstance:(NSString*)className;
- (BOOL) execute:(InvokedCommand*)command;
- (void) registerCommand:(AppMobiCommand*)command forName:(NSString*)name;

@end
