//
//  SECloudDataSource.m
//  MRStackExample
//
//  Created by Mahipal Raythattha on 6/4/12.
//  Copyright (c) 2012 Mahipal Raythattha.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  Except as contained in this notice, the name(s) of the above copyright
//  holders shall not be used in advertising or otherwise to promote the sale, 
//  use or other dealings in this Software without prior written authorization.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "SECloudDataSource.h"
#import "AFHTTPRequestOperation.h"
#import "SEQuestion.h"
#import "SEConstants.h"

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
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"stackoverflow", @"site",
                            @"desc", @"order",
                            @"activity", @"sort", 
                            nil];
    
    [_wrapper getPath:@"questions/featured" parameters:params 
             
             success:
     ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        // DebugLog(@"great success! operation %@, responseObject %@", operation, responseObject);
        
        NSError *parseError = nil;
        NSDictionary *parsedResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&parseError];
        
        if (parseError)
        {
            DebugLog(@"Oh no! Operation response returned unparseable JSON. \n Operation: %@ \n responseObject: %@ \n parseError: %@", operation, responseObject, parseError);
            return;
        }
        
        DebugLog(@"%@", [parsedResponse objectForKey:@"items"]);
        
        NSMutableArray *parsedQuestions = [[NSMutableArray alloc] init];
        for (NSDictionary *questionDict in [parsedResponse objectForKey:@"items"])
        {
            SEQuestion *q = [[SEQuestion alloc] initWithDataDictionary:questionDict];
            [parsedQuestions addObject:q];
            [q release];
        }
        
        self.questions = parsedQuestions;
        [parsedQuestions release];
        
        DebugLog(@"%@", self.questions);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kSEUpdatedFeaturedQuestionsNotification object:self];
        
        // TODO: Post a notification here!
    }
             
             failure:
     ^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DebugLog(@"operation %@ failed with error %@", operation, error);
    }];
    
    
    [params release];
}

@end
