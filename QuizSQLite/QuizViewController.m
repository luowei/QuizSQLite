//
//  QuizViewController.m
//  QuizSQLite
//
//  Created by luowei on 14-5-21.
//  Copyright (c) 2014年 rootls. All rights reserved.
//

#import "QuizViewController.h"
#import "FMDatabase.h"

@interface QuizViewController ()

@end

@implementation QuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

-(void)updateTable{
    [lists removeAllObjects];
    FMDatabase *db = [FMDatabase databaseWithPath:[[self dataFilePath] stringByAppendingPathComponent:@"quiz.sqlite"]];
    [db open];
    
    if([lists count] ==0){
        [db executeUpdate:@"DELETE FROM questions"];
    }
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS questions(id INTEGER PRIMARY KEY,quiz INTEGER,question varchar(100),answer varchar(50))"];
    [db executeUpdate:@"INSERT INTO questions	(quiz,question,answer) VALUES(?,?,?)",@"1",@"Iphone 4 能用吗?(提示：No)",@"No"];
    [db executeUpdate:@"INSERT INTO questions(quiz,question,answer) VALUES(?,?,?)",@"2",@"有多个电影?(提示：6)",@"6"];
    
    FMResultSet *result = [db executeQuery:@"SELECT * FROM questions WHERE quiz = 1"];
    FMResultSet *result2 = [db executeQuery:@"SELECT * FROM questions WHERE quiz = 2"];
    
    if([self.title isEqual:@"iOS"]){
        while ([result next]) {
            [questions addObject:[result stringForColumn:@"question"]];
            [answers addObject:[result stringForColumn:@"answer"]];
        }
    }else{
        while ([result2 next]) {
            [questions addObject:[result2 stringForColumn:@"question"]];
            [answers addObject:[result2 stringForColumn:@"answer"]];
        }
    }
    [_question setText:[questions objectAtIndex:currentQuestion]];
    
    [db close];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    currentQuestion = 0;
    answers = [[NSMutableArray alloc]init];
    questions = [[NSMutableArray alloc]init];
    lists = [[NSMutableArray alloc]init];
    
    [self updateTable];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)keyboard:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)checkAnswer:(id)sender {
    NSString  *myGuess = [_answer text];
    if(currentQuestion <=[questions count]-1){
        if([myGuess isEqualToString:[answers objectAtIndex:currentQuestion]]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Correct" message:@"非常好" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"Wrong" message:@"回答错误" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert1 show];
        }
    }
    
}
@end
