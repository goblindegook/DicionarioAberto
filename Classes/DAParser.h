//
//  DAParser.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
//

#import "Entry.h"

@interface DAParser : NSObject {

}

+ (NSString *)markupToText:(NSString *)string;
+ (NSString *)markupToHTML:(NSString *)string;

@end
