//
//  SuperEntry.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import <Foundation/Foundation.h>
#import "Entry.h"

@interface SuperEntry : NSObject {
    NSMutableArray *entry;
}

@property (nonatomic, retain) NSMutableArray *entry;

@end
