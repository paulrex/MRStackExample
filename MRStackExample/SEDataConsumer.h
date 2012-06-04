//
//  SEDataConsumer.h
//  MRStackExample
//
//  Created by Mahipal Raythattha on 6/4/12.
//  Copyright (c) 2012 Mahipal Raythattha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SECloudDataSource.h"

@protocol SEDataConsumer <NSObject>

@property (nonatomic, retain) SECloudDataSource *dataSource;

- (id) initWithDataSource: (SECloudDataSource *) inputDataSource;

@end
