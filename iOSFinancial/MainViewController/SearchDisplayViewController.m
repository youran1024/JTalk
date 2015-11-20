
//
//  SearchDisplayViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/11/17.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "SearchDisplayViewController.h"
#import "TalkViewController.h"
#import "LoadMoreCell.h"
#import "CustomerSearchBarView.h"


NSString *groupPeople;

@interface SearchDisplayViewController () <UITextFieldDelegate>

@property (nonatomic, strong)   NSArray *signArray;
@property (nonatomic, strong)   HTBaseRequest *lastRequest;
@property (nonatomic, strong)   CustomerSearchBarView *searchBarView;

@end

@implementation SearchDisplayViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = self.searchBarView;
    [self.searchBarView.searchField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidChange
{
    if (self.searchBarView.searchField.text.length == 0) {
        self.signArray = nil;
        [self.tableView reloadData];
    }
}

#pragma mark - 
#pragma mark searchBar

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    searchStr = [searchStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (searchStr.length) {
        [self requestSearchDisplayResult:searchStr];
    }else {
        self.signArray = nil;
        [self.tableView reloadData];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *searchStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self createGroupWithTitle:searchStr];
    
    return YES;
}

- (void)requestSearchDisplayResult:(NSString *)keyword
{
    HTBaseRequest *request = [HTBaseRequest userSearchOnTime:keyword];
    
    [_lastRequest stop];
    _lastRequest = request;
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        NSDictionary *dict = request.responseJSONObject;
        NSInteger code = [[dict stringIntForKey:@"code"] integerValue];
        
        if (code == 200) {
            [self handleRequestArray:[dict arrayForKey:@"result"] andKeyWord:keyword];
        }
        
    }];
}

- (void)handleRequestArray:(NSArray *)array andKeyWord:(NSString *)keyword
{
    BOOL isFindSame = NO;
    
    for (NSDictionary *dict in array) {
        NSString *string = [dict stringForKey:@"group_name"];
        
        if ([string isEqualToString:keyword]) {
            isFindSame = YES;
            break;
        }
    }
    
    if (!isFindSame) {
        NSMutableArray *mutArray = [NSMutableArray arrayWithArray:array];
        
        NSDictionary *dict = @{@"group_name" : keyword, @"group_user_count" : @(1)};
        [mutArray insertObject:dict atIndex:0];
        array = [NSArray arrayWithArray:mutArray];
    }
    
    self.signArray = array;
    [self.tableView reloadData];
}

#pragma mark - 
#pragma mark TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.signArray.count == 0) {
        return 1;
    }
    
    return self.signArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    if (self.signArray.count == 0) {
        
        LoadMoreCell *cell = [LoadMoreCell newCell];
        cell.cellState = CellStateHaveNoMore;
        
        
        return cell;
    }
    
    HTBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[HTBaseCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict = [self.signArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict stringForKey:@"group_name"];
    cell.detailTextLabel.text = HTSTR(@"%@人", [dict stringIntForKey:@"group_user_count"]);
     
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *word = [[self.signArray objectAtIndex:indexPath.row] stringForKey:@"group_name"];
    [self createGroupWithTitle:word];
}

#pragma mark - Show Talk ViewController

//  MARK:创建并加入聊天室
- (void)createGroupWithTitle:(NSString *)title
{
    if (isEmpty(title)) {
        return;
    }
    
    [self showHudWaitingView:PromptTypeWating];
    HTBaseRequest *request = [HTBaseRequest createGroupWithGroupName:title];
    
    __weakSelf;
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *dict = request.responseJSONObject;
        NSInteger code = [[dict stringIntForKey:@"code"] integerValue];
        dict = [dict dictionaryForKey:@"result"];
        groupPeople = [dict stringForKey:@"group_user_count"];
        if (code == 200) {
            [weakSelf joinGroupByGroupId:[title toMD5] andGroupName:title];
        }
    }];
}

//  MARK:记录用户点击过的标签
- (void)recoderUserClickWord:(NSString *)word
{
    HTBaseRequest *request = [HTBaseRequest recoderUserSearchWord:word];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

//  加入群组
- (void)joinGroupByGroupId:(NSString *)groupId andGroupName:(NSString *)groupName
{
    __weakSelf;
    [[RCIMClient sharedRCIMClient] joinGroup:groupId groupName:groupName success:^{
        [weakSelf removeHudInManaual];
        
        /* 接口已经停止使用 */
        //[weakSelf recoderUserClickWord:groupName];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf showTalkListViewController:groupName];
        });
        
        /*
         //  同步群组数据
         RCGroup *group = [[RCGroup alloc] initWithGroupId:[groupName toMD5] groupName:groupName portraitUri:nil];
         [[RCIMClient sharedRCIMClient] syncGroups:@[group] success:^{
         // success
         
         } error:^(RCErrorCode status) {
         
         }];
         
         */
        
    } error:^(RCErrorCode status) {
        [weakSelf showHudErrorView:@"加入失败，请重试!"];
    }];
}

//  MARK:聊天室Controller
- (void)showTalkListViewController:(NSString *)title
{
    TalkViewController *conversationVC = [[TalkViewController alloc] init];
    conversationVC.conversationType = ConversationType_GROUP;  //会话类型，这里设置为 PRIVATE 即发起单聊会话
    conversationVC.targetId = [title toMD5]; // 接收者的 targetId，这里为举例
    conversationVC.userName = title;
    conversationVC.title = title; // 会话的 title
    conversationVC.groupTitle = title;
    conversationVC.groupPeople = groupPeople;
    
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (CustomerSearchBarView *)searchBarView
{
    if (!_searchBarView) {
        _searchBarView = [CustomerSearchBarView xibView];
        _searchBarView.searchDelegate = self;
        
        __weakSelf;
        [_searchBarView setTouchBlock:^{
            [weakSelf dismissViewController];
        }];
    }

    return _searchBarView;
}

@end
