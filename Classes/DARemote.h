//
//  DARemote.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DARemote : NSObject {

}

+ (NSArray *)searchEntries:(NSString *)word error:(NSError **)error;
+ (NSArray *)searchWithPrefix:(NSString *)prefix error:(NSError **)error;
+ (NSArray *)searchWithSuffix:(NSString *)suffix error:(NSError **)error;
+ (NSArray *)searchSimilar:(NSString *)word error:(NSError **)error;

@end
