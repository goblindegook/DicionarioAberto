//
//  Sense.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "EntrySenseUsage.h"

@interface EntrySense : NSObject {
    NSInteger ast;
    NSMutableString *def;
    NSMutableString *gramGrp;
    EntrySenseUsage *usg;
}

@property (nonatomic, assign) NSInteger ast;
@property (nonatomic, strong) NSMutableString *def;
@property (nonatomic, strong) NSMutableString *gramGrp;
@property (nonatomic, strong) EntrySenseUsage *usg;

@end
