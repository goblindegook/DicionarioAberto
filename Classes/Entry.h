//
//  Entry.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "EntryForm.h"
#import "EntrySense.h"
#import "EntryEtymology.h"

@interface Entry : NSObject {
    NSInteger n;
    NSMutableString *entryId;
    NSMutableString *entryType;
    EntryForm *entryForm;
    NSMutableArray *entrySense;
    EntryEtymology *entryEtymology;
}

@property (nonatomic, assign) NSInteger n;
@property (nonatomic, strong) NSMutableString *entryId;
@property (nonatomic, strong) NSMutableString *entryType;
@property (nonatomic, strong) EntryForm *entryForm;
@property (nonatomic, strong) NSMutableArray *entrySense;
@property (nonatomic, strong) EntryEtymology *entryEtymology;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)entriesWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(NSArray *records))success failure:(void (^)(NSError *error))failure;


@end
