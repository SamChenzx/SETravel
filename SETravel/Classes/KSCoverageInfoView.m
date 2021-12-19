//
//  KSCoverageInfoView.m
//  gifDebugHelperModule
//
//  Created by Sam Chen on 2021/10/15.
//

//#if KSIsDebugging && KSCOVERAGE

#import "KSCoverageInfoView.h"
#import "KSCoverageManager.h"
#import <Masonry/Masonry.h>
//#import <KwaiUIResource/KSCornerScheme.h>
#define KSCornerRadius4 4

@interface KSCoverageInfoView () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *caseTextField;
@property (nonatomic, strong) UITableView *caseTypeTableView;
@property (nonatomic, strong) UISwitch *resetSwitch;
@property (nonatomic, strong) UISwitch *disableSwitch;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, copy) NSArray *caseTypeNames;
@property (nonatomic, copy) NSArray *settingTypeNames;
@property (nonatomic, assign) NSInteger currentCaseIndex;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, copy) NSArray *executeTypeNames;
@property (nonatomic, strong) KSCoverageSwitchStates *switchStates;

@end

static NSString *const coverageInfoTitle = @"测试信息";
static NSString *const usernameTextFieldPlaceholder = @"必填项：测试人邮箱前缀，如zhangsan";
static NSString *const caseTextFieldPlaceholder = @"测试用例";
static NSString *const resetCellTitle = @"重置计数器";
static NSString *const disableAutoUploadCellTitle = @"禁用覆盖率自动上传";
static NSString *const caseCellIdentifier = @"caseCellIdentifier";
static NSString *const settingCellIdentifier = @"settingCellIdentifier";

@implementation KSCoverageInfoView

- (instancetype)initWithFrame:(CGRect)frame switchStates:(KSCoverageSwitchStates *)switchStates {
    self = [super initWithFrame:frame];
    if (self) {
        self.switchStates = switchStates;
        self.currentCaseIndex = 0;
        [self addGestureRecognizer:self.tapGesture];
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self addSubview:self.containerView];
    [self.resetSwitch setOn:self.switchStates.resetSwitchState];
    [self.disableSwitch setOn:self.switchStates.disableSwitchState];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.usernameTextField];
    [self.containerView addSubview:self.caseTextField];
    [self.containerView addSubview:self.caseTypeTableView];
    [self.containerView addSubview:self.cancelButton];
    [self.containerView addSubview:self.confirmButton];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(@430);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView.mas_top).offset(10);
        make.left.mas_equalTo(self.containerView.mas_left).offset(10);
        make.right.mas_equalTo(self.containerView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.containerView.mas_left).offset(10);
        make.right.mas_equalTo(self.containerView.mas_right).offset(-10);
        make.height.mas_equalTo(25);
    }];
    [self.caseTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.usernameTextField.mas_bottom).offset(5);
        make.left.mas_equalTo(self.containerView.mas_left).offset(10);
        make.right.mas_equalTo(self.containerView.mas_right).offset(-10);
        make.height.mas_equalTo(25);
    }];
    [self.caseTypeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.caseTextField.mas_bottom).offset(5);
        make.left.mas_equalTo(self.containerView.mas_left).offset(10);
        make.right.mas_equalTo(self.containerView.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-50);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.caseTypeTableView.mas_bottom).offset(5);
        make.width.mas_equalTo(@80);
        make.right.mas_equalTo(self.containerView.mas_centerX).offset(-10);
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-10);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.caseTypeTableView.mas_bottom).offset(5);
        make.width.mas_equalTo(@80);
        make.left.mas_equalTo(self.containerView.mas_centerX).offset(10);
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-10);
    }];
}

- (void)didChangeSwitchState:(UISwitch *)swi {
    if ([swi isEqual:self.disableSwitch]) {
        if (self.didSettingDisableBlock) {
            self.didSettingDisableBlock(swi.isOn);
        }
        self.switchStates.disableSwitchState = swi.isOn;
    } else if ([swi isEqual:self.resetSwitch]) {
        self.switchStates.resetSwitchState = swi.isOn;
    }
}

- (void)didClickCancel:(UIButton *)button {
    if (self.didCancelBlock) {
        self.didCancelBlock();
    }
    [self dismiss];
}

- (void)didClickConfirm:(UIButton *)button {
    if (self.didConfirmBlock) {
        NSString *username = self.usernameTextField.text;
        if (!username.length) {
            self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:usernameTextFieldPlaceholder attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
            return;
        }
        if (self.currentCaseIndex >= self.executeTypeNames.count) {
            return;
        }
        NSString *caseName = self.caseTextField.text ?: @"";
        NSString *excuteTypeName = self.executeTypeNames[self.currentCaseIndex];
        NSMutableDictionary *caseInfoDic = [NSMutableDictionary dictionary];
        [caseInfoDic setObject:username forKey:KSCoverageUserInfo];
        [caseInfoDic setObject:caseName forKey:KSCoverageCaseInfo];
        [caseInfoDic setObject:excuteTypeName forKey:KSCoverageTypeInfo];
        self.didConfirmBlock([caseInfoDic copy], self.resetSwitch.isOn);
    }
    [self dismiss];
}

- (void)dismiss {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)resignFirstResponderIfNeed {
    if (self.usernameTextField.isFirstResponder) {
        [self.usernameTextField resignFirstResponder];
    }
    if (self.caseTextField.isFirstResponder) {
        [self.caseTextField resignFirstResponder];
    }
}

