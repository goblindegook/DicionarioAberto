//
//  Etymology.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "Etymology.h"

@implementation Etymology

@synthesize ori;
@synthesize text;

-(NSString *)html {
    NSMutableString *html = text;
    
    if (html) {
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\[{2}(([^\\]:]*):\\d+)\\]{2}" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<a href=\"da:$1\">$2</a>"];
        
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\[{2}([^\\]:]*)\\]{2}" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<a href=\"da:$1\">$1</a>"];
        
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"_([^_]*)_" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<em>$1</em>"];
    }
        
    return html;
}

-(void) dealloc {
    [ori release];
    [text release];
    [super dealloc];
}

@end
