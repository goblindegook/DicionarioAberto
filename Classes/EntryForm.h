//
//  Form.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import <Foundation/Foundation.h>


@interface EntryForm : NSObject {
    NSMutableString *orth;
    NSMutableString *phon;
}

@property (nonatomic, retain) NSMutableString *orth;
@property (nonatomic, retain) NSMutableString *phon;

@end
