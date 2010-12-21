//
//  Etym.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import <Foundation/Foundation.h>


@interface Etymology : NSObject {
    NSMutableString *ori;
    NSMutableString *text;
}

@property (nonatomic, retain) NSMutableString *ori;
@property (nonatomic, retain) NSMutableString *text;

@end
