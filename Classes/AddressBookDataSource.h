#import <Three20/Three20.h>

@interface AddressBookEntry : NSObject
{
    NSString *_name;
    NSString *_phoneNumber;
}
- (id)initWithName:(NSString *)name phoneNumber:(NSString *)phoneNumber;
@property (retain) NSString *name;
@property (retain) NSString *phoneNumber;
@end

@interface AddressBookDataSource : TTSectionedDataSource {

}
@end