//
//  MDRefreshHeadFootView.m
//  MDYNewsSon
//
//  Created by Medalands on 15/3/2.
//  Copyright (c) 2015年 MM. All rights reserved.
//

#import "MDRefreshHeadFootView.h"

@implementation MDRefreshHeadFootView

@synthesize atTop = _atTop;
@synthesize state = _state;
@synthesize loading = _loading;

//Default is at top
- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.atTop = top;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = kPRBGColor;
        //                self.backgroundColor = [UIColor redColor];
        UIFont *ft = [UIFont systemFontOfSize:12.f];
        _stateLabel = [[UILabel alloc] init ];
        _stateLabel.font = ft;
        _stateLabel.textColor = kTextColor;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.backgroundColor = kPRBGColor;
        _stateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _stateLabel.text = NSLocalizedString(@"下拉刷新", @"");
        [self addSubview:_stateLabel];
        
        _dateLabel = [[UILabel alloc] init ];
        _dateLabel.font = ft;
        _dateLabel.textColor = kTextColor;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.backgroundColor = kPRBGColor;
        _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //        _dateLabel.text = NSLocalizedString(@"最后更新", @"");
        [self addSubview:_dateLabel];
        
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20) ];
        
        _arrow = [CALayer layer];
        _arrow.frame = CGRectMake(0, 0, 20, 20);
        _arrow.contentsGravity = kCAGravityResizeAspect;
        
        _arrow.contents = (id)[UIImage imageWithCGImage:[UIImage imageNamed:@"arrow.png"].CGImage scale:1 orientation:UIImageOrientationDown].CGImage;
        
        [self.layer addSublayer:_arrow];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityView];
        
        [self layouts];
        
        
    }
    return self;
}

- (void)layouts {
    
    CGSize size = self.frame.size;
    CGRect stateFrame,dateFrame,arrowFrame;
    
    float x = 0,y,margin;
    //    x = 0;
    margin = (kPROffsetY - 2*kPRLabelHeight)/2;
    if (self.isAtTop) {
        y = size.height - margin - kPRLabelHeight;
        dateFrame = CGRectMake(0,y,size.width,kPRLabelHeight);
        
        y = y - kPRLabelHeight;
        stateFrame = CGRectMake(0, y, size.width, kPRLabelHeight);
        
        
        x = kPRMargin;
        y = size.height - margin - kPRArrowHeight;
        arrowFrame = CGRectMake(size.width / 5., y, kPRArrowWidth, kPRArrowHeight);
        
        
        UIImage *arrow = [UIImage imageNamed:@"arrow"];
        _arrow.contents = (id)arrow.CGImage;
        
    } else {    //at bottom
        y = margin;
        stateFrame = CGRectMake(0, y, size.width, kPRLabelHeight );
        
        y = y + kPRLabelHeight;
        dateFrame = CGRectMake(0, y, size.width, kPRLabelHeight);
        
        x = kPRMargin;
        y = margin;
        arrowFrame = CGRectMake(size.width / 5., y, kPRArrowWidth, kPRArrowHeight);
        
        UIImage *arrow = [UIImage imageNamed:@"arrowDown"];
        _arrow.contents = (id)arrow.CGImage;
        _stateLabel.text = NSLocalizedString(@"上拉加载", @"");
    }
    
    _stateLabel.frame = stateFrame;
    _dateLabel.frame = dateFrame;
    _arrowView.frame = arrowFrame;
    _activityView.center = _arrowView.center;
    _arrow.frame = arrowFrame;
    _arrow.transform = CATransform3DIdentity;
    
}

- (void)setState:(PRState)state animated:(BOOL)animated{
    float duration = animated ? kPRAnimationDuration : 0.f;
    if (_state != state) {
        _state = state;
        if (_state == kPRStateLoading) {    //Loading
            
            _arrow.hidden = YES;
            _activityView.hidden = NO;
            [_activityView startAnimating];
            
            _loading = YES;
            if (self.isAtTop) {
                _stateLabel.text = NSLocalizedString(@"正在刷新", @"");
            } else {
                _stateLabel.text = NSLocalizedString(@"正在加载", @"");
            }
            
        } else if (_state == kPRStatePulling && !_loading) {    //Scrolling
            
            _arrow.hidden = NO;
            _activityView.hidden = YES;
            [_activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            _arrow.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            [CATransaction commit];
            
            if (self.isAtTop) {
                _stateLabel.text = NSLocalizedString(@"释放刷新", @"");
            } else {
                _stateLabel.text = NSLocalizedString(@"释放加载更多", @"");
            }
            
        } else if (_state == kPRStateNormal && !_loading){    //Reset
            
            _arrow.hidden = NO;
            _activityView.hidden = YES;
            [_activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            _arrow.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            if (self.isAtTop) {
                _stateLabel.text = NSLocalizedString(@"下拉刷新", @"");
            } else {
                _stateLabel.text = NSLocalizedString(@"上拉加载更多", @"");
            }
        } else if (_state == kPRStateHitTheEnd) {
            if (!self.isAtTop) {    //footer
                _arrow.hidden = YES;
                _stateLabel.text = NSLocalizedString(@"没有更多信息了", @"");
            }
        }else if(_state==kPRStateNetTimeOut){
            if (!self.isAtTop) {    //footer
                _arrow.hidden = YES;
                _stateLabel.text = NSLocalizedString(@"网络连接超时", @"");
            }
            
        }else if (_state==kPRStateNetNotConnect){
            if (!self.isAtTop) {    //footer
                _arrow.hidden = YES;
                _stateLabel.text = NSLocalizedString(@"网络异常，请检查后重试", @"");
            }
            
        }
    }
}


- (void)setState:(PRState)state {
    [self setState:state animated:YES];
}

- (void)setLoading:(BOOL)loading {
    //    if (_loading == YES && loading == NO) {
    //        [self updateRefreshDate:[NSDate date]];
    //    }
    _loading = loading;
}

- (void)updateRefreshDate :(NSDate *)date{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateString = [df stringFromDate:date];
    NSString *title = NSLocalizedString(@"今天", nil);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                               fromDate:date toDate:[NSDate date] options:0];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    if (year == 0 && month == 0 && day < 3) {
        if (day == 0) {
            title = NSLocalizedString(@"今天",nil);
        } else if (day == 1) {
            title = NSLocalizedString(@"昨天",nil);
        } else if (day == 2) {
            title = NSLocalizedString(@"前天",nil);
        }
        df.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",title];
        dateString = [df stringFromDate:date];
        
    }
    _dateLabel.text = [NSString stringWithFormat:@"%@: %@",
                       NSLocalizedString(@"最后更新", @""),
                       dateString];
    //    [df release];
}

@end
