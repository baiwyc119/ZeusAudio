//
//  ViewController.m
//  ZeusAudio
//
//  Created by lingchen on 12/21/16.
//  Copyright © 2016 LingChen. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+ZAHex.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *audioRecordView;
@property (nonatomic, strong) UITableView *recordTableView;

@end

@implementation ViewController

#pragma mark - UI Lazy Load
- (UIView *)audioRecordView
{
    if (_audioRecordView == nil) {
        
    }
    return _audioRecordView;
}

- (UITableView *)recordTableView
{
    if (_recordTableView == nil) {
        
    }
    
    return _recordTableView;
}


#pragma mark - View Did Load

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor za_colorWithHex:0xe5e5e5]];
    
    [self setTitle:@"Record"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"nav_right_bar"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)rightClicked:(id)sender
{
    NSLog(@"Record");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}




#pragma mark - UITableViewDelegate


@end
