//
//  YBSBarrageViewTool.m
//  Warehouse_10
//
//  Created by 严兵胜 on 2019/1/2.
//  Copyright © 2019 陈樟权. All rights reserved.
//

#import "YBSBarrageViewTool.h"

#pragma mark - *********************** YBSBarrageLable 弹幕Lable ***********************

@interface YBSBarrageLable : UILabel
/// 是否正在展示 默认No
@property (nonatomic, assign) BOOL ybs_isShowNowBool;
/// 记录该lable 在展示时的y
@property (nonatomic, strong) NSString *ybs_lableTopStr;

@end

@implementation YBSBarrageLable


- (void)dealloc{
}

@end


#pragma mark - *********************** YBSBarrageViewTool 弹幕工具 ***********************

@interface YBSBarrageViewTool ()

/// 所有的Lable
@property (nonatomic, strong) NSMutableArray<YBSBarrageLable *> *ybs_allLableArray;
/// 当前展示的是第几个
@property (nonatomic, assign) NSInteger ybs_nextShowTextStrIndex;

@end


static CGFloat const ybs_lableFontFloat = 12;
static CGFloat const ybs_lableHeight = ybs_lableFontFloat * 2;

// 随机色
#define kRandomlyColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0f green:arc4random_uniform(256) / 255.0f blue:arc4random_uniform(256) / 255.0f alpha:1]



@implementation YBSBarrageViewTool

+ (instancetype)ybs_barrageViewToolWithFrame:(CGRect)frame{
    
    YBSBarrageViewTool *barrageView = [[YBSBarrageViewTool alloc] initWithFrame:frame];
    barrageView.clipsToBounds = true;
    barrageView.backgroundColor = [UIColor clearColor];
    
    return barrageView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds = true;
        self.backgroundColor = [UIColor clearColor];
        
        self.ybs_lableTextColor = [UIColor whiteColor];
        self.ybs_lableFont = [UIFont systemFontOfSize:ybs_lableFontFloat];
    }
    return self;
}

- (void)setContentStrArray:(NSArray<NSString *> *)contentStrArray{
    
    _contentStrArray = contentStrArray;
    if (contentStrArray == nil || !_contentStrArray.count) return;
    
    for (YBSBarrageLable *ybs_lable in self.ybs_allLableArray) {
        [ybs_lable removeFromSuperview];
    }
    [self.ybs_allLableArray removeAllObjects];
    
    [self setUp];
}

- (void)setUp{
    
    NSInteger maxNum = (NSInteger )((self.bounds.size.height - 2 * ybs_lableHeight) / ybs_lableHeight);
    self.showMaxNumInt = (self.showMaxNumInt <= 0)? maxNum : self.showMaxNumInt;
    self.showMaxNumInt = (self.showMaxNumInt > maxNum)? maxNum : self.showMaxNumInt; // 最多数量保护
    NSInteger showMaxNum = (self.showMaxNumInt > _contentStrArray.count)? _contentStrArray.count : self.showMaxNumInt;
    for (int i = 0; i < showMaxNum; ++i) {
        YBSBarrageLable *ybs_lable = [YBSBarrageLable new];
        ybs_lable.tag = i;
        ybs_lable.backgroundColor = (self.ybs_lableBackgroundColor)? self.ybs_lableBackgroundColor : kRandomlyColor;
        ybs_lable.textColor = self.ybs_lableTextColor;
        ybs_lable.font = self.ybs_lableFont;
        ybs_lable.textAlignment = NSTextAlignmentCenter;
        ybs_lable.frame = CGRectMake(0, 0, 0, ybs_lableHeight);
        ybs_lable.layer.cornerRadius = ybs_lableFontFloat;
        ybs_lable.clipsToBounds = true;
        [self addSubview:ybs_lable];
        [self.ybs_allLableArray addObject:ybs_lable];
    }
    
    self.ybs_nextShowTextStrIndex = 0;
    [self ybs_startAnimationsWithLable:self.ybs_allLableArray[0] nextShowTextStr:self.contentStrArray[self.ybs_nextShowTextStrIndex]];
}

