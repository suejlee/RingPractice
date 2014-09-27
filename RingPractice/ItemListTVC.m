//
//  ItemListTVC.m
//  RingPractice
//
//  Created by Sue Lee on 9/24(Wednesday).
//  Copyright (c) 2014 Catinea. All rights reserved.
//

#import "ItemListTVC.h"
#import "NewRingVC.h"

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
//    float repTime = [[item objectForKey:@"repTime"] floatValue];
//    float restTime= [[item objectForKey:@"restTime"] floatValue];
    int numRep = [[item objectForKey:@"numRep"] intValue] ;
    int numSet = [[item objectForKey:@"numSet"] intValue] ;

    cell.textLabel.text = [NSString stringWithFormat:@"%@ (rep:%d,set:%d)", name, numRep, numSet];
    return cell;
}

- (void)prepareForTheRing:(NewRingVC *)vc with:(NSDictionary *)item{
    
    NSString *name = [item objectForKey:@"name"];
    float repTime = [[item objectForKey:@"repTime"] floatValue];
    float restTime= [[item objectForKey:@"restTime"] floatValue];
    int numRep = [[item objectForKey:@"numRep"] intValue] ;
    int numSet = [[item objectForKey:@"numSet"] intValue] ;

    vc.title = name;
    vc.repTime = repTime;
    vc.restTime = restTime ;
    vc.numRep =   numRep;
    vc.numSet =  numSet;
    
//    NSLog(@"%@ (%.2f,%.2f)(%d/%d)", name, repTime, end, numRep, numSet);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"NewRing"]) {
            if ([segue.destinationViewController isKindOfClass:[NewRingVC class]]) {

                NSDictionary *item = self.workoutArray[indexPath.row];
                
                [self prepareForTheRing:segue.destinationViewController with:item];
            }
        }
    }
}


@end
