//
//  DASearchCache.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 30/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface DASearchCache :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * searchQuery;
@property (nonatomic, retain) NSNumber * searchType;
@property (nonatomic, retain) NSDate * searchDate;
@property (nonatomic, retain) NSString * searchResult;

@end



