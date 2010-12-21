//
//  Entry.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import <Foundation/Foundation.h>
#import "Form.h"
#import "Sense.h"
#import "Etymology.h"

@interface Entry : NSObject {
    NSInteger n;
    NSMutableString *entryId;
    NSMutableString *entryType;
    Form *entryForm;
    NSMutableArray *entrySense;
    Etymology *entryEtymology;
}

@property (nonatomic, assign) NSInteger n;
@property (nonatomic, retain) NSMutableString *entryId;
@property (nonatomic, retain) NSMutableString *entryType;
@property (nonatomic, retain) Form *entryForm;
@property (nonatomic, retain) NSMutableArray *entrySense;
@property (nonatomic, retain) Etymology *entryEtymology;

@end
