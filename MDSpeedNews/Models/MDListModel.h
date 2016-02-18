//
//  MDListModel.h
//  MDSpeedNews
//
//  Created by Medalands on 15/8/18.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDBaseModel.h"

@interface MDListModel : MDBaseModel

@property(nonatomic,copy)NSString *alias;
@property(nonatomic,copy)NSString *boardid;
@property(nonatomic,copy)NSString *cid;
@property(nonatomic,copy)NSString *digest;
@property(nonatomic,copy)NSString *docid;
@property(nonatomic,copy)NSString *ename;
@property(nonatomic,copy)NSString *hasAD;
@property(nonatomic,copy)NSString *hasCover;
@property(nonatomic,copy)NSString *hasHead;
@property(nonatomic,copy)NSString *hasIcon;
@property(nonatomic,copy)NSString *hasImg;
@property(nonatomic,copy)NSString *imgsrc;
@property(nonatomic,copy)NSString *lmodify;
@property(nonatomic,copy)NSString *order;
@property(nonatomic,copy)NSString *priority;
@property(nonatomic,copy)NSString *ptime;
@property(nonatomic,copy)NSString *replyCount;
@property(nonatomic,copy)NSString *source;
@property(nonatomic,copy)NSString *subtitle;
@property(nonatomic,copy)NSString *templatee;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *tname;
/**
 * 详情 的网页
 */
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *url_3w;
@property(nonatomic,copy)NSString *votecount;
/**
 * 图片数组，三个图片cell 的判断条件
 */
@property(nonatomic,strong)NSArray *imgextra;
@property(nonatomic,copy)NSString *skipType;
@property(nonatomic,copy)NSString *TAGS;
@property(nonatomic,copy)NSString *skipID;
@property(nonatomic,copy)NSString *photosetID;
@property(nonatomic,copy)NSNumber *imgType;
@property(nonatomic,copy)NSString *editor;
@property(nonatomic,copy)NSString *TAG;
@property(nonatomic,copy)NSString *videoID;
@property(nonatomic,copy)NSString *videosource;
@property(nonatomic,copy)NSString *specialID;
#warning 新添字段，待了解
@property(nonatomic,copy)NSString *live_info;
@property(nonatomic,copy)NSString *specialtip;
@property(nonatomic,copy)NSString *specialadlogo;
@property(nonatomic,copy)NSString *specialextra;
@property(nonatomic,copy)NSString *pixel;

/**
 * 消息 已读 未读
 */
@property(nonatomic,assign)BOOL isReaded;

@end
