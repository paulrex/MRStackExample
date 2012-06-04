//
//  SECloudDataSource.h
//  MRStackExample
//
//  Created by Mahipal Raythattha on 6/4/12.
//  Copyright (c) 2012 Mahipal Raythattha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"


@interface SECloudDataSource : NSObject
{
    AFHTTPClient *_wrapper;
}

@property (nonatomic, retain) NSArray *questions;

- (void) refreshFeaturedQuestions;

@end
