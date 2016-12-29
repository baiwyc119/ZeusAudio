//
//  ViewController.m
//  ZeusAudio
//
//  Created by lingchen on 12/21/16.
//  Copyright © 2016 LingChen. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+ZAHex.h"

#import "ZAWaveformView.h"
#import "ZANamePanel.h"
#import "ZAControlPanel.h"

#import <Masonry/Masonry.h>


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ZAWaveformView *waveformView;
@property (nonatomic, strong) ZANamePanel *nameView;
@property (nonatomic, strong) ZAControlPanel *controlView;

@property (nonatomic, strong) UITableView *recordTableView;

@end

@implementation ViewController

#pragma mark - UI Lazy Load
- (ZAWaveformView *)waveformView
{
    if (_waveformView == nil) {
        _waveformView = [[ZAWaveformView alloc] initWithFrame:CGRectZero];
        [_waveformView setBackgroundColor:[UIColor blackColor]];
    }
    
    return _waveformView;
}

- (ZANamePanel *)nameView
{
    if (_nameView == nil) {
        _nameView = [[ZANamePanel alloc] initWithFrame:CGRectZero];
        [_nameView setBackgroundColor:[UIColor blackColor]];
    }
    
    return _nameView;
}

- (ZAControlPanel *)controlView
{
    if (_controlView == nil) {
        _controlView = [[ZAControlPanel alloc] initWithFrame:CGRectZero];
        [_controlView setBackgroundColor:[UIColor blackColor]];
    }
    return _controlView;
}

- (UITableView *)recordTableView
{
    if (_recordTableView == nil) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_recordTableView setDelegate:self];
        [_recordTableView setDataSource:self];
        [_recordTableView setBackgroundColor:[UIColor za_colorWithHex:0xe5e5e5]];
    }
    
    return _recordTableView;
}

#pragma mark - Setup Navgation Bar
- (void)setupNavigationBar
{
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
    
    [self.waveformView startFetchingAudio];
    
}

#pragma mark - View Did Load

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor za_colorWithHex:0xe5e5e5]];
    [self setTitle:@"Record"];
    
    [self setupNavigationBar];
    
    [self.view addSubview:self.waveformView];
    [self.view addSubview:self.nameView];
    [self.view addSubview:self.controlView];
    [self.view addSubview:self.recordTableView];
    
    [self subviewsLayout];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Layout
- (void)subviewsLayout
{
    [self.waveformView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        
        make.top.mas_equalTo(self.view.mas_top).offset(64.f);
        make.height.mas_equalTo(243.f);
    }];
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        
        make.top.mas_equalTo(self.waveformView.mas_bottom);
        make.height.mas_equalTo(41.f);
        
    }];
    
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        
        make.top.mas_equalTo(self.nameView.mas_bottom);
        make.height.mas_equalTo(91.f);
    }];
    
    [self.recordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        
        make.top.mas_equalTo(self.controlView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);

    }];
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
