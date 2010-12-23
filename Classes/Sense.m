//
//  Sense.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "Sense.h"
#import "Usage.h"

@implementation Sense

@synthesize ast;
@synthesize def;
@synthesize gramGrp;
@synthesize usg;

-(NSString *)htmlDef {
    NSMutableString *html = def;
    
    html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"O mesmo que _([^_]*)_" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"O mesmo que <a href=\"da:$1\">$1</a>"];
    
    html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"_([^_]*)_" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<em>$1</em>"];
    
    return html;
}

-(void) dealloc {
    [def release];
    [gramGrp release];
    [usg release];
    [super dealloc];
}

@end
