//
//  LCLogManager.m
//  LinkCity
//
//  Created by roy on 2/5/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCLogManager.h"
#import <MessageUI/MessageUI.h>

@interface LCLogManager ()<MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UIViewController *rootVC;
@property (nonatomic, strong) MFMailComposeViewController *mailVC;
@end
@implementation LCLogManager

#pragma mark - Public Interface
+ (instancetype)sharedInstance{
    static LCLogManager *staticLogManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticLogManager = [[LCLogManager alloc]init];
    });
    return staticLogManager;
}

- (void)setupLogManager{
    
#ifdef DEBUG
    //初始化Logger
    //int ttyLoggerLevel = XMPP_LOG_FLAG_SEND_RECV | XMPP_LOG_LEVEL_INFO;
    int ttyLoggerLevel = XMPP_LOG_LEVEL_INFO | XMPP_LOG_FLAG_TRACE;
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:ttyLoggerLevel];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60*60*1; //24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 3;
    [DDLog addLogger:fileLogger withLogLevel:XMPP_LOG_LEVEL_WARN];
    
#else
    
    
#endif
}


- (void)sendLog{
    //通过邮件发送日志到指定邮箱
    self.mailVC = [[MFMailComposeViewController alloc]init];
    self.mailVC.mailComposeDelegate = self;
    
    [self.mailVC setSubject:@"Duckr Log Info"];
    [self.mailVC setToRecipients:@[@"ruoyuzh@qq.com"]];
    [self.mailVC setMessageBody:@"Duckr Log Info" isHTML:NO];
    
    
    
    
    NSArray *cacheDics = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDic = [cacheDics objectAtIndex:0];
    NSString *logDic = [cacheDic stringByAppendingPathComponent:@"Logs"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *logFiles = [fileManager subpathsAtPath:logDic];
    if (logFiles && logFiles.count>0) {
        for (NSString *logFile in logFiles){
            NSString *fileWholePath = [logDic stringByAppendingPathComponent:logFile];
            if (![fileManager fileExistsAtPath:fileWholePath]) {
                LCLogWarn(@"log file : %@ not exist.",fileWholePath);
            }
            NSData *logData = [fileManager contentsAtPath:fileWholePath];
            [self.mailVC addAttachmentData:logData mimeType:@"application/applefile" fileName:logFile];
        }
    }

    [[LCSharedFuncUtil getTopMostViewController] presentViewController:self.mailVC animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewController delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error) {
        LCLogWarn(@"mail compose failed with error:%@",error);
    }
    
    [self.mailVC dismissViewControllerAnimated:YES completion:nil];
    self.mailVC = nil;
}
@end
