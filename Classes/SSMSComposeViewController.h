//
//  SSMSComposeViewController.h
//  SSMSComposeViewController
//
//  Created by Chi Zhang on 12/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Three20UI/TTTextEditorDelegate.h"
#import "TTMessageController.h"
#import "TTMessageControllerDelegate.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface SSMSComposeViewController : TTMessageController <TTMessageControllerDelegate, UITextFieldDelegate, TTTextEditorDelegate, ABPeoplePickerNavigationControllerDelegate> {
    BOOL startClean;
}
/* In clean mode, a 'type here' indicator will be shown in the content field which goes away
   when user types in the content field;
   otherwise, the composer has preloaded content and that content should not be changed.
*/
@property BOOL startClean;
@end
