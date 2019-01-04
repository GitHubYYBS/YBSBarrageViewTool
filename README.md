# YBSBarrageViewTool
弹幕小工具设计思想如tableView缓存池模式
### ````先看效果````
- ![Alt text](https://github.com/GitHubYYBS/YBSBarrageViewTool/blob/master/%E6%95%88%E6%9E%9C%E5%9B%BE.gif?raw=true)

###````设计思路````
    1.不会频繁创建弹幕lable 走出屏幕外的lable 会被重复利用
    2.触发模式不是使用定时器 而是使用UIView 动画 分阶段 在不同的阶段去检查是否有闲置的弹幕Lable 有就拿去 显示下一个弹幕
    3.屏幕中 弹幕最大显示数 弹幕集合类数量 > 弹幕控件最大显示数量(该控件的高度下 平铺最大数) > 外界设置的数量(showMaxNumInt)
    3.弹幕运动时间也做了智能匹配 小屏幕的机型 弹幕运动的时间 < 大屏幕机型弹幕运动的时间
    
###''''配置参数''''

''''
/// 弹幕最大显示数量 内部有最大数量保护 当外部设置的数量 大于 控件高度最大满铺弹幕数时 以 最大满铺数为主(同时也参考了 弹幕集合数量)
@property (nonatomic, assign) NSInteger showMaxNumInt;
/// 显示的内容集合 该集合为空 弹幕不会出现
@property (nonatomic, copy) NSArray<NSString *> *contentStrArray;
/// 弹幕条 背景色 默认随机色
@property (nonatomic, strong) UIColor *ybs_lableBackgroundColor;
/// 字体颜色 默认 白色
@property (nonatomic, strong) UIColor *ybs_lableTextColor;
/// 字体大小 默认12号字体 
@property (nonatomic, strong) UIFont  *ybs_lableFont;
/// 弹幕运动的最大时间 内部会根据该值来动态配置小屏幕的设备 默认20秒
@property (nonatomic, assign) NSInteger ybs_maxTimeInteger;
''''

###''''使用''''
''''
YBSBarrageViewTool *barrageView = [[YBSBarrageViewTool alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
    [self.view addSubview:barrageView];
    barrageView.contentStrArray = @[@"用户188****2221：已成功购买200两！", @"用户188****2222：已成功购买200两！",@"用户188****2221：已成功购买200两！", @"用户188****2222：已成功购买200两！",@"用户188****2221：已成功购买200两！", @"用户188****2222：已成功购买200两！",@"用户188****2221：已成功购买200两！", @"用户188****2222：已成功购买200两！",@"用户188****2221：已成功购买200两！", @"用户188****2222：已成功购买200两！"];
''''
