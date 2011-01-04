//
//  InfoPageController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 04/01/2011.
//

#import <UIKit/UIKit.h>
#import "DADelegate.h"

@interface InfoPageController : UIViewController <UIWebViewDelegate> {
    DADelegate *delegate;
    NSIndexPath *index;
}

@end
