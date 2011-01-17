//
//  Entry.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "TouchXML.h"
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
@property (nonatomic, retain) NSMutableString *entryId;
@property (nonatomic, retain) NSMutableString *entryType;
@property (nonatomic, retain) EntryForm *entryForm;
@property (nonatomic, retain) NSMutableArray *entrySense;
@property (nonatomic, retain) EntryEtymology *entryEtymology;

- (id)initFromXMLString:(NSString *)xml error:(NSError **)error;

@end
