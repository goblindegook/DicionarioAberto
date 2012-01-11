//
//  DAParser.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
//

#import "DAParser.h"


@implementation DAParser


+(NSString *)markupToText:(NSString *)string {
    NSString *text = string;
    
    if (text && text.length) {
        text = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\^o" options:0 error:nil] stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@"º"];
        
        text = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\^a" options:0 error:nil] stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@"ª"];

        text = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\'" options:0 error:nil] stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@"’"];
    }
    
    return text;
}


+(NSString *)markupToHTML:(NSString *)string {
    NSString *html = string;
    
    if (html && html.length) {
        // entry^n links
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"(\\S+)\\^(\\d+)" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<a href=\"aberto://define:$2/$1\">$1</a>"];

        // [[text|entry]] links
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\[{2}([^\\|]+)\\|([^\\]]+)\\]{2}" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<a href=\"aberto://define/$2\">$1</a>"];
        
        // [[entry:n]] links
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\[{2}([^:]+):(\\d+)\\]{2}" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<a href=\"aberto://define:$2/$1\">$1</a>"];
        
        // [[entry]] links
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\[{2}([^\\]]+)\\]{2}" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<a href=\"aberto://define/$1\">$1</a>"];
        
        // References
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"([Oo] mesmo que|O mesmo ou melh[oó]r que|Abrev\\. de|Corr\\. de|Cp\\.|V\\.|v\\.) _([^_\\s]+)_" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"$1 <a href=\"aberto://define/$2\">$2</a>"];

        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\((De) _([^_\\s]+)_\\)" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"($1 <a href=\"aberto://define/$2\">$2</a>)"];
        
        // Emphasis
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"_([^_]*)_" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<em>$1</em>"];

        // Em dashes
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"--" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"—"];
        
        // Ordinals
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\^o(?!\\\")" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"º"];
        
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\^a(?!\\\")" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"ª"];
    }
    
    return html;
}

@end
