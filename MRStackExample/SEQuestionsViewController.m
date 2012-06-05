//
//  SEQuestionsViewController.m
//  MRStackExample
//
//  Created by Mahipal Raythattha on 6/4/12.
//  Copyright (c) 2012 Mahipal Raythattha. All rights reserved.
//

//  Exercises left for the reader ;)
//  - add pagination
//  - cache results to disk using SQL
//  - and many more!

#import "SEQuestionsViewController.h"
#import "SEQuestion.h"
#import "SEConstants.h"

@interface SEQuestionsViewController ()

@property (nonatomic, retain) UITableView *tableView;

@end

@implementation SEQuestionsViewController

@synthesize dataSource = _dataSource;
@synthesize tableView = _tableView;

- (id) initWithDataSource:(SECloudDataSource *)inputDataSource
{
    self = [super init];
    if (self)
    {
        self.dataSource = inputDataSource;
        self.title = @"Featured SO Questions";
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
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.dataSource.questions count] == 0)
    {
        [self.dataSource refreshFeaturedQuestions];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateQuestions:) name:kSEUpdatedFeaturedQuestionsNotification object:nil];
    
    // TODO: Register for notifications.
}

- (void) didUpdateQuestions: (NSNotification *) theNotification
{
    [self.tableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource.questions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QuestionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];        
    }
    
    SEQuestion *q = [self.dataSource.questions objectAtIndex:indexPath.row];
    
    // Let's add a bit of vertical padding to the cell.
    cell.textLabel.text = [NSString stringWithFormat:@"\n%@\n ", q.title];

    // And let's show some extra metadata about the question, too.
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d answers", q.answer_count];
    
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Examine the text that we're displaying, and adjust the cell's height accordingly.
    
    SEQuestion *q = [self.dataSource.questions objectAtIndex:indexPath.row];
    
    NSString *qString = [[NSString alloc] initWithFormat:@"\n%@\n ", q.title];
    
    // We'll allow for a 10px margin on either side.
    CGSize titleBox = [qString sizeWithFont:[UIFont boldSystemFontOfSize:16.0]
                           constrainedToSize:CGSizeMake(300.0, 2000.0)
                               lineBreakMode:UILineBreakModeWordWrap];
    [qString release];
    
    // Just eyeballing the measurements, it looks like we should add ~30px to account for the details label.
    return titleBox.height + 30.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // TODO: Create a details view controller subclass.
    // Then, instantiate one here and inject the necessary dependencies.
}

@end