static CGFloat countNumber = 0;
- (void)ybs_startAnimationsWithLable:(YBSBarrageLable *)nextLable nextShowTextStr:(NSString *)nextShowTextStr{
    
    nextLable.text = nextShowTextStr;
    [nextLable sizeToFit];
    NSInteger y = rand() % (NSInteger)(self.bounds.size.height - ybs_lableHeight); // 随机产生y值
    if (![self ybs_compareLableY:y]) { // 判断y值是否合格 是否与已经在显示的有重合部分
        countNumber += 1;
        if (countNumber >= 5) { // 防止一直不合格 一直反复调用该方法 造成内存开销过大
            countNumber = 0;
            return;
        }
        [self ybs_startAnimationsWithLable:nextLable nextShowTextStr:nextShowTextStr];
        return;
    }
    
    nextLable.frame = CGRectMake(self.bounds.size.width, y, nextLable.bounds.size.width + 20, ybs_lableHeight);
    nextLable.ybs_lableTopStr = [NSString stringWithFormat:@"%ld",y];
    
    // 第一部分需要运动的距离
    CGFloat firstDistance = (nextLable.bounds.size.width > self.bounds.size.width * 0.5)? nextLable.bounds.size.width : self.bounds.size.width * 0.5;

    // 最大时间
    self.ybs_maxTimeInteger = (self.ybs_maxTimeInteger <= 0)? 20 : self.ybs_maxTimeInteger;
    // 智能匹配时间
    NSInteger duration = ((self.bounds.size.width + nextLable.bounds.size.width) * 0.02 > self.ybs_maxTimeInteger)? self.ybs_maxTimeInteger : (NSInteger)(self.bounds.size.width + nextLable.bounds.size.width) * 0.02;
    NSInteger firstTime = (NSInteger )firstDistance / (self.bounds.size.width + nextLable.bounds.size.width) * duration;
    firstTime += 1;
    
    __weak typeof(self) weakSelf = self;
    nextLable.ybs_isShowNowBool = true;
    __weak YBSBarrageLable *weakNextLable = nextLable;
    // 第一阶段运动到中心点或者 弹幕全部出现在屏幕上(看firstDistance 计算的结果)
    [UIView animateWithDuration:firstTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakNextLable.frame = CGRectMake(weakSelf.bounds.size.width - firstDistance, y, weakNextLable.bounds.size.width, ybs_lableHeight);
    } completion:^(BOOL finished) {
        weakNextLable.ybs_lableTopStr = nil;
        [weakSelf ybs_chooseNextLable];
    }];

    // 第二部分 走完剩下的路程
    [UIView animateWithDuration:duration - firstTime delay:firstTime options:UIViewAnimationOptionCurveLinear animations:^{
        weakNextLable.frame = CGRectMake(-weakNextLable.bounds.size.width, y, weakNextLable.bounds.size.width, ybs_lableHeight);
    } completion:^(BOOL finished) {
        weakNextLable.ybs_isShowNowBool = false;
        [weakSelf ybs_chooseNextLable];
    }];
}


// 检查 y 值 防止  重合 NO->当前Y值不合格
- (BOOL )ybs_compareLableY:(NSInteger )nextLableY{
    
    for (NSString *str in [self.ybs_allLableArray valueForKeyPath:@"ybs_lableTopStr"]) {
        if (str == nil) continue;
        NSInteger preYInteger = [[NSString stringWithFormat:@"%@",str] integerValue];
        NSInteger subtracb = labs(preYInteger - nextLableY);
        if (subtracb < ybs_lableHeight){
            return false;
        };
    }
    return true;
}

// 寻找下一个lable
- (void)ybs_chooseNextLable{
    
    YBSBarrageLable *nextLable = nil;
    for (YBSBarrageLable *lable in self.ybs_allLableArray) {
        if (!lable.ybs_isShowNowBool) {
            nextLable = lable;
            break;
        }
    }

    // 没有空闲的家伙
    if (nextLable == nil) return;
    self.ybs_nextShowTextStrIndex = (self.ybs_nextShowTextStrIndex + 1 >= self.contentStrArray.count)? 0 : (self.ybs_nextShowTextStrIndex + 1);
    [self ybs_startAnimationsWithLable:nextLable nextShowTextStr:self.contentStrArray[self.ybs_nextShowTextStrIndex]];
}


#pragma mark - 其他

- (NSMutableArray<YBSBarrageLable *> *)ybs_allLableArray{
    if (!_ybs_allLableArray) {
        _ybs_allLableArray = [NSMutableArray array];
    }
    return _ybs_allLableArray;
}

- (void)dealloc{
    
    NSLog(@"销毁了__弹幕工具");
}

@end
