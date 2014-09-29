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
    self.focusAreaList = [NSMutableArray arrayWithContentsOfFile:path];
    [self writeToPlist];
}

- (void)writeToPlist {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"itemList" ofType:@"plist"];
//    self.focusAreaList = [NSMutableArray arrayWithContentsOfFile:path];
    
//    NSDictionary *oneDictionary = [[NSDictionary alloc] init];
//    oneDictionary

//
//    [plistDict setValue:@"1.1.1" forKey:@"ProductVersion"];
//    [plistDict writeToFile:filePath atomically: YES];
//
    
    
    NSDictionary *dic1 = @{
                                @"name" : @"WorkoutName1",
                                @"repTime" : [NSNumber numberWithFloat:.5],
                                @"restTime" : [NSNumber numberWithFloat: 2.1],
                                @"numRep" : [NSNumber numberWithInt:10],
                                @"numSet" : [NSNumber numberWithInt:3],
                                };

    NSDictionary *dic2 = @{
                                    @"name" : @"WorkoutName2",
                                    @"repTime" : [NSNumber numberWithFloat:1.5],
                                    @"restTime" : [NSNumber numberWithFloat: 3.1],
                                    @"numRep" : [NSNumber numberWithInt:6],
                                    @"numSet" : [NSNumber numberWithInt:3],
                                    };
    
    NSDictionary *dic3 = @{
                                    @"name" : @"WorkoutName3",
                                    @"repTime" : [NSNumber numberWithFloat:.7],
                                    @"restTime" : [NSNumber numberWithFloat: 1.7],
                                    @"numRep" : [NSNumber numberWithInt:3],
                                    @"numSet" : [NSNumber numberWithInt:5],
                                    };
    
    NSArray *newArray = [NSArray arrayWithObjects:dic1, dic2, dic3, nil];
    
    NSDictionary *item = @{ @"body" : @"New Workout Area",
                             @"detail":newArray,
                             };
    [item writeToFile:path atomically:YES];
    
    [self.focusAreaList addObject:item];

}

/*
 - (void)readPlist
 {
 NSString *filePath = @"/System/Library/CoreServices/SystemVersion.plist";
 NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
 
 NSString *value;
 value = [plistDict objectForKey:@"ProductVersion"];
 
 // You could now call the string "value" from somewhere to return the value of the string in the .plist specified, for the specified key.
}

- (void)writeToPlist
{
    NSString *filePath = @"/System/Library/CoreServices/SystemVersion.plist";
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    
    [plistDict setValue:@"1.1.1" forKey:@"ProductVersion"];
    [plistDict writeToFile:filePath atomically: YES];
    
}

 */







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.focusAreaList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BodyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *bodyPart = self.focusAreaList[indexPath.row];
    
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
NSDictionary *bodyPart = self.focusAreaList[indexPath.row];
                
                [self prepareForTheRing:segue.destinationViewController setArray:[bodyPart objectForKey:@"detail"] withName:[bodyPart objectForKey:@"body"]
                 ];
                
            }
        }
    }
}
@end
