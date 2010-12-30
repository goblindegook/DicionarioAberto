//
//  DARemote.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int const DARemoteSearchPrefix;
extern int const DARemoteSearchSuffix;
extern int const DARemoteSearchLike;

@interface DARemote : NSObject {

}

+ (NSArray *)getEntries:(NSString *)word error:(NSError **)error;
+ (NSArray *)search:(NSString *)prefix type:(int)type error:(NSError **)error;

@end
