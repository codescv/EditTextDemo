//
//  EditTextDemoAppDelegate.h
//  EditTextDemo
//
//  Created by Chi Zhang on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditTextDemoViewController;

@interface EditTextDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EditTextDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EditTextDemoViewController *viewController;

@end

