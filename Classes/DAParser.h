//
//  DAParser.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"
#import "Entry.h"

@interface DAParser : NSObject {

}

+ (NSArray *)parseAPIResponse:(NSString *)response list:(BOOL)list;
+(NSString *)markupToHTML:(NSString *)string;

@end
