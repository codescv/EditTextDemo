//
//  EditTextDemoViewController.m
//  EditTextDemo
//
//  Created by Chi Zhang on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditTextDemoViewController.h"
#import "SSMSComposeViewController.h"

@implementation EditTextDemoViewController

// The designated initializer. Override to perform setup that is required before the view is loaded.
/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)dealloc {
    [super dealloc];
}

- (IBAction)buttonClicked:(UIButton *)button {
    UINavigationController *navCon = [[UINavigationController alloc] init];
    SSMSComposeViewController *ctvc = [[SSMSComposeViewController alloc] init];
    ctvc.requireNonEmptyMessageBody = YES;
    ctvc.showsRecipientPicker = YES;
    [navCon pushViewController:ctvc animated:NO];
    [ctvc release];
    [self presentModalViewController:navCon animated:YES];
    [navCon release];
}

@end
