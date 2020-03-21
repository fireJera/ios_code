//
//  DownloadViewController.m
//  Concurrent
//
//  Created by Jeremy on 2020/3/13.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownLoadOperation.h"
#import "DownloadQueue.h"
#import "DownloadCell.h"

@interface DownloadViewController () <UITableViewDelegate, UITableViewDataSource, DownloadCellDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) DownloadQueue * downloadQueue;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_configView];
    [self p_configNav];
    [self p_configTask];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operationFinish) name:DownLoadOperationNotification object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)p_configView {
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = ({
        UITableView * tableView = [[UITableView alloc] init];
        [self.view addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        [tableView registerNib:[UINib nibWithNibName:@"DownloadCell" bundle:nil] forCellReuseIdentifier:@"DownloadCell"];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        tableView;
    });
}

- (void)p_configNav {
    UIBarButtonItem * addItem = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(addDownload)];
    UIBarButtonItem * pauseItem = [[UIBarButtonItem alloc] initWithTitle:@"all start" style:UIBarButtonItemStylePlain target:self action:@selector(pauseAllDownload:)];
    self.navigationItem.leftBarButtonItem = addItem;
    self.navigationItem.rightBarButtonItem = pauseItem;
}

- (void)p_configTask {
    _downloadQueue = [[DownloadQueue alloc] init];
//    _downloadQueue.downloadQueue.maxConcurrentOperationCount = NSIntegerMax;
//    NSInteger maxCount = _downloadQueue.downloadQueue.maxConcurrentOperationCount;
    for (int i = 0; i < 10; i++) {
        [self p_addDownload];
    }
    [_tableView reloadData];
}

- (void)p_addDownload {
    [_downloadQueue p_testAddDownload];
}

- (void)addDownload {
    [self p_addDownload];
    [_tableView reloadData];
}

- (void)pauseAllDownload:(UIBarButtonItem *)sender {
    if (_downloadQueue.isAllStarted) {
        [_downloadQueue pauseAll];
        [sender setTitle:@"all start"];
    }
    else {
        [_downloadQueue startAll];
        [sender setTitle:@"all pause"];
    }
    [_tableView reloadData];
}

- (void)pasueDownloadForIndex:(NSInteger)index {
    if (index < _downloadQueue.downloadQueue.operations.count) {
        DownLoadOperation * op = [_downloadQueue.downloadQueue.operations objectAtIndex:index];
        [_downloadQueue pauseOperation:op];
    }
    [_tableView reloadData];
}

- (void)startDownloadForIndex:(NSInteger)index {
    if (index < _downloadQueue.downloadQueue.operations.count) {
        DownLoadOperation * op = [_downloadQueue.downloadQueue.operations objectAtIndex:index];
        [_downloadQueue startOperation:op];
    }
    [_tableView reloadData];
}

- (void)removeDownloadForIndex:(NSInteger)index {
    id op = [_downloadQueue operationForIndex:index];
    [_downloadQueue removeOperation:op];
    [_tableView reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _downloadQueue.allDownloadCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadCell" forIndexPath:indexPath];
    if (indexPath.row < _downloadQueue.allDownloadCount) {
        id op = [_downloadQueue operationForIndex:indexPath.row];
        if ([op isKindOfClass:[DownLoadOperation class]]) {
            DownLoadOperation * operation = op;
            cell.downProgressView.progress = operation.progress;
            cell.downloadName.text = operation.name;
            cell.downloadPro.text = [NSString stringWithFormat:@"%.2f%%", operation.progress * 100];
            BOOL selected = operation.isReady && operation.executing;
            cell.pauseBtn.selected = selected;
            cell.pauseBtn.tag = indexPath.row;
            cell.delBtn.tag = indexPath.row;
            cell.pauseBtn.hidden = NO;
            cell.delegate = self;
            __weak typeof(cell) weakCell = cell;
            operation.progresBlock = ^(float progress, NSInteger time) {
                weakCell.downloadPro.text = [NSString stringWithFormat:@"%.2f%%", progress * 100];
                weakCell.downProgressView.progress = progress;
            };
        }
        else if ([op isKindOfClass:[FinishOperation class]]) {
            FinishOperation * operation = op;
            cell.downProgressView.progress = 1;
            cell.downloadName.text = operation.name;
            cell.downloadPro.text = @"100%";
            cell.pauseBtn.hidden = YES;
            cell.delBtn.tag = indexPath.row;
            cell.delegate = self;
        }
    }
//    cell.delBtn
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - notification

- (void)operationFinish {
    [_tableView reloadData];
}

@end
