//
//  Usage.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//


@interface EntrySenseUsage : NSObject {
    NSMutableString *type;
    NSMutableString *text;
}

@property (nonatomic, retain) NSMutableString *type;
@property (nonatomic, retain) NSMutableString *text;

@end
