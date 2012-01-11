//
//  DDXMLNode+DAXMLNode.h
//  DicionarioAberto
//
//  Created by Luis Rodrigues on 1/11/12.
//  Copyright (c) 2012 log.OSCON. All rights reserved.
//

#import "DDXMLNode.h"

@interface DDXMLNode (DAXMLNode)

- (DDXMLNode *)nodeForXPath:(NSString *)xpath error:(NSError **)error;

@end
