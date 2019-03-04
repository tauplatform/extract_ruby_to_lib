
#import "IRubyNative.h"
#import "RubyNativeFactoryBase.h"

static RubyNativeFactoryBase* ourRubyNativeFactory = nil;

@implementation RubyNativeFactorySingleton

+(id<IRubyNativeFactory>) getRubyNativeFactoryInstance {
    if (ourRubyNativeFactory == nil) {
        ourRubyNativeFactory = [[RubyNativeFactoryBase alloc] init];
    }
    return ourRubyNativeFactory;
}

@end