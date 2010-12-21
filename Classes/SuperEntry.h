//
//  SuperEntry.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry.h"

@interface SuperEntry : NSObject {
    NSMutableArray *entry;
}

@property (nonatomic, retain) NSMutableArray *entry;

@end
