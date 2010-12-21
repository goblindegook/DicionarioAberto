//
//  Etym.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Etym : NSObject {
    NSMutableString *ori;
    NSMutableString *text;
}

@property (nonatomic, retain) NSMutableString *ori;
@property (nonatomic, retain) NSMutableString *text;

@end
