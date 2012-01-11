//
//  Etym.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

@interface EntryEtymology : NSObject {
    NSMutableString *ori;
    NSMutableString *text;
}

@property (nonatomic, strong) NSMutableString *ori;
@property (nonatomic, strong) NSMutableString *text;

@end
