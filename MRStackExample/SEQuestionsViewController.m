//
//  SEQuestionsViewController.m
//  MRStackExample
//
//  Created by Mahipal Raythattha on 6/4/12.
//  Copyright (c) 2012 Mahipal Raythattha. All rights reserved.
//

#import "SEQuestionsViewController.h"

@interface SEQuestionsViewController ()

@end

@implementation SEQuestionsViewController

@synthesize dataSource = _dataSource;

- (id) initWithDataSource:(SECloudDataSource *)inputDataSource
{
    self = [super init];
    if (self)
    {
        self.dataSource = inputDataSource;
        self.title = @"Featured Questions";
    }
    return self;
}

- (void) dealloc
{
    [_dataSource release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
}




- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.dataSource.questions count] == 0)
    {
        [self.dataSource refreshFeaturedQuestions];
    }

}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
