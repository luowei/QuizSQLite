//
//  QuizSQLiteViewController.h
//  QuizSQLite
//
//  Created by luowei on 14-5-21.
//  Copyright (c) 2014年 rootls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizSQLiteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *list;
}

@property(nonatomic,retain) IBOutlet UITableView *table;

@end
