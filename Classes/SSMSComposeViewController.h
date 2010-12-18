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

// UI
#import "Three20UI/TTViewController.h"
#import "Three20UI/TTTextEditorDelegate.h"
#import "TTMessageController.h"
#import "TTMessageControllerDelegate.h"
#import "TTTableViewDataSource.h"
@class TTPickerTextField;
@class TTActivityLabel;
@class TTTextEditor;

/**
 * A view controller for composing email like messages, which is visually
 * similar to Apple's in-app mail composer.
 *
 * This class was originally implemented before iPhone OS 3.0, which
 * introduced the MFMailComposeViewController. It's original purpose
 * was to fill that gap in the SDK. If you want to allow users to send
 * an email via their existing Mail.app accounts, you should use
 * MFMailComposeViewController.
 *
 * You may find this class useful if you need to present a visually similar
 * view, but handle the delivery of the message yourself. This class is also
 * useful when you want to customize the fields presented to the user.
 */
@interface SSMSComposeViewController : TTMessageController <TTMessageControllerDelegate, UITextFieldDelegate, TTTextEditorDelegate> {

}

/**
 * Initializes the class with an array of recipients. These recipients will
 * be pre-filled in the TTMessageRecipientField's view.
 *
 * If a non-empty recipients array is provided, TTMessageController expects
 * the first field to be an instance of TTMessageRecipientField. You may pass
 * nil if you do not wish to supply initial recipients.
 */
- (id)initWithRecipients:(NSArray*)recipients;

/**
 * Adds the supplied recipient to the field at the index provided. That
 * recipient will be rendered as a cell within that field's view. The cell's
 * label will be determined by asking the datasource for a string label for
 * the recipient object provided.
 *
 * This method is a no-op if the datasource fails to provide a label for the
 * cell, or if the fieldIndex provided does not refer to a
 * TTPickerTextField.
 */
- (void)addRecipient:(id)recipient forFieldAtIndex:(NSUInteger)fieldIndex;

/**
 * Returns the text value of the field at the supplied index. Passing
 * fields.count returns the body contents.
 *
 * Whitespace has been trimmed from the returned value.
 */
- (NSString*)textForFieldAtIndex:(NSUInteger)fieldIndex;

/**
 * Sets the text value for the field at fieldIndex. Passing fields.count
 * sets the body text.
 */
- (void)setText:(NSString*)text forFieldAtIndex:(NSUInteger)fieldIndex;

/**
 * Returns true if the field at the supplied index is not empty or has
 * only whitespace. Passing fields.count returns true if the body has any
 * text, whitespace included.
 */
- (BOOL)fieldHasValueAtIndex:(NSUInteger)fieldIndex;

/**
 * Returns the UIView instance representing the field at fieldIndex. Passing
 * fields.count returns the view representing the body contents.
 */
- (UIView*)viewForFieldAtIndex:(NSUInteger)fieldIndex;

/**
 * Causes a view used to indicate message activity to be shown or dismissed
 * depending on the value of show. This view obscures the editable field views.
 * It is usually shown while the message is being sent.
 */
- (void)showActivityView:(BOOL)show;

/**
 * Returns the title for the activity view that is shown by showActivityView.
 * By default, the title is "Sending...", but subclasses may override this
 * method to show a different title. The default title has been localized.
 */
- (NSString*)titleForSending;

/**
 * Tells the delegate to send the message.
 */
- (void)send;

/**
 * Cancel the message, but confirm first with the user if necessary.
 */
- (void)cancel:(BOOL)confirmIfNecessary;

/**
 * Confirms with the user that it is ok to cancel.
 */
- (void)confirmCancellation;

/**
 * Sent before the delegate is informed that it should send the message.
 * Subclasses can override this method to implement custom logic.
 */
- (void)messageWillSend:(NSArray*)fields;

/**
 * The user touched the recipient picker button. Subclasses can override
 * this method to implement custom logic.
 */
- (void)messageWillShowRecipientPicker;

/**
 * Sent after the delegate has been informed that it should send the message.
 * Subclasses can override this method to implement custom logic.
 */
- (void)messageDidSend;

/**
 * Determines if the message should cancel without confirming with the user.
 * The default implementation is to allow the user to cancel without
 * confirmation if no required fields have been modified and they have not
 * entered any subject or body text.
 */
- (BOOL)messageShouldCancel;

@end
