//
//  EditTextDemoViewController.m
//  EditTextDemo
//
//  Created by Chi Zhang on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditTextDemoViewController.h"
#import "SSMSComposeViewController.h"
#import "AddressBookDataSource.h"

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
    SSMSComposeViewController *ctvc = nil;
    switch (button.tag) {
        case 1:
            // clean
            ctvc = [[SSMSComposeViewController alloc] init];
            ctvc.startClean = YES;
            break;
        case 2:
        {
            // with recipients
            AddressBookEntry *entry1 = [[[AddressBookEntry alloc] initWithName:@"xxx" phoneNumber:@"111"] autorelease];
            AddressBookEntry *entry2 = [[[AddressBookEntry alloc] initWithName:@"yyy" phoneNumber:@"222"] autorelease];
            ctvc = [[SSMSComposeViewController alloc] initWithRecipients:[NSArray arrayWithObjects:entry1, entry2, nil]];
            ctvc.startClean = YES;
            break;
        }
        case 3:
        {
            ctvc = [[SSMSComposeViewController alloc] init];
            ctvc.body = @"xxxx";
            ctvc.startClean = NO;
        }
        default:
            break;
    }
    //NSLog(@"about to push");
    UINavigationController *navCon = [[UINavigationController alloc] init];
    
    
    [navCon pushViewController:ctvc animated:NO];
    [ctvc release];
    [self presentModalViewController:navCon animated:YES];
    [navCon release];
}

@end
