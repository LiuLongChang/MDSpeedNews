//
//  MDShowDownView.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/20.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDShowDownView.h"

#import "MDDeleteButton.h"

@implementation MDShowDownView
{
    //  原始 Frame
    CGRect _originFrame;
    // 竖直方向 的 坐标
    CGFloat _originY;
    //_scrollView 添加 可以添加栏目的 button
    UIScrollView *_scrollView;
    // 正在展示 分类的数组
    NSMutableArray *_showingArray;
    // 可以添加 的 分类数组
    NSMutableArray *_canAddArray;
    
    // button 宽度
    CGFloat _buttonWidth;
    
    // button 高度
    CGFloat _buttonHeight;
    
    // 第一列的Button和 边界的距离
    CGFloat _leading;
    // Button 水平方向的间距
    CGFloat _horSpacing;
    //  Button 竖直方向 的间距
    CGFloat _verSpacing;
    
    //  添加 分类的 标签
    UILabel *_addLabel ;
    
    // 是否 是删除状态
    BOOL _isDeleteing;
    // 上面 第一个分类Button的 坐标y
    CGFloat _upBeginY;
    //  下面第一个分类Button 的坐标y
    CGFloat _downBeginY;
    
    //  可以 显示的分类 最大数
    NSUInteger _canAddMaxSumNum;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 最多可以显示 24 个 分类
        _canAddMaxSumNum = 24;
        
        //  初始化  非 删除状态
        _isDeleteing = NO;
        
        _showingArray = [NSMutableArray array];
        
        _canAddArray = [NSMutableArray array];
        // 记录 初始的Frame
        _originFrame = frame;
        // 初始化 各种变量
        _buttonWidth = MDXFrom6(74.0f) ;
        _buttonHeight = MDXFrom6(34.0f)    ;
        _leading =  MDXFrom6(15.0f);
        _horSpacing = (self.frame.size.width - 4 * _buttonWidth - _leading * 2) / 3.0f;
        _verSpacing = MDXFrom6(15.0f) ;
        
        
        // 记录 坐标
        _upBeginY = _verSpacing;
    }
    return self;
}

-(void)hide
{
    self.isAnimating  = YES;
    
    [UIView animateWithDuration:.3 animations:^{
        self.frame = _originFrame;
    }completion:^(BOOL finished) {
        // 动画执行完毕
        self.isAnimating = NO;
    }];
}

-(void)show
{
    if (_isDeleteing == YES)
    {
        // 是 删除状态 恢复 为正常 状态
        [self showDeletStatus:nil];
    }
    
    self.isAnimating  = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha =1.0;
        self.frame = self.showFrame;
    }completion:^(BOOL finished) {
        // 动画 执行完毕
        self.isAnimating = NO;
    }];
}

// Setter
-(void)setShowFrame:(CGRect)showFrame
{
    _showFrame = showFrame;
    
    // 给 ScrollView 设置 height
    
    _scrollView.frame = CGRectMake(0, _originY, self.frame.size.width, self.showFrame.size.height - _originY);
}

-(MDDeleteButton * )buttonWithFrame:(CGRect)frame
{
    MDDeleteButton *button =[MDDeleteButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:frame];
    // 删除Button的点击方法
    [button.smallDeleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    // 默认 是 正常 状态
    button.deleteStatus = MDDeleteButtonStatusNomal;
    
//    [button setImage:[UIImage imageNamed:@"column.png"] forState:UIControlStateNormal];
    //  把图片 铺满 在 Button上
    [button setBackgroundImage:[UIImage imageNamed:@"column.png"] forState:UIControlStateNormal];
    
    
    [button setTitleColor:RGB_MD(51., 51., 51.) forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    
    return button;
    
}


-(void)addShowingCategoryWithTitle:(NSString *)title
{
               // 记录 Button 的坐标y
    _originY = _verSpacing + (_buttonHeight + _verSpacing) * (_showingArray.count / 4);
    
    MDDeleteButton *button =[self buttonWithFrame:CGRectMake(_leading + (_buttonWidth + _horSpacing) * (_showingArray.count % 4), _originY, _buttonWidth, _buttonHeight)];
    
    if (_showingArray.count == 0)
    {// 不可以 被删除
    button.deleteStatus = MDDeleteButtonStatusNeverDelete;
    }

             //  点击 方法
            [button addTarget:self action:@selector(clickUpButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
    
            [button setTitle:title forState:UIControlStateNormal];
            
            [self addSubview:button];
    // 数组 记录Button
    [_showingArray addObject:button];
}

-(void)addCategoryLabelAndScrollView
{
#pragma mark 添加栏目标签
    
    _originY += _buttonHeight + _verSpacing;
    
    _addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _originY, self.frame.size.width, MDXFrom6(43.0))];
    
    
    
    _addLabel.text = [NSString stringWithFormat:@"   点击添加栏目"];
    
//    _addLabel.font = [UIFont systemFontOfSize:MDXFrom6(17.0)];
    
    // 各种屏幕 单独 设置  进行适配
    _addLabel.font = [UIFont systemFontOfSize:IPhone4_5_6_6P(16, 16, 17, 18)];
    
//    NSUInteger iphoneInt = IPhone4_5_6_6P(1, 2, 3, 4);
//    
//    if (iphoneInt == 1)
//    {
//        
//    }else if(iphoneInt == 2)
//    {
//        
//    }
    
    _addLabel.textColor = RGB_MD(153.0, 153.0, 153.0);
    
    _addLabel.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_addLabel];
    
    _originY += _addLabel.frame.size.height ;
    //可以添加的栏目Button 放在ScrollView 上，防止超出屏幕
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _originY, self.frame.size.width, self.showFrame.size.height - _originY)];
    //  透明
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_scrollView];
    //记录 坐标
    _downBeginY =  _verSpacing;
}

