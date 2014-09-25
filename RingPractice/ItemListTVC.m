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
    
    NSDictionary *item = self.workoutArray[indexPath.row];
    NSString *name = [item objectForKey:@"name"];
    float start = [[item objectForKey:@"start"] floatValue];
    float end = [[item objectForKey:@"end"] floatValue];
    int repetition = [[item objectForKey:@"repetiiton"] integerValue];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%.2f,%.2f,%d)", name, start, end,repetition];
    return cell;
}

- (void)prepareForTheRing:(RingViewController *)vc with:(NSDictionary *)item{
    
    NSString *name = [item objectForKey:@"name"];
    float start = [[item objectForKey:@"start"] floatValue];
    float end = [[item objectForKey:@"end"] floatValue];

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

                NSDictionary *item = self.workoutArray[indexPath.row];
                
                [self prepareForTheRing:segue.destinationViewController with:item];
                
            }
        }
    }
}


@end
