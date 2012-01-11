//
//  DDXMLNode+DAXMLNode.m
//  DicionarioAberto
//
//  Created by Luis Rodrigues on 1/11/12.
//  Copyright (c) 2012 log.OSCON. All rights reserved.
//

#import "DDXMLNode+DAXMLNode.h"

@implementation DDXMLNode (DAXMLNode)

- (DDXMLNode *)nodeForXPath:(NSString *)xpath error:(NSError **)error
{
    NSArray *nodes = [self nodesForXPath:xpath error:error];
    
    if ([nodes count])
        return [nodes objectAtIndex:0];
    else
        return nil;
}

@end
