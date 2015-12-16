//
//  HWDownSelectedView.m
//  HWDownSelectedTF
//
//  Created by HanWei on 15/12/15.
//  Copyright © 2015年 AndLiSoft. All rights reserved.
//

#import "HWDownSelectedView.h"

/// 箭头图片的宽度
CGFloat const ArrowImgViewWidth = 30.f;

/// 动画的时间
NSTimeInterval const animationDuration = .2f;

/// 分割线的颜色
#define kLineColor [UIColor colorWithRed:219/255.0 green:217/255.0 blue:216/255.0 alpha:1]

@interface HWDownSelectedView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *clickBtn;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, assign) BOOL isOpen;
/// 执行打开关闭动画是否结束
@property (nonatomic, assign) BOOL beDone;

@end

@implementation HWDownSelectedView


CGFloat angleValue(CGFloat angle) {
    return (angle * M_PI) / 180;
}

#pragma mark - life cycle 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup];
    }
    return self;
}

#pragma mark - overwrite
- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self _setupFrame];
}

#pragma mark - private
- (void)_setup
{
    /// 默认设置
    _font = [UIFont systemFontOfSize:14.f];
    _textColor = [UIColor blackColor];
    _textAlignment = NSTextAlignmentLeft;
    _arrowImgViewName = @"xiaolian.png";
    
    self.backgroundColor = [UIColor whiteColor];
    
    /// 默认不展开
    _isOpen = NO;
    
    /// 默认是完成动画的
    _beDone = YES;
    
    /// 默认显示下拉箭头
    _beShowArrowImgView = YES;
    
    /// 初始化UI
    [self addSubview:self.contentLabel];
    [self addSubview:self.arrowImgView];
    [self addSubview:self.clickBtn];
    
    /// 设置位置
    [self _setupFrame];
}

- (void)_setupFrame
{
    CGFloat SELFWIDTH, SELFHEIGHT;
    SELFWIDTH = self.frame.size.width;
    SELFHEIGHT = self.frame.size.height;
    
    /// 箭头 和 文本
    if (_beShowArrowImgView) {
        self.arrowImgView.frame = CGRectMake(SELFWIDTH - ArrowImgViewWidth, 0.0f, ArrowImgViewWidth, SELFHEIGHT);
        self.contentLabel.frame = CGRectMake(5, 2, SELFWIDTH - ArrowImgViewWidth - 10, SELFHEIGHT-4);
    } else {
        self.arrowImgView.frame = CGRectZero;
        self.contentLabel.frame = CGRectMake(5, 2, SELFWIDTH - 10, SELFHEIGHT-4);
    }
    
    /// 按钮
    self.clickBtn.frame = CGRectMake(0, 0, SELFWIDTH, SELFHEIGHT);
    
    /// 列表视图
    self.listTableView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + SELFHEIGHT, SELFWIDTH, 0);
    
    self.listTableView.rowHeight = SELFHEIGHT;

}

#pragma mark - action
- (void)clickBtnClicked
{
    if (!_beDone) return;
    
    /// 关闭页面上其他下拉控件
    for (UIView *subview in self.superview.subviews) {
        if ([subview isKindOfClass:[HWDownSelectedView class]] && subview != self) {
            HWDownSelectedView *donwnSelectedView = (HWDownSelectedView *)subview;
            if (donwnSelectedView.isOpen) {
                [donwnSelectedView close];
            }
        }
    }

    if (_isOpen) {
        [self close];
    } else {
        [self show];
    }
}

#pragma mark - public
- (void)show
{
    if (_isOpen || _listArray.count == 0) return;

    _beDone = NO;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
    
                         if (self.listArray.count > 0) {
                             [self.listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                       atScrollPosition:UITableViewScrollPositionTop
                                                               animated:YES];
                         }
                         [self.superview addSubview:self.listTableView];
                         /// 避免被其他子视图遮盖住
                         [self.superview bringSubviewToFront:self.listTableView];
                         
                         CGRect frame = self.listTableView.frame;
                         NSInteger count = MIN(4, self.listArray.count);
                         frame.size.height = count * self.frame.size.height;
                         
                         /// 防止超出屏幕
                         if (frame.origin.y + frame.size.height > [UIScreen mainScreen].bounds.size.height) {
                             frame.size.height -= frame.origin.y + frame.size.height - [UIScreen mainScreen].bounds.size.height;
                         }
                         [self.listTableView setFrame:frame];
                         
                         /// 旋转箭头
                         if (_beShowArrowImgView) {
                             self.arrowImgView.transform = CGAffineTransformRotate(self.arrowImgView.transform, angleValue(180));
                         }
                     }
                     completion:^(BOOL finished) {

                         _beDone = YES;
                         _isOpen = YES;

                     }
     ];
}

- (void)close
{
    if (!_isOpen) return;
    
    _beDone = NO;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect frame = self.listTableView.frame;
                         frame.size.height = 0.f;
                         [self.listTableView setFrame:frame];
                         
                         /// 旋转箭头
                         if (_beShowArrowImgView) {
                             self.arrowImgView.transform = CGAffineTransformRotate(self.arrowImgView.transform, angleValue(180));
                         }
                     }
                     completion:^(BOOL finished) {
                         
                         if (self.listTableView.superview) [self.listTableView removeFromSuperview];
                         
                         _beDone = YES;
                         _isOpen = NO;
                         
                     }
     ];

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, self.frame.size.width-10, self.frame.size.height-4)];
        contentLable.tag = 1000;
        contentLable.textColor = _textColor;
        contentLable.font = _font;
        [cell addSubview:contentLable];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = kLineColor;
        lineView.frame = CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5);
        [cell addSubview:lineView];
    }
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:1000];
    contentLabel.text = _listArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.contentLabel.text = [_listArray objectAtIndex:indexPath.row];
    [self close];
    if ([self.delegate respondsToSelector:@selector(downSelectedView:didSelectedAtIndex:)]) {
        [self.delegate downSelectedView:self didSelectedAtIndex:indexPath];
    }
}


#pragma mark - setter
- (void)setFont:(UIFont *)font
{
    _font = font;
    self.contentLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.contentLabel.textColor = textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    self.contentLabel.textAlignment = textAlignment;
}

- (void)setBeShowArrowImgView:(BOOL)beShowArrowImgView
{
    _beShowArrowImgView = beShowArrowImgView;
    [self _setupFrame];
}

- (void)setListArray:(NSArray *)listArray
{
    _listArray = listArray;
    
    [self.listTableView reloadData];
}

#pragma mark - getter
- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = _textColor;
        _contentLabel.font = _font;
        _contentLabel.numberOfLines = 1;
        _contentLabel.textAlignment = _textAlignment;
    }
    return _contentLabel;
}

- (UIButton *)clickBtn
{
    if (!_clickBtn) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.layer.borderColor = kLineColor.CGColor;
        _clickBtn.layer.borderWidth = 0.5f;
        [_clickBtn addTarget:self action:@selector(clickBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickBtn;
}

- (UIImageView *)arrowImgView
{
    if (!_arrowImgView) {
        _arrowImgView = [UIImageView new];
    }
    _arrowImgView.image = [UIImage imageNamed:_arrowImgViewName];
    return _arrowImgView;
}

- (UITableView *)listTableView
{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.bounces = NO;
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.separatorColor = kLineColor;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _listTableView;
}
@end
