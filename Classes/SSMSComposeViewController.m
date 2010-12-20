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
    [super loadView];
    UIView *view = [self viewForFieldAtIndex:0];
    if ([view isKindOfClass:[TTPickerTextField class]]) {
        TTPickerTextField *field = (TTPickerTextField *)view;
        field.returnKeyType = UIReturnKeyDefault;
		field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    if (startClean) {
        _textEditor.text = @"Click Here To add Content";
    }
}

#pragma mark -
#pragma mark private
- (TTPickerTextField *)recipientsField {
    return [_fieldViews objectAtIndex:0];
}

- (NSString *)filterNonDigitOfString:(NSString *)target {
    return [[target componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
            componentsJoinedByString:@""];
}

- (void)commitTypedPhoneNumber {
	TTPickerTextField *recipientsField = [self recipientsField];
	NSString *enteredNumber = [self filterNonDigitOfString:recipientsField.text];
    if (![enteredNumber isEmptyOrWhitespace]) {
        [self addRecipient:[[AddressBookEntry alloc] initWithName:nil phoneNumber:enteredNumber] forFieldAtIndex:0];
    }	
}

- (void)send {
    NSLog(@"content: %@", self.body);
	[self commitTypedPhoneNumber];
    TTPickerTextField *recipientsField = [self recipientsField];
	NSLog(@"recipients: %@", recipientsField.cells);
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

- (BOOL)hasRequiredTextWithRecipientsField:(NSString *)recipientsFieldText {
    if ([self.body isEmptyOrWhitespace]) {
        return NO;
    }
    NSString *enteredNumber = [self filterNonDigitOfString:recipientsFieldText];
    if ([enteredNumber isEmptyOrWhitespace] && [[self recipientsField].cells count] == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)hasRequiredText {
    return [self hasRequiredTextWithRecipientsField:[self recipientsField].text];
}

- (void)updateSendCommand {
    if ([self hasRequiredText]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)addContactWithName:(NSString *)name phoneNumber:(NSString *)phoneNumber {
	AddressBookEntry *entry = [[[AddressBookEntry alloc] initWithName:name phoneNumber:phoneNumber] autorelease];
	[self addRecipient:entry forFieldAtIndex:0];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    NSString *beforeChange = textField.text;
    NSString *invariable = [beforeChange substringToIndex:range.location];
    NSString *afterChange = [invariable stringByAppendingString:string];
    // update send command validity
    if ([self hasRequiredTextWithRecipientsField:afterChange]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    return YES;
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
		// next time it won't be cleared
		startClean = NO;
    }
}


- (void)composeControllerShowRecipientPicker:(TTMessageController*)controller {
    // show contact picker
	[self commitTypedPhoneNumber];
	ABPeoplePickerNavigationController *picker =
	[[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
	[picker setDisplayedProperties:[NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]]];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

#pragma mark -
#pragma mark Contact Picker Delegate Methods
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString *)makeFullNameByFirstName:(NSString *)firstName lastName:(NSString *)lastName {
	if (firstName == nil) {
		if (lastName == nil) {
			return @"";
		} else {
			return lastName;
		}
	} else {
		if (lastName == nil) {
			return firstName;
		} else {
			return [NSString stringWithFormat:@"%@%@", firstName, lastName];
		}
	}
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	ABMutableMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
	int numberOfPhoneNumbers = ABMultiValueGetCount(multi);
	BOOL shouldContinue = NO;
	if (numberOfPhoneNumbers == 1) {
		NSString *address = (NSString *)ABMultiValueCopyValueAtIndex(multi, 0);
		NSString *firstName = (NSString *)ABRecordCopyValue(person,	kABPersonFirstNameProperty);
		NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
		NSString *fullName = [self makeFullNameByFirstName:firstName lastName:lastName];
		[self addContactWithName:fullName phoneNumber:address];
		[address release];
		[firstName release];
		[lastName release];
		shouldContinue = NO;
		[self dismissModalViewControllerAnimated:YES];
	} else if (numberOfPhoneNumbers > 1) {
		shouldContinue = YES;
	} else {
		shouldContinue = NO;
	}
	CFRelease(multi);
    return shouldContinue;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    ABMultiValueRef multi = ABRecordCopyValue(person, property);
	NSString *address = (NSString *)ABMultiValueCopyValueAtIndex(multi, identifier);
	NSString *firstName = (NSString *)ABRecordCopyValue(person,	kABPersonFirstNameProperty);
	NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	NSString *fullName = [self makeFullNameByFirstName:firstName lastName:lastName];
	[self addContactWithName:fullName phoneNumber:address];
	[address release];
	[firstName release];
	[lastName release];
	[self dismissModalViewControllerAnimated:YES];
	CFRelease(multi);
	return NO;
}


@end
