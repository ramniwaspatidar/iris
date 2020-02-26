//
//  BMI+CoreDataProperties.m
//  
//
//  Created by apptology on 1/18/18.
//
//

#import "BMI+CoreDataProperties.h"

@implementation BMI (CoreDataProperties)

+ (NSFetchRequest<BMI *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BMI"];
}

@dynamic bmiid;
@dynamic date;
@dynamic height;
@dynamic memberid;
@dynamic time;
@dynamic weight;
@dynamic bmicategory;
@dynamic bmivalue;


@end
