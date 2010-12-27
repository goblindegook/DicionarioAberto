//
//  DAMarkup.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import "DAMarkup.h"


@implementation DAMarkup

+(NSString *)markupToHTML:(NSString *)string {
    NSString *html = string;
    
    if (html && html.length) {
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\[{2}(([^\\]:]*):(\\d+))\\]{2}" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<a href=\"aberto://$2:$3\">$2</a>"];
        
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\[{2}([^\\]]*)\\]{2}" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<a href=\"aberto://$1\">$1</a>"];
        
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"(O mesmo que|Abrev\\. de|Cp\\.) _([^_]*)_" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"$1 <a href=\"aberto://$2\">$2</a>"];

        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\((De) _([^_]*)_\\)" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"($1 <a href=\"aberto://$2\">$2</a>)"];
        
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"_([^_]*)_" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<em>$1</em>"];

        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\^o" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"&ordm;"];
        
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\^a" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"&ordf;"];
    }
    
    return html;
}

@end
