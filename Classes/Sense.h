//
//  Sense.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Usage.h"

@interface Sense : NSObject {
    NSInteger ast;
    NSMutableString *def;
    NSMutableString *gramGrp;
    Usage *usg;
}

@property (nonatomic, assign) NSInteger ast;
@property (nonatomic, retain) NSMutableString *def;
@property (nonatomic, retain) NSMutableString *gramGrp;
@property (nonatomic, retain) Usage *usg;

@end
