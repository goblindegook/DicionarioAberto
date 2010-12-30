//
//  Sense.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import <Foundation/Foundation.h>
#import "EntrySenseUsage.h"

@interface EntrySense : NSObject {
    NSInteger ast;
    NSMutableString *def;
    NSMutableString *gramGrp;
    EntrySenseUsage *usg;
}

@property (nonatomic, assign) NSInteger ast;
@property (nonatomic, retain) NSMutableString *def;
@property (nonatomic, retain) NSMutableString *gramGrp;
@property (nonatomic, retain) EntrySenseUsage *usg;

@end
