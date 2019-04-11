//
//  ViewController.m
//  RhoNativeIOS
//
//  Created by Dmitry Soldatenkov on 03/04/2019.
//  Copyright © 2019 TAU Technologies. All rights reserved.
//

#import "ViewController.h"



//void run_rho_test();


@interface ViewController ()

@end

@implementation ViewController


- (void) run_test_01 {
    
    
    id<IRhoRuby> rr = [RhoRubySingletone getRhoRuby];
    id<IRhoRubyObject>model1 = [rr makeRubyClassObject:@"Model1"];
    id<IRhoRubyObject>result = [rr executeRubyObjectMethod:model1 method_name:@"getAllItems" parameters:nil];

    id<IRhoRubyArray> ar = (id<IRhoRubyArray>)result;
    NSMutableString* str = [NSMutableString stringWithUTF8String:"[ "];

    int i;
    for (i = 0; i < [ar getItemsCount]; i++) {
        id<IRhoRubyObject>item = [ar getItemByIndex:i];
        id<IRhoRubyString>attr1 = (id<IRhoRubyString>)[rr executeRubyObjectMethod:item method_name:@"attr1" parameters:nil];
        id<IRhoRubyString>attr2 = (id<IRhoRubyString>)[rr executeRubyObjectMethod:item method_name:@"attr2" parameters:nil];
        id<IRhoRubyString>attr3 = (id<IRhoRubyString>)[rr executeRubyObjectMethod:item method_name:@"attr3" parameters:nil];

        [str appendString:@"< attr1 = \""];
        [str appendString:[attr1 getString]];

        [str appendString:@"\", attr2 = \""];
        [str appendString:[attr2 getString]];

        [str appendString:@"\", attr3 = \""];
        [str appendString:[attr3 getString]];

        [str appendString:@"\" >"];
        
        if (i < ([ar getItemsCount]-1)) {
           [str appendString:@", "];
        }
    }
    [str appendString:@" ]"];

    NSLog(@"$$$$$$$$$   RESULT : $$$$$$$$$$");
    NSLog(str);
    NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
}


-(void) fillModelByTwoItems {
    
    id<IRhoRuby> rr = [RhoRubySingletone getRhoRuby];
    id<IRhoRubyObject>model1 = [rr makeRubyClassObject:@"Model1"];
    [rr executeRubyObjectMethod:model1 method_name:@"fillModelByPredefinedSet" parameters:nil];

}

- (void) run_test_02 {
    id<IRhoRuby> rr = [RhoRubySingletone getRhoRuby];
    [rr addRubyNativeCallback:self callback_id:@"myCallback01"];
    id<IRhoRubyObject>model1 = [rr makeRubyClassObject:@"Model1"];
    
    id<IRhoRubyMutableHash> r_hash = (id<IRhoRubyMutableHash>)[rr makeBaseTypeObject:kRhoRubyMutableHash];
    
    id<IRhoRubyMutableInteger> r_int = (id<IRhoRubyMutableInteger>)[rr makeBaseTypeObject:kRhoRubyMutableInteger];
    [r_int setLong:555];
    
    [r_hash addItemWithKey:@"value1" item:r_int];

    id<IRhoRubyMutableString> r_str = (id<IRhoRubyMutableString>)[rr makeBaseTypeObject:kRhoRubyMutableString];
    [r_str setString:@"simple string value ZZZ"];
    
    [r_hash addItemWithKey:@"value2" item:r_str];

    [rr executeRubyObjectMethod:model1 method_name:@"callNativeCallback" parameters:r_hash];
    
}



-(void) onRubyNativeWithParam:(id<IRhoRubyObject>)param {
    id<IRhoRubyString> result_str = (id<IRhoRubyString>)param;
    
    NSLog(@"$$$$$$$$$   NATIVE CALLBACK RECEIVED : $$$$$$$$$$");
    NSLog([result_str getString]);
    NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
}


-(void) rhoRubyRunnableRun {
    
    [self run_test_01];
    
}

- (IBAction)onTest01Run:(id)sender {
    NSLog(@"$$$ test 01 START");
    
    
    [self fillModelByTwoItems];
    
    //run_rho_test();
    //[self run_test_01];
    [self run_test_02];
    
    id<IRhoRuby> rr = [RhoRubySingletone getRhoRuby];
    [rr executeInRubyThread:self];
    
    NSLog(@"$$$ test 01 FINISH");}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



@end
