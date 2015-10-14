//
//  CrashReporter.h
//  Analytics
//
//  Created by dong kerry on 11-11-17.
//  Copyright (c) 2011年 tencent.com. All rights reserved.
//

//!!!!!!!crash回调函数!!!!!!
//  会在crash发生之后调用，应用可以定义回调函数自己对crash进行一些处理，比如保存一些现场信息
//   warning: avoid do some hard work
//   sample code :
//   static int fooo () {
//     NSLog(@"haha");
//     return 1;
//     }
//   exp_call_back_func= &fooo;

#pragma mark - define the callback handler function
typedef int (*exp_callback) ();

extern exp_callback exp_call_back_func;
#pragma mark - 

@interface CrashReporter : NSObject

+ (CrashReporter *)sharedInstance;

// *************初始化RQD的crash捕获和上报功能*************

// 初始化SDK接口并启动崩溃捕获上报功能,请输入合法的产品标识
- (BOOL)installWithAppId:(NSString *)appId;
- (void)uninstall;

//设置userid，用于标识用户
- (void)setUserId:(NSString *)userid;
//设置渠道标识
- (void)setChannel:(NSString *)chanl;
//设置设备id，用于标识设备。 默认sdk会创建一个uuid用于标识设备
//注意： buglyt统计用户数量的时候是依据deviceId的，如果需要设置 ，会影响到用户数统计，请保证deviceId的唯一性和非空性
- (void)setDeviceId:(NSString *)deviceId;

//开启log
- (void)enableLog:(BOOL)enabled;


//*************一些和捕获以及上报相关的接口*************

//设置异常合并上报，当天同一个异常只会上报第一次，后续合并保存并在第二天才会上报
- (void)setExpMergeUpload:(BOOL)isMerge;

//设置进程内进行地址还原
//注意：当xcode 的编译设置中strip style 为 ALL Symbols的时候，该设置会导致还原出的应用堆栈出现错误，如果您的应用设置了这个选项请不要调用这个接口
- (void)setEnableSymbolicateInProcess:(BOOL)enable;

//设置crash过滤，以shortname为基准（例如SogouInput）,如果包括则不进行记录和上报
- (BOOL)setExcludeShortName:(NSArray *)shortNames;
//设置只上报存在关键字的crash列表
- (BOOL)setIncludeShortName:(NSArray *)shortNames;

//上次关闭是否因为crash,用于启动后检查上次是否是发生了crash，以便做特殊提示
- (BOOL)isLastCloseByCrash;
//前面的crash过滤（Include和Exclude）影响isLastCloseByCrash
//设置NO之后， 如果crash被过滤不进行记录和上报，那么isLastCloseByCrash在下次启动返回NO
//如果设置为YES， 那么crash被过滤不进行记录和上报，但下次启动isLastCloseByCrash仍旧会返回YES
- (BOOL)setLastCloseByIncludExclued:(BOOL)enable;


//***********在发生crash的时候，可以在回调函数中做一些数据的记录（这几个接口也可以在应用运行的任意时刻记录）********

//设置附加的log信息，作为当前运行状态的参考用于分析crash，最大限制为10*1024
- (void)setAttachLog:(NSString *)attLog;
//添加一个当前事件的记录，后台会在一个session（应用启动到被杀死）过程中按顺序显示各个事件，如当前打开了哪个页面等事件
- (void)addSessionEvents:(NSString *)evt;
//设置keyvalue的数据，会随crash上报
- (void)setUserData:(NSString *)key value:(NSString *)value;

//***********在crash的时候，如果在exp_call_back_func的回调函数中需要crash堆栈的shortname信息，可以从这个借口获取***********

//得到当前的NSException对象
- (NSException *)getCurrentException;
//得到当前的crash堆栈
- (NSString *)getCrashStack;
- (NSString *)getCrashType;
- (NSString *)getCrashLog;

// *****  越狱情况API支持   上store的请不要调用 *****

// 使用mach exception捕获异常，比sigaction更全面，默认关闭
- (void)setUserMachHandler:(BOOL)useMach;

//一般用于越狱产品，可以重新设置数据库到特定路径
- (BOOL)resetDBPath:(NSString *)newPath;
//一般用于越狱产品，一些独立的进程没有bundleid和bundlever，可以通过这个标识产品和版本
- (void)setBundleId:(NSString *)bundleId;

/**
 *    @brief  设置应用的版本，在初始化之前调用。
 *    SDK默认读取Info.plist文件中的版本信息,并组装成CFBundleShortVersionString(CFBundleVersion)格式
 *
 *    @param bundleVer 自定义的版本信息
 */
- (void)setBundleVer:(NSString *)bundleVer;

- (BOOL)checkSignalHandler;
- (BOOL)checkNSExceptionHandler;
- (BOOL)enableSignalHandlerCheckable:(BOOL)enable;

/**
 *    @brief  上报Unity的C#异常的信息
 *
 *    @param name   C#异常的名称
 *    @param reason C#异常的原因
 *    @param stacks C#异常的堆栈
 */
- (void)reportUnityExceptionWithName:(NSString *)aName reason:(NSString *)aReason stack:(NSString *)stacks;

/**
 *    @brief  上报一个NSException异常
 *
 *    @param anException 上报的OC异常, sdk会处理其name、reason属性, 以及callStackSymbols
 *    @param aMessage    附带的信息
 */
- (void)reportException:(NSException *)anException message:(NSString *) aMessage;

/**
 *    @brief  检查是否存在崩溃信息并执行异步上报
 *
 *    @return 是否触发异步上报任务
 */
- (BOOL)checkAndUpload;

/**
 *  @brief 查看SDK的版本
 *
 *  @return SDK的版本信息
 */
- (NSString *)sdkVersion;

@end