-(void)addCanAddCategoryWithTitle:(NSString *)title
{
        MDDeleteButton *button = [self buttonWithFrame:CGRectMake(_canAddArray.count % 4 *(_buttonWidth + _horSpacing) + _leading, _canAddArray.count / 4 * (_buttonHeight + _verSpacing) + _verSpacing, _buttonWidth, _buttonHeight)];
    //  点击 添加 栏目Button 的方法
    [button addTarget:self action:@selector(clickDownButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
    
        [button setTitle:title forState:UIControlStateNormal];
        
        [_scrollView addSubview:button];
    
    [_canAddArray addObject:button];
    
    // 设置 scrollView 的显示范围
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, button.frame.origin.y + button.frame.size.height + _verSpacing);
}

-(void)clickUpButtonsAction:(MDDeleteButton *)button
{
    if (_isDeleteing == YES)
    {
        NSLog(@"删除状态，不做响应");
        return;
    }
    
    //  取出 数组中 button 所在 的下标
    NSUInteger arrayIndex = [_showingArray indexOfObject:button];
    //  传值
    if (self.clickedButtonIndex)
    {
        self.clickedButtonIndex(arrayIndex + 1);
    }
    
    NSLog(@"切换栏目Button被点击");
}

-(void)clickDownButtonsAction:(MDDeleteButton *)button
{
    
    if (_showingArray.count >= _canAddMaxSumNum)
    {
        [self showAlertViewWithMessage:@"添加满了！"];
        return;
    }
    
    NSLog(@"添加栏目Button被点击");
    // 取出 点击Button的 下标
    NSUInteger clickIndex = [_canAddArray indexOfObject:button];
    //  传值，把添加的 栏目的 index 传出去
    if (self.clickedAddButtonIndex)
    {
        self.clickedAddButtonIndex(clickIndex + 1);
    }
    
    
    // 从数组里移除
    [_canAddArray removeObject:button];
    // 移除方法
    [button removeTarget:self action:@selector(clickDownButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
    // 添加 到数组
    [_showingArray addObject:button];
    
    // 交换 父View
    [self addSubview:button];
    
    //  添加 新的方法
    [button addTarget:self action:@selector(clickUpButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
    // button 在新的View 上初始位置
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y + _scrollView.frame.origin.y  -  _scrollView.contentOffset.y, _buttonWidth, _buttonHeight);
    
    //  设置新的frame，和 初始化 设置 Frame 方法是一样的
    _originY =  _verSpacing + (_buttonHeight + _verSpacing) * ((_showingArray.count - 1) / 4);
    
    [UIView animateWithDuration:.4 animations:^{
        // 设置 Button 的frame
//        CGFloat x
        button.frame = CGRectMake(_leading + (_buttonWidth + _horSpacing) * ((_showingArray.count - 1) % 4),_originY, _buttonWidth, _buttonHeight);
        
        _originY += _buttonHeight + _verSpacing;

        // 标签 的frame
        _addLabel.frame =   CGRectMake(0, _originY, self.frame.size.width, _addLabel.frame.size.height);
        
        _originY += _addLabel.frame.size.height;
        // scrollView  的Frame
        _scrollView.frame = CGRectMake(0, _originY, self.frame.size.width, self.showFrame.size.height - _originY);

        for (NSInteger i = clickIndex; i < _canAddArray.count; i ++)
        {
            MDDeleteButton *button = _canAddArray[i];
            
            button.frame = CGRectMake(i % 4 *(_buttonWidth + _horSpacing) + _leading,i / 4 * (_buttonHeight + _verSpacing) + _verSpacing, _buttonWidth, _buttonHeight);
        }
        
        UIButton *lastButton = [_canAddArray lastObject];
        
        // 设置 scrollView 的显示范围
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, lastButton.frame.origin.y + lastButton.frame.size.height + _verSpacing);
    }];
}

#pragma mark 删除栏目
-(void)deleteAction:(UIButton *)button
{
    NSLog(@"删除");
    //  类名或类的路径 + 方法名 + 行号
//    //方法名字
//    NSLog(@"%s",__func__);
//    //类名
//    NSLog(@"%@",[self class]);
//    // 该类的 路径
//    NSLog(@"%s",__FILE__);
//    // 行号
//    NSLog(@"%d",__LINE__);
    
    //删除, superview subviews
    //取得 对应的 数组里的Button
    MDDeleteButton *showingCateButton = (MDDeleteButton *)button.superview;
    // 从 删除状态设置为 正常状态
    showingCateButton.deleteStatus = MDDeleteButtonStatusNomal;
    //得到 Index
    NSUInteger index = [_showingArray indexOfObject:showingCateButton];
    //  传值，删除的是 第几个 栏目
    if (self.clickedDeleteButtonIndex)
    {
        self.clickedDeleteButtonIndex(index + 1);
    }
    
    NSLog(@"%ld",(unsigned long)index);
    // 删除 showingCateButton, 添加 到 下方的 scrollView 中
    [_scrollView addSubview:showingCateButton];
    
    //  删除 旧的方法，添加 新的方法
    [showingCateButton removeTarget:self action:@selector(clickUpButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
    [showingCateButton addTarget:self action:@selector(clickDownButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
    
    showingCateButton.frame =CGRectMake(_canAddArray.count % 4 *(_buttonWidth + _horSpacing) + _leading, _canAddArray.count / 4 * (_buttonHeight + _verSpacing) + _verSpacing, _buttonWidth, _buttonHeight);
    // 添加到新的数组
    [_canAddArray addObject:showingCateButton];
    // 设置 scrollView 的显示范围大小
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, showingCateButton.frame.origin.y + _buttonHeight + _verSpacing);
    
    // 从数组里 删除
    [_showingArray removeObjectAtIndex:index];
    // 比上面的方法 效率低
//    [_showingArray removeObject:showingCateButton];
    
    [UIView animateWithDuration:0.2 animations:^{
        for (NSInteger i = index; i < _showingArray.count; i ++)
        {
            UIButton *animatButton = _showingArray[i];
            
            // 记录 Button 的坐标y
            _originY = _verSpacing + (_buttonHeight + _verSpacing) * (i / 4);
            
            animatButton.frame = CGRectMake(_leading + (_buttonWidth + _horSpacing) * (i % 4), _originY, _buttonWidth, _buttonHeight);
        }
    }];
    // 记录 最后一个 Button 的坐标y
    _originY = _verSpacing + (_buttonHeight + _verSpacing) * ((_showingArray.count - 1)/ 4);
    
    //  刷新 标签Label的frame
    _originY += _buttonHeight +_verSpacing;
    
    _addLabel.frame =CGRectMake(_addLabel.frame.origin.x,_originY, _addLabel.frame.size.width, _addLabel.frame.size.height);
    // 刷新ScrollView 的Frame
    
    CGFloat scrollViewY =_addLabel.frame.origin.y + _addLabel.frame.size.height;
    
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, scrollViewY, _scrollView.frame.size.width, self.frame.size.height - scrollViewY);
    
}

-(void)showDeletStatus:(UIButton *)button
{
    if (_isDeleteing == YES)
    {
        _isDeleteing = NO;
        //进入 非删除状态
        for (MDDeleteButton * button in _showingArray)
        {
            button.deleteStatus = MDDeleteButtonStatusNomal;
        }
        //  显示 下方的 标签 和 scrollView
        _addLabel.hidden = NO;
        _scrollView.hidden = NO;
    }
    else
    {
        _isDeleteing = YES;
        // 进入 删除状态
        for (MDDeleteButton *button in _showingArray) {
            button.deleteStatus = MDDeleteButtonStatusCanDelete;
        }
        // 隐藏 下方 的标签 和 scrollView
        _addLabel.hidden = YES;
        _scrollView.hidden = YES;
    }
}

-(void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

//#warning 测试
//-(void)setTestNum:(NSInteger)testNum
//{
//    _testNum = testNum;
//}
//-(NSInteger)testNum
//{
//    return 100;
//}

@end