- (void)didTap:(UITapGestureRecognizer *)tap {
    [self resignFirstResponderIfNeed];
}

#pragma mark --setter/getter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = KSCornerRadius4;
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = coverageInfoTitle;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UITextField *)usernameTextField {
    if (!_usernameTextField) {
        _usernameTextField = [[UITextField alloc] init];
        _usernameTextField.layer.cornerRadius = KSCornerRadius4;
        _usernameTextField.layer.borderWidth = 0.5;
        _usernameTextField.layer.borderColor = [UIColor blackColor].CGColor;
        _usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:usernameTextFieldPlaceholder attributes:@{NSForegroundColorAttributeName : [[UIColor blackColor] colorWithAlphaComponent:0.3]}];
        _usernameTextField.delegate = self;
    }
    return _usernameTextField;
}

- (UITextField *)caseTextField {
    if (!_caseTextField) {
        _caseTextField = [[UITextField alloc] init];
        _caseTextField.layer.cornerRadius = KSCornerRadius4;
        _caseTextField.layer.borderWidth = 0.5;
        _caseTextField.layer.borderColor = [UIColor blackColor].CGColor;
        _caseTextField.placeholder = caseTextFieldPlaceholder;
        _caseTextField.delegate = self;
    }
    return _caseTextField;
}

- (UITableView *)caseTypeTableView {
    if (!_caseTypeTableView) {
        _caseTypeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _caseTypeTableView.delegate = self;
        _caseTypeTableView.dataSource = self;
        _caseTypeTableView.estimatedRowHeight = 0;
        _caseTypeTableView.estimatedSectionFooterHeight = 0;
        _caseTypeTableView.estimatedSectionHeaderHeight = 0;
    }
    return _caseTypeTableView;
}

- (UISwitch *)resetSwitch {
    if (!_resetSwitch) {
        _resetSwitch = [[UISwitch alloc] init];
        [_resetSwitch addTarget:self action:@selector(didChangeSwitchState:) forControlEvents:UIControlEventValueChanged];
    }
    return _resetSwitch;
}

- (UISwitch *)disableSwitch {
    if (!_disableSwitch) {
        _disableSwitch = [[UISwitch alloc] init];
        [_disableSwitch addTarget:self action:@selector(didChangeSwitchState:) forControlEvents:UIControlEventValueChanged];
    }
    return _disableSwitch;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:@"取消" attributes:@{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:16]}];
        _cancelButton.backgroundColor = [UIColor lightGrayColor];
        [_cancelButton setAttributedTitle:attrTitle forState:UIControlStateNormal];
        _cancelButton.layer.cornerRadius = KSCornerRadius4;
        _cancelButton.clipsToBounds = YES;
        [_cancelButton addTarget:self action:@selector(didClickCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:@"确认" attributes:@{NSForegroundColorAttributeName : [UIColor blueColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:16]}];
        _confirmButton.backgroundColor = [UIColor lightGrayColor];
        [_confirmButton setAttributedTitle:attrTitle forState:UIControlStateNormal];
        _confirmButton.layer.cornerRadius = KSCornerRadius4;
        _confirmButton.clipsToBounds = YES;
        [_confirmButton addTarget:self action:@selector(didClickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        _tapGesture.delegate = self;
    }
    return _tapGesture;
}

- (NSArray *)caseTypeNames {
    if (!_caseTypeNames) {
        _caseTypeNames = @[@"QA手动", @"RD手动", @"UI自动化", @"UI冒烟测试"];
    }
    return _caseTypeNames;
}

- (NSArray *)executeTypeNames {
    if (!_executeTypeNames) {
        _executeTypeNames = @[@"manual_qa", @"manual_rd", @"automated_ui", @"automated_st"];
    }
    return _executeTypeNames;
}

- (NSArray *)settingTypeNames {
    if (!_settingTypeNames) {
        _settingTypeNames = @[resetCellTitle, disableAutoUploadCellTitle];
    }
    return _settingTypeNames;
}

#pragma mark --tableView delegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row >= self.caseTypeNames.count) {
            return nil;
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:caseCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:caseCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = self.caseTypeNames[indexPath.row];
        if (self.currentCaseIndex == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row >= self.settingTypeNames.count) {
            return nil;
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:settingCellIdentifier];
            if (indexPath.row == 0) {
                cell.accessoryView = self.resetSwitch;
                cell.textLabel.text = resetCellTitle;
            } else if (indexPath.row == 1) {
                cell.accessoryView = self.disableSwitch;
                cell.textLabel.text = disableAutoUploadCellTitle;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.caseTypeNames.count;
    } else {
        return self.settingTypeNames.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == self.currentCaseIndex) {
            return;
        }
        self.currentCaseIndex = indexPath.row;
        [self.caseTypeTableView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self resignFirstResponderIfNeed];
}

#pragma mark --gesture

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.containerView];
    if (CGRectContainsPoint(self.caseTypeTableView.frame, location)) {
        return NO;
    }
    return YES;
}

#pragma mark

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length) {
        if ([textField isEqual:self.usernameTextField]) {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:usernameTextFieldPlaceholder attributes:@{NSForegroundColorAttributeName : [[UIColor blackColor] colorWithAlphaComponent:0.3]}];
        } else if ([textField isEqual:self.caseTextField]) {
            textField.placeholder = caseTextFieldPlaceholder;
        }
    }
}

@end

//#endif

