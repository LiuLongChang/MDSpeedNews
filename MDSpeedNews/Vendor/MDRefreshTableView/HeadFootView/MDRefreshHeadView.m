//
//  MDRefreshHeadView.m
//  MDYNewsSon
//
//  Created by Medalands on 15/3/2.
//  Copyright (c) 2015年 MM. All rights reserved.
//




#import "MDRefreshHeadView.h"



NSString *const MDRefreshHeadTimeKey = @"MDRefreshHeadTimeKey";


@implementation MDRefreshHeadView

//Default is at top
- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = kPRBGColor;
        //                self.backgroundColor = [UIColor redColor];
        
        _dateStoreKey = MDRefreshHeadTimeKey;
        
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
        
        UIImage * image =[UIImage imageNamed:@"arrow.png"];
        
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        _arrowView.image =image;
        
        [self addSubview:_arrowView];
        
      
        
        _activityView = [[UIImageView alloc] initWithFrame:CGRectMake(40, frame.size.height - 55, 50, 50)];
        
        _activityView.animationImages = @[[UIImage imageNamed:@"RefreshOne.png"],[UIImage imageNamed:@"RefreshTwo.png"],[UIImage imageNamed:@"RefreshThree.png"],[UIImage imageNamed:@"RefreshFour.png"],[UIImage imageNamed:@"RefreshFive.png"]];
        
        _activityView.animationDuration = 0.7;
        
        _activityView.image = [UIImage imageNamed:@"RefreshOne.png"];
        [self addSubview:_activityView];
        
        [self layouts];

        
        
    }
    return self;
}

-(void)setDateStoreKey:(NSString *)dateStoreKey
{
    
    _dateStoreKey = dateStoreKey;
    
    NSDate * lastUpdateTime   = [[NSUserDefaults standardUserDefaults] objectForKey:_dateStoreKey];
    
    if (lastUpdateTime)
    {
        [self updateRefreshDate:lastUpdateTime];
    }else
    {
        _dateLabel.text = [NSString stringWithFormat:@"%@:  %@",
                           NSLocalizedString(@"最后更新", @""),
                           @"从未"];
    }
}

- (void)layouts {
    
    CGSize size = self.frame.size;
    CGRect stateFrame,dateFrame,arrowFrame;
    
    float x = 0,y,margin;
    //    x = 0;
    margin = (kPROffsetY - 2*kPRLabelHeight)/2;

    
    
    y = size.height - margin - kPRLabelHeight;
    dateFrame = CGRectMake(40,y,size.width - 40,kPRLabelHeight);
    
    y = y - kPRLabelHeight;
    stateFrame = CGRectMake(40, y, size.width - 40, kPRLabelHeight);
    
    
    x = kPRMargin;
    y = size.height - margin - kPRArrowHeight;
    arrowFrame = CGRectMake(135, y, kPRArrowWidth, kPRArrowHeight);
    
    _stateLabel.frame = stateFrame;
    _dateLabel.frame = dateFrame;

    
    NSDate * lastUpdateTime   = [[NSUserDefaults standardUserDefaults] objectForKey:_dateStoreKey];
    
    if (lastUpdateTime)
    {
        [self updateRefreshDate:lastUpdateTime];
    }else
    {
        _dateLabel.text = [NSString stringWithFormat:@"%@:  %@",
                           NSLocalizedString(@"最后更新", @""),
                           @"从未"];
    }

    
}

- (void)updateRefreshDate :(NSDate *)date{
    
    // 1. 存储 刷新时间
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:_dateStoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
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

- (void)setState:(PRState)state animated:(BOOL)animated{
//    float duration = animated ? kPRAnimationDuration : 0.f;
    if (_state != state) {
        _state = state;
        if (_state == kPRStateLoading) {    //Loading
            
            [_activityView startAnimating];

            _loading = YES;
            
            _stateLabel.text = NSLocalizedString(@"正在刷新", @"");
            
        } else if (_state == kPRStatePulling && !_loading) {    //Scrolling
            
            [_activityView stopAnimating];
            
            _stateLabel.text = NSLocalizedString(@"释放刷新", @"");
           
        } else if (_state == kPRStateNormal && !_loading){    //Reset
            
            [_activityView stopAnimating];
            
            _stateLabel.text = NSLocalizedString(@"下拉刷新", @"");
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

@end
