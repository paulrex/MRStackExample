//
//  SEQuestion.h
//  MRStackExample
//
//  Created by Mahipal Raythattha on 6/4/12.
//  Copyright (c) 2012 Mahipal Raythattha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEQuestion : NSObject

@property (nonatomic, assign) int answer_count;
@property (nonatomic, assign) int is_answered;
@property (nonatomic, assign) int question_id;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int view_count;

@property (nonatomic, retain) NSString *title;

- (id) initWithDataDictionary: (NSDictionary *) inputDictionary;

@end
