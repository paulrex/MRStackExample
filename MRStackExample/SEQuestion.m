//
//  SEQuestion.m
//  MRStackExample
//
//  Created by Mahipal Raythattha on 6/4/12.
//  Copyright (c) 2012 Mahipal Raythattha. All rights reserved.
//

#import "SEQuestion.h"

@implementation SEQuestion

@synthesize answer_count;
@synthesize is_answered;
@synthesize question_id;
@synthesize score;
@synthesize title;
@synthesize view_count;

- (id) initWithDataDictionary: (NSDictionary *) inputDictionary
{
    self = [super init];
    if (self)
    {
        [self setValuesForKeysWithDictionary:inputDictionary];
    }
    return self;
}

- (void) setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    // We override this method to centralize here any special cases for
    // parsing the data that the server returns for this object.
    
    // TODO: Cast all the integers... maybe?
    
    [super setValuesForKeysWithDictionary:keyedValues];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // This is our failsafe in case the API ever changes on us...
    // By handling this method and making it into a nop, we make sure that at least the app won't crash.
    // (The default behavior is to throw an exception, crashing the app.)
    
    DebugLog(@"Failed to set value: %@ for key: %@", value, key);
}

@end
