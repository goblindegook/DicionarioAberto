//
//  DAHistory.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 30/12/2010.
//

@interface DAHistory :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * entry;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * entryDate;

@end



