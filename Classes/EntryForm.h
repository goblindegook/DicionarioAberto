//
//  Form.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

@interface EntryForm : NSObject {
    NSMutableString *orth;
    NSMutableString *phon;
}

@property (nonatomic, strong) NSMutableString *orth;
@property (nonatomic, strong) NSMutableString *phon;

@end
