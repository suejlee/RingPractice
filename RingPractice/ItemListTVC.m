//
//  ItemListTVC.m
//  RingPractice
//
//  Created by Sue Lee on 9/24(Wednesday).
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import "ItemListTVC.h"
#import "RingViewController.h"

@interface ItemListTVC ()

@end

@implementation ItemListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Core workout"; 
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"itemList" ofType:@"plist"];
    NSArray *workoutItems = [NSArray arrayWithContentsOfFile:path];
    
    self.workoutArray = [[NSMutableArray alloc] init];
    
    NSDictionary *singleItem;
    
    for (singleItem in workoutItems) {
        WorkoutItem *newItem = [[WorkoutItem alloc] init];
        newItem.name = [singleItem objectForKey:@"workoutNameKey"];
        newItem.start = [[singleItem objectForKey:@"startKey"] floatValue];
        newItem.end = [[singleItem objectForKey:@"endKey"] floatValue];
        newItem.repetition = [[singleItem objectForKey:@"repetitionKey"] integerValue];
        
        [self.workoutArray addObject:newItem];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.workoutArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    WorkoutItem *workoutItem = self.workoutArray[indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@, (%.2f,%.2f,%d)", workoutItem.name, workoutItem.start, workoutItem.end, workoutItem.repetition];
    return cell;
}

- (void)prepareForTheRing:(RingViewController *)vc start:(float)start end:(float)end Name:(NSString *)name
{
    vc.title = name;
    vc.initStartValue = start;
    vc.initEndValue = end;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"RingView"]) {
            if ([segue.destinationViewController isKindOfClass:[RingViewController class]]) {
                WorkoutItem *workoutItem = self.workoutArray[indexPath.row];

                [self prepareForTheRing:segue.destinationViewController
                                    start:workoutItem.start
                                    end:workoutItem.end
                                   Name:workoutItem.name
                 ];
                
            }
        }
    }}


@end
