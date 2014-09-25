//
//  MainTVC.m
//  RingPractice
//
//  Created by Sue Lee on 9/24(Wednesday).
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import "MainTVC.h"
#import "ItemListTVC.h"

@interface MainTVC ()
@end

@implementation MainTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Main Page";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"itemList" ofType:@"plist"];
    self.bodyPartList = [NSMutableArray arrayWithContentsOfFile:path];
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
    return [self.bodyPartList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BodyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *bodyPart = self.bodyPartList[indexPath.row];
    
    cell.textLabel.text = [bodyPart objectForKey:@"body"];
    // Configure the cell...
    
    return cell;
}

- (void)prepareForTheRing:(ItemListTVC *)vc setArray:(NSArray *)arr withName:(NSString *)name {
    vc.workoutArray = [NSMutableArray arrayWithArray:arr];
    vc.title = name;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"items"]) {
            if ([segue.destinationViewController isKindOfClass:[ItemListTVC class]]) {
NSDictionary *bodyPart = self.bodyPartList[indexPath.row];
                
                [self prepareForTheRing:segue.destinationViewController setArray:[bodyPart objectForKey:@"detail"] withName:[bodyPart objectForKey:@"body"]
                 ];
                
            }
        }
    }
}
@end
