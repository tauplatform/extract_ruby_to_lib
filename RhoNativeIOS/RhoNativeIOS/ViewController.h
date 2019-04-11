//
//  ViewController.h
//  RhoNativeIOS
//
//  Created by Dmitry Soldatenkov on 03/04/2019.
//  Copyright © 2019 TAU Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "rhodesruby/api/RhoRuby.h"

@interface ViewController : UIViewController <IRhoRubyNativeCallback, IRhoRubyRunnable> {
    
}

-(void) onRubyNativeWithParam:(id<IRhoRubyObject>)param;

-(void) rhoRubyRunnableRun;

@end

