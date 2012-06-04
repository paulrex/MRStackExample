//
//  SECloudDataSource.m
//  MRStackExample
//
//  Created by Mahipal Raythattha on 6/4/12.
//  Copyright (c) 2012 Mahipal Raythattha. All rights reserved.
//

#import "SECloudDataSource.h"
#import "AFHTTPRequestOperation.h"

@implementation SECloudDataSource

@synthesize questions = _questions;

- (id) init
{
    self = [super init];
    if (self)
    {
        NSURL *baseURL = [NSURL URLWithString:@"https://api.stackexchange.com/2.0/"];
        _wrapper = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    }
    return self;
}

- (void) dealloc
{
    [_wrapper release];
    [super dealloc];
}

#pragma mark -
#pragma mark API-Specific Request Wrappers

- (void) refreshFeaturedQuestions
{
    // AFHTTPRequestOperation *op = [[[AFHTTPRequestOperation alloc] initWithRequest:r] autorelease];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"stackoverflow", @"site",
                            @"desc", @"order",
                            @"activity", @"sort", 
                            nil];
    
    [_wrapper getPath:@"questions/featured" parameters:params 
             
             success:
     ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DebugLog(@"great success! operation %@, responseObject %@", operation, responseObject);
        
        NSError *parseError = nil;
        NSDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&parseError];
        
        if (parseError)
        {
            DebugLog(@"Oh no! Operation response returned unparseable JSON. \n Operation: %@ \n responseObject: %@ \n parseError: %@", operation, responseObject, parseError);
            return;
        }
        
        DebugLog(@"%@", [parsedResponse objectForKey:@"items"]);
    }
             
             failure:
     ^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DebugLog(@"operation %@ failed with error %@", operation, error);
    }];
    
    
    [params release];
}

@end
