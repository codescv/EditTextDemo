#import "AddressBookDataSource.h"

@implementation AddressBookEntry
@synthesize name=_name, phoneNumber=_phoneNumber;
- (id)initWithName:(NSString *)name phoneNumber:(NSString *)phoneNumber {
    if (self = [super init]) {
        self.name = name;
        self.phoneNumber = phoneNumber;
    }
    return self;
}
- (void)dealloc {
    [super dealloc];
    [_name release];
    [_phoneNumber release];
}
@end

@implementation AddressBookDataSource

- (NSString*)tableView:(UITableView*)tableView labelForObject:(id)object {
    if ([object isKindOfClass:[AddressBookEntry class]]) {
        AddressBookEntry *entry = (AddressBookEntry *)object;
        if (entry.name == nil) {
            return entry.phoneNumber;
        } else {
            return entry.name;
        }

    }
    return [object description];
}

@end
