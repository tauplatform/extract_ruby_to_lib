
#import "IRubyNative.h"
#import "RubyNativeSingletonBase.h"

@interface RubyNativeSingleton : RubyNativeSingletonBase<IRubyNativeSingleton> {
}



-(void) test1:(id<IMethodResult>)methodResult;
-(void) test2:(id<IMethodResult>)methodResult;
-(void) test3:(id<IMethodResult>)methodResult;




@end