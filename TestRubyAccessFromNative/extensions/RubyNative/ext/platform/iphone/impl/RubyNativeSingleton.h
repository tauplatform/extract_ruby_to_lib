
#import "IRubyNative.h"
#import "RubyNativeSingletonBase.h"

@interface RubyNativeSingleton : RubyNativeSingletonBase<IRubyNativeSingleton> {
}


-(NSString*)getInitialDefaultID;


-(void) enumerate:(id<IMethodResult>)methodResult;




@end