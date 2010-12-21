//
//  Entry.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Form.h"
#import "Sense.h"
#import "Etym.h"

@interface Entry : NSObject {
    NSInteger n;
    NSMutableString *entryId;
    NSMutableString *entryType;
    Form *entryForm;
    NSMutableArray *entrySense;
    Etym *entryEtym;
}

@property (nonatomic, assign) NSInteger n;
@property (nonatomic, retain) NSMutableString *entryId;
@property (nonatomic, retain) NSMutableString *entryType;
@property (nonatomic, retain) Form *entryForm;
@property (nonatomic, retain) NSMutableArray *entrySense;
@property (nonatomic, retain) Etym *entryEtym;

@end
