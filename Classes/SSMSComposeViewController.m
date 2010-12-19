//
//  SSMSComposeViewController.m
//  SSMSComposeViewController
//
//  Created by Chi Zhang on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "SSMSComposeViewController.h"
#import "AddressBookDataSource.h"
#import "Three20Core/NSStringAdditions.h"

@implementation SSMSComposeViewController
@synthesize startClean;

#pragma mark -
#pragma mark UIViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [_fields release];
        _fields = [[NSArray alloc] initWithObjects:
                   [[[TTMessageRecipientField alloc] initWithTitle: TTLocalizedString(@"To:", @"")
                                                          required: YES] autorelease],
                   nil];
        
        self.title = TTLocalizedString(@"New Message", @"");
        self.navigationItem.leftBarButtonItem.title = @"xxx";
        self.delegate = self;
        self.showsRecipientPicker = YES;
        self.dataSource = [[AddressBookDataSource alloc] init];
    }
    
    return self;
}

- (void)loadView {
    //NSLog(@"loadview");
    [super loadView];
    UIView *view = [self viewForFieldAtIndex:0];
    if ([view isKindOfClass:[TTPickerTextField class]]) {
        TTPickerTextField *field = (TTPickerTextField *)view;
        field.returnKeyType = UIReturnKeyDefault;
    }
    if (startClean) {
        _textEditor.text = @"Click Here To add Content";
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    return YES;
}

- (NSString *)filterNonDigitOfString:(NSString *)target {
    return [[target componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
            componentsJoinedByString:@""];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *text = [self filterNonDigitOfString:textField.text];
    if (![text isEmptyOrWhitespace]) {
        AddressBookEntry *entry = [[[AddressBookEntry alloc] initWithName:nil phoneNumber:text] autorelease];
        [self addRecipient:entry forFieldAtIndex:0];
    }
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self cancel:NO];
    }
}

- (void)textEditorDidBeginEditing:(TTTextEditor*)textEditor {
    if (startClean) {
        textEditor.text = @"";
    }
}

#pragma mark -
#pragma mark private
- (void)send {
    NSLog(@"content: %@", _textEditor.text);
    TTPickerTextField *textField = [_fieldViews objectAtIndex:0];
    NSLog(@"recipients: %@", textField.cells);
    NSLog(@"text: %@", textField.text);
    for (AddressBookEntry *entry in textField.cells) {
        NSLog(@"%@", entry.phoneNumber);
    }
}

- (void)confirmCancellation {
    UIAlertView* cancelAlertView = [[[UIAlertView alloc] initWithTitle:
                                     TTLocalizedString(@"Cancel", @"")
                                                               message:TTLocalizedString(@"Are you sure you want to cancel?", @"")
                                                              delegate:self
                                                     cancelButtonTitle:TTLocalizedString(@"Yes", @"")
                                                     otherButtonTitles:TTLocalizedString(@"No", @""), nil] autorelease];
    [cancelAlertView show];
}

- (void)composeControllerShowRecipientPicker:(TTMessageController*)controller {
    // TODO show contact picker
}

@end
