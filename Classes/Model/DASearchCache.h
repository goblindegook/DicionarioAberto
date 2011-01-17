//
//  DASearchCache.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 30/12/2010.
//

@interface DASearchCache :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * searchQuery;
@property (nonatomic, retain) NSNumber * searchType;
@property (nonatomic, retain) NSDate * searchDate;
@property (nonatomic, retain) NSString * searchResult;

@end



