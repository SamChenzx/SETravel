//
//  KSCaseCoverageListView.m
//  SETravel
//
//  Created by Sam Chen on 2021/11/30.
//

#import "KSCaseCoverageListView.h"
#import "KSCoverageManager.h"
#import <Masonry/Masonry.h>
#define KSCornerRadius4 4

static NSString *const KSCaseCoverageButtonTitle = @"上传";
static NSString *const KSCaseCoverageSearchHint = @"输入case名搜索";
static NSString *const KSCaseCoverageReuseIdentifier = @"KSCaseCoverageReuseIdentifier";
static NSString *const KSCaseCoveragePlaceholder = @"必填项：测试人邮箱前缀，如zhangsan";
static const CGFloat KSCaseCoverageButtonWidth = 60;
static const CGFloat KSCaseCoverageButtonHeight = 30;

@interface KSCaseCoverageCell : UITableViewCell


@property (nonatomic, strong) KSCaseModel *model;
@property (nonatomic, strong) UILabel *caseNameLabel;
@property (nonatomic, strong) UIButton *uploadButton;
@property (nonatomic, copy) void(^tapCaseBlock)(void);

@end

@implementation KSCaseCoverageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self.contentView addSubview:self.caseNameLabel];
    [self.contentView addSubview:self.uploadButton];
    [self.caseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.uploadButton.mas_left);
    }];
    [self.uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(KSCaseCoverageButtonWidth, KSCaseCoverageButtonHeight));
    }];
}

- (void)didTapUploadButton:(UIButton *)button {
    if (self.tapCaseBlock) {
        self.tapCaseBlock();
    }
}

#pragma mark -- setter/getter

- (void)setModel:(KSCaseModel *)model {
    _model = model;
    self.caseNameLabel.text = model.caseName;
}

- (UILabel *)caseNameLabel {
    if (!_caseNameLabel) {
        _caseNameLabel = [[UILabel alloc] init];
        _caseNameLabel.text = @"test case";
        _caseNameLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _caseNameLabel;
}

- (UIButton *)uploadButton {
    if (!_uploadButton) {
        _uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _uploadButton.layer.cornerRadius = KSCornerRadius4;
        [_uploadButton setTitle:KSCaseCoverageButtonTitle forState:UIControlStateNormal];
        [_uploadButton addTarget:self action:@selector(didTapUploadButton:) forControlEvents:UIControlEventTouchUpInside];
        _uploadButton.backgroundColor = [UIColor lightGrayColor];
    }
    return _uploadButton;
}

@end

@interface KSCaseCoverageListView () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UISearchBarDelegate>

@property (nonatomic, copy) NSArray<KSCaseModel *> *caseList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UISearchBar *caseSearchBar;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIAlertController *caseAlert;
@property (nonatomic, strong) KSCaseModel *selectedCaseModel;

@end

@implementation KSCaseCoverageListView

- (instancetype)initWithFrame:(CGRect)frame caseList:(NSArray<KSCaseModel *> *)caseList {
    if (self = [super initWithFrame:frame]) {
        self.caseList = caseList;
        [self commonInit];
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.headerView addSubview:self.caseSearchBar];
    UIEdgeInsets padding = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.caseSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headerView).with.insets(padding);
    }];
}

- (void)dismiss {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)didTap:(UITapGestureRecognizer *)tap {
    if ([self.caseSearchBar isFirstResponder]) {
        [self.caseSearchBar resignFirstResponder];
        return;
    }
    [self dismiss];
}

- (void)showUploadAlertWithCase:(KSCaseModel *)caseModel {
    self.selectedCaseModel = caseModel;
    self.caseAlert.message = caseModel.caseName;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.caseAlert animated:NO completion:nil];
}

#pragma mark -- setter/getter

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        _tapGesture.delegate = self;
    }
    return _tapGesture;
}

