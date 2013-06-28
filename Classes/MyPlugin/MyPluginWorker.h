
#import <Foundation/Foundation.h>
#import "MyPluginCommand.h"

@interface MyPluginWorker : MyPluginCommand {
}

- (void)restorePurchasesWork:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)buyProductWork:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
