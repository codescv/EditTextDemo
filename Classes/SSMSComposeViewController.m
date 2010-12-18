//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
#import "SSMSComposeViewController.h"
#import "AddressBookDataSource.h"
#import "Three20UI/TTMessageController.h"

// UI
#import "Three20UI/TTMessageControllerDelegate.h"
#import "Three20UI/TTMessageRecipientField.h"
#import "Three20UI/TTMessageTextField.h"
#import "Three20UI/TTActivityLabel.h"
#import "Three20UI/TTPickerTextField.h"
#import "Three20UI/TTTextEditor.h"
#import "Three20UI/TTTableViewDataSource.h"
#import "Three20UI/UIViewAdditions.h"

// UINavigator
#import "Three20UINavigator/TTGlobalNavigatorMetrics.h"

// UICommon
#import "Three20UICommon/TTGlobalUICommon.h"
#import "Three20UICommon/UIViewControllerAdditions.h"

// Style
#import "Three20Style/TTGlobalStyle.h"
#import "Three20Style/TTDefaultStyleSheet.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"
#import "Three20Core/TTGlobalCoreLocale.h"
#import "Three20Core/TTGlobalCoreRects.h"
#import "Three20Core/NSStringAdditions.h"



@implementation SSMSComposeViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
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

#pragma mark -
#pragma mark Private
- (void)loadView {
    [super loadView];
    UIView *view = [self viewForFieldAtIndex:0];
    if ([view isKindOfClass:[TTPickerTextField class]]) {
        TTPickerTextField *field = (TTPickerTextField *)view;
        field.returnKeyType = UIReturnKeyDefault;
    }
    _textEditor.text = @"Click Here To add Content";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *text = [self filterNonDigitOfString:textField.text];
    if (![text isEmptyOrWhitespace]) {
        AddressBookEntry *entry = [[[AddressBookEntry alloc] initWithName:nil phoneNumber:text] autorelease];
        [self addRecipient:entry forFieldAtIndex:0];
    }
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self cancel:NO];
    }
}

- (void)textEditorDidBeginEditing:(TTTextEditor*)textEditor {
    textEditor.text = @"";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
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
    // TODO
}

@end
