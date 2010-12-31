//
//  DAHistory.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 30/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface DAHistory :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * entry;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * entryDate;

@end