- (UISearchBar *)caseSearchBar {
    if (!_caseSearchBar) {
        _caseSearchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _caseSearchBar.placeholder = KSCaseCoverageSearchHint;
        _caseSearchBar.delegate = self;
    }
    return _caseSearchBar;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(100, 20, 50, 20)) style:UITableViewStylePlain];
        [_tableView registerClass:KSCaseCoverageCell.class forCellReuseIdentifier:KSCaseCoverageReuseIdentifier];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }
    return _tableView;
}

- (UIAlertController *)caseAlert {
    if (!_caseAlert) {
        _caseAlert = [UIAlertController alertControllerWithTitle:@"测试信息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [_caseAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"测试同学邮箱前缀";
            textField.textAlignment = NSTextAlignmentNatural;
        }];
        __weak typeof(self)weakSelf = self;
        UIAlertAction *failAction = [UIAlertAction actionWithTitle:@"测试失败" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakSelf)self = weakSelf;
            UITextField *textField = self.caseAlert.textFields.firstObject;
            NSString *userName = textField.text ?: @"";
            NSMutableDictionary *caseInfoDic = [NSMutableDictionary dictionary];
            [caseInfoDic setObject:userName forKey:KSCoverageUserInfo];
            [caseInfoDic setObject:self.selectedCaseModel.caseId forKey:KSCoverageCaseID];
            [caseInfoDic setObject:self.selectedCaseModel.planId forKey:KSCoveragePlanID];
            [caseInfoDic setObject:@(KSCaseCoverageResultFail) forKey:KSCoverageCaseResult];
            if (self.uploadCoverageBlock) {
                self.uploadCoverageBlock(caseInfoDic);
            }
        }];
        UIAlertAction *passAction = [UIAlertAction actionWithTitle:@"测试通过" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakSelf)self = weakSelf;
            UITextField *textField = self.caseAlert.textFields.firstObject;
            NSString *userName = textField.text ?: @"";
            NSMutableDictionary *caseInfoDic = [NSMutableDictionary dictionary];
            [caseInfoDic setObject:userName forKey:KSCoverageUserInfo];
            [caseInfoDic setObject:self.selectedCaseModel.caseId forKey:KSCoverageCaseID];
            [caseInfoDic setObject:self.selectedCaseModel.planId forKey:KSCoveragePlanID];
            [caseInfoDic setObject:@(KSCaseCoverageResultPass) forKey:KSCoverageCaseResult];
            if (self.uploadCoverageBlock) {
                self.uploadCoverageBlock(caseInfoDic);
            }
        }];
        [_caseAlert addAction:failAction];
        [_caseAlert addAction:passAction];
    }
    return _caseAlert;
}

#pragma mark -- delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(self.tableView.frame, location)) {
        return NO;
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (!searchBar.text.length) {
        return;
    }
    NSString *searchKey = searchBar.text;
    NSError *error = NULL;
    NSString *patternString = [NSString stringWithFormat:@".*(%@).*", searchKey];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patternString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    for (NSInteger index = 0; index < self.caseList.count; index++) {
        NSString *searchText = self.caseList[index].caseName;
        NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
        if (result) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [self.caseSearchBar resignFirstResponder];
            break;
        }
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row >= self.caseList.count) {
        return nil;
    }
    KSCaseCoverageCell *cell = [tableView dequeueReusableCellWithIdentifier:KSCaseCoverageReuseIdentifier];
    if (!cell) {
        cell = [[KSCaseCoverageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KSCaseCoverageReuseIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self)weakSelf = self;
    __weak typeof(cell)weakCell = cell;
    cell.tapCaseBlock = ^{
        __strong typeof(weakSelf)self = weakSelf;
        __strong typeof(weakCell)cell = weakCell;
        [self showUploadAlertWithCase:cell.model];
    };
    cell.model = self.caseList[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.caseList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        [self.headerView setFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
        return self.headerView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 50.0f;
    }
    return 0.01;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.caseSearchBar resignFirstResponder];
}

@end
