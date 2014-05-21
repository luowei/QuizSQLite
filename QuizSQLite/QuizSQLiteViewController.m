//
//  QuizSQLiteViewController.m
//  QuizSQLite
//
//  Created by luowei on 14-5-21.
//  Copyright (c) 2014年 rootls. All rights reserved.
//

#import "QuizSQLiteViewController.h"
#import "FMDatabase.h"
#import "QuizViewController.h"

@interface QuizSQLiteViewController ()

@end

@implementation QuizSQLiteViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	
    list = [[NSMutableArray alloc] init];
    [self updateTable];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return  [paths objectAtIndex:0];
}

-(void)updateTable{
    [list removeAllObjects];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[self dataFilePath] stringByAppendingPathComponent:@"quiz.sqlite"]];
    [db open];
    
    if([list count]==0){
        [db executeUpdate:@"DELETE FROM game"];
    }
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS game(id INTEGER PRIMARY KEY,name VARCHAR(50)) "];
        
    [db executeUpdate:@"INSERT INTO game(name) values(?)",@"iOS"];
    [db executeUpdate:@"INSERT INTO game(name) values(?)",@"星球大战"];
    
    FMResultSet *result = [db executeQuery:@" SELECT * FROM game"];
    while ([result next]) {
        [list addObject:[result stringForColumn:@"name"]];
    }
    
    [db close];
    [_table reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [list count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"myCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [list objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QuizViewController *vc = [[QuizViewController alloc]initWithNibName:@"QuizViewController" bundle:nil];
    
    NSString *quizTitle = [list objectAtIndex:indexPath.row];
    [vc setTitle:quizTitle];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
