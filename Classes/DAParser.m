//
//  DAParser.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
//

#import "DAParser.h"


@implementation DAParser


+ (NSArray *)parseAPIResponse:(NSString *)response list:(BOOL)list {
    NSMutableArray *entries = [[[NSMutableArray alloc] init] autorelease];
    
    NSString *xpath = (list) ? @"//list/entry" : @"//entry";
    
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    for (CXMLElement *ee in [doc nodesForXPath:xpath error:nil]) {
        if (list) {
            [entries addObject:[ee stringValue]];
        } else {
            Entry *entry = [[Entry alloc] initFromXMLString:[ee XMLString] error:nil];
            if (entry) [entries addObject:entry];
            [entry release];
        }
    }
        
    [doc release];
    
    return entries;
}


+(NSString *)markupToHTML:(NSString *)string {
    NSString *html = string;
    
    if (html && html.length) {
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\[{2}(([^\\]:]*):(\\d+))\\]{2}" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<a href=\"aberto://define:$3/$2\">$2</a>"];
        
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\[{2}([^\\]]*)\\]{2}" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<a href=\"aberto://define/$1\">$1</a>"];
        
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"(O mesmo que|Abrev\\. de|Cf\\.|Cp\\.|V\\.) _([^_]*)_" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"$1 <a href=\"aberto://define/$2\">$2</a>"];

        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\((De) _([^_]*)_\\)" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"($1 <a href=\"aberto://define/$2\">$2</a>)"];
        
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"_([^_]*)_" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"<em>$1</em>"];

        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\^o" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"&ordm;"];
        
        html = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"\\^a" options:0 error:nil] stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"&ordf;"];
    }
    
    return html;
}

@end
