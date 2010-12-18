#import "Three20UI/TTTextEditorDelegate.h"
#import "TTMessageController.h"
#import "TTMessageControllerDelegate.h"

@interface SSMSComposeViewController : TTMessageController <TTMessageControllerDelegate, UITextFieldDelegate, TTTextEditorDelegate> {

}

@end
