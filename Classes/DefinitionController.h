//
//  DefinitionController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DefinitionController : UIViewController <UIWebViewDelegate> {
    NSIndexPath *index;
    IBOutlet UIWebView *definitionView;
}

-(id)initWithIndexPath:(NSIndexPath *)indexPath;
-(NSString *)htmlEntries:(NSArray *)entries;
-(NSString *)htmlEntries:(NSArray *)entries n:(NSInteger)n;

@end
