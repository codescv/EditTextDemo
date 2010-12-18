
#import "MockDataSource.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MockAddressBook

@synthesize names = _names, fakeSearchDuration = _fakeSearchDuration;

///////////////////////////////////////////////////////////////////////////////////////////////////
// class public

+ (NSMutableArray*)fakeNames {
  return [NSMutableArray arrayWithObjects:
  @"aa",
  @"bb",
  @"cc",
  @"dddd",
  @"eee",
  nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithNames:(NSArray*)names {
  if (self = [super init]) {
    _allNames = [names copy];
    _names = nil;

  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_allNames);
  TT_RELEASE_SAFELY(_names);
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTModel

- (NSMutableArray *)delegates {
    return nil;
}

- (BOOL)isLoadingMore {
  return NO;
}

- (BOOL)isOutdated {
  return NO;
}

- (BOOL)isLoaded {
  return !!_names;
}

- (BOOL)isLoading {
    return NO;
}

- (BOOL)isEmpty {
  return !_names.count;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
}

- (void)invalidate:(BOOL)erase {
}

- (void)cancel {
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (void)loadNames {
  TT_RELEASE_SAFELY(_names);
  _names = [_allNames mutableCopy];
}

- (void)search:(NSString*)text {
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MockDataSource

@synthesize addressBook = _addressBook;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
  if (self = [super init]) {
    _addressBook = [[MockAddressBook alloc] initWithNames:[MockAddressBook fakeNames]];
    [_addressBook loadNames];
    self.model = _addressBook;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_addressBook);
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UITableViewDataSource

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView {
  return [TTTableViewDataSource lettersForSectionsWithSearch:YES summary:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewDataSource

- (void)tableViewDidLoadModel:(UITableView*)tableView {
  self.items = [NSMutableArray array];
  self.sections = [NSMutableArray array];

  NSMutableDictionary* groups = [NSMutableDictionary dictionary];
  for (NSString* name in _addressBook.names) {
    NSString* letter = [NSString stringWithFormat:@"%c", [name characterAtIndex:0]];
    NSMutableArray* section = [groups objectForKey:letter];
    if (!section) {
      section = [NSMutableArray array];
      [groups setObject:section forKey:letter];
    }

    TTTableItem* item = [TTTableTextItem itemWithText:name URL:nil];
    [section addObject:item];
  }

  NSArray* letters = [groups.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  for (NSString* letter in letters) {
    NSArray* items = [groups objectForKey:letter];
    [_sections addObject:letter];
    [_items addObject:items];
  }
}

- (NSString*)tableView:(UITableView*)tableView labelForObject:(id)object {
    NSLog(@"label for object: %@", object);
    return [object description];
}

@end
