
#import "RubyNativeSingleton.h"


@implementation RubyNativeSingleton



-(void) test1:(id<IMethodResult>)methodResult {
    [methodResult setResult:@"result 1"];
}

-(void) test2:(id<IMethodResult>)methodResult {
    [methodResult setResult:@"result 2"];
}

-(void) test3:(id<IMethodResult>)methodResult {
    [methodResult setResult:@"result 3"];
}




@end
