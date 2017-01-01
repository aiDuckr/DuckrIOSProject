//
//  LCMessageConvert.m
//  LinkCity
//
//  Created by 张宗硕 on 11/23/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCMessageConvert.h"

@implementation LCMessageConvert

+ (MessageModel *)getEMMessageFromJsonStr:(NSString *)jsonStr
{
    MessageModel *model = [[MessageModel alloc] init];
    if ([LCStringUtil isNullString:jsonStr]) {
        return model;
    }
    
    NSError *error;
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (nil != jsonDic && jsonDic.count > 0) {
        MessageBodyType type = [LCStringUtil idToInt:[jsonDic objectForKey:@"Type"]];
        switch (type) {
            case eMessageBodyType_Text:
                model = [LCMessageConvert getEMMessageFromText:jsonDic];
                break;
            case eMessageBodyType_Image:
                model = [LCMessageConvert getEMMessageFromImage:jsonDic];
                break;
            case eMessageBodyType_Location:
                model = [LCMessageConvert getEMMessageFromLocation:jsonDic];
                break;
            case eMessageBodyType_Plan:
                model = [LCMessageConvert getEMMessageFromPlan:jsonDic];
                break;
            case eMessageBodyType_System:
                model = [LCMessageConvert getEMMessageFromSystem:jsonDic];
                break;
            case eMessageBodyType_CheckIn:
                model = [LCMessageConvert getEMMessageFromCheckIn:jsonDic];
                break;
            case eMessageBodyType_Voice:
                model = [LCMessageConvert getEMMessageFromVoice:jsonDic];
            default:
                break;
        }
        if ([[jsonDic allKeys] containsObject:@"Telephone"]) {
            model.senderTelephone = [jsonDic objectForKey:@"Telephone"];
        }
        if ([[jsonDic allKeys] containsObject:@"MsgUuid"]) {
            model.msgUuid = [jsonDic objectForKey:@"MsgUuid"];
        }
    }
    
    return model;
}

+ (MessageModel *)getEMMessageFromPlan:(NSDictionary *)dic {
    MessageModel *model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_Plan;
    LCPlanModel *plan = [[LCPlanModel alloc] init];
    plan.planGuid = [dic objectForKey:@"PlanGuid"];
    plan.firstPhotoThumbUrl = [dic objectForKey:@"ImageCoverThumb"];
    plan.departName = [dic objectForKey:@"PlanDepartPlace"];
    NSString *destinationsString = [dic objectForKey:@"DestinationName"];
    plan.destinationNames = [LCPlanModel getDestinationsStringArrayWithSeparator:@"-" fromString:destinationsString];
    plan.startTime = [dic objectForKey:@"StartTime"];
    plan.endTime = [dic objectForKey:@"EndTime"];
    plan.descriptionStr = [dic objectForKey:@"DescriptionStr"];
    model.plan = plan;
    
    return model;
}

+ (MessageModel *)getEMMessageFromImage:(NSDictionary *)dic {
    MessageModel *model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_Image;
    model.thumbnailRemoteURL = [NSURL URLWithString:[dic objectForKey:@"ThumbnailRemoteURL"]];
    model.imageRemoteURL = [NSURL URLWithString:[dic objectForKey:@"ImageRemoteURL"]];
    //message.content = [dic objectForKey:@"Content"];
    return model;
}

+ (MessageModel *)getEMMessageFromLocation:(NSDictionary *)dic {
    MessageModel *model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_Location;
    model.latitude = [[dic objectForKey:@"Latitude"] floatValue];
    model.longitude = [[dic objectForKey:@"Longitude"] floatValue];
    model.address = [dic objectForKey:@"Address"];
    //message.content = [dic objectForKey:@"Content"];
    return model;
}

+ (MessageModel *)getEMMessageFromCheckIn:(NSDictionary *)dic {
    MessageModel *model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_CheckIn;
    model.latitude = [[dic objectForKey:@"Latitude"] floatValue];
    model.longitude = [[dic objectForKey:@"Longitude"] floatValue];
    model.address = [dic objectForKey:@"Address"];
    //message.content = [dic objectForKey:@"Content"];
    return model;
}

+ (MessageModel *)getEMMessageFromSystem:(NSDictionary *)dic {
    MessageModel *model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_System;
    //message.content = [dic objectForKey:@"Content"];
    return model;
}

+ (MessageModel *)getEMMessageFromText:(NSDictionary *)dic {
    MessageModel *model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_Text;
    //message.content = [dic objectForKey:@"Content"];
    return model;
}

+ (MessageModel *)getEMMessageFromVoice:(NSDictionary *)dic {
    MessageModel *model = [[MessageModel alloc] init];
    model.type = eMessageBodyType_Voice;
    model.voice = [dic objectForKey:@"Voice"];
    return model;
}

+ (NSDictionary *)getDictionaryFromTextMessage:(MessageModel *)model {
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    return mutDic;
}

+ (NSDictionary *)getDictionaryFromSystemMessage:(MessageModel *)model {
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    return mutDic;
}

+ (NSDictionary *)getDictionaryFromImageMessage:(MessageModel *)model {
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    [mutDic setObject:[model.thumbnailRemoteURL absoluteString] forKey:@"ThumbnailRemoteURL"];
    [mutDic setObject:[model.imageRemoteURL absoluteString] forKey:@"ImageRemoteURL"];
    return mutDic;
}

+ (NSDictionary *)getDictionaryFromLocationMessage:(MessageModel *)model {
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    [mutDic setObject:[NSString stringWithFormat:@"%f", model.latitude] forKey:@"Latitude"];
    [mutDic setObject:[NSString stringWithFormat:@"%f", model.longitude] forKey:@"Longitude"];
    [mutDic setObject:model.address forKey:@"Address"];
    return mutDic;
}

+ (NSDictionary *)getDictionaryFromCheckInMessage:(MessageModel *)model {
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    [mutDic setObject:[NSString stringWithFormat:@"%f", model.latitude] forKey:@"Latitude"];
    [mutDic setObject:[NSString stringWithFormat:@"%f", model.longitude] forKey:@"Longitude"];
    [mutDic setObject:model.address forKey:@"Address"];
    return mutDic;
}

+ (NSDictionary *)getDictionaryFromPlanMessage:(MessageModel *)model {
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    [mutDic setObject:model.plan.planGuid forKey:@"PlanGuid"];
    [mutDic setObject:model.plan.firstPhotoThumbUrl forKey:@"ImageCoverThumb"];
    [mutDic setObject:model.plan.departName forKey:@"PlanDepartPlace"];
    [mutDic setObject:[model.plan getDestinationsStringWithSeparator:@"-"] forKey:@"DestinationName"];
    [mutDic setObject:model.plan.startTime forKey:@"StartTime"];
    [mutDic setObject:model.plan.endTime forKey:@"EndTime"];
    [mutDic setObject:model.plan.descriptionStr forKey:@"DescriptionStr"];
    // TODO: 为了向后兼容，发的时候设置plantype为1
    [mutDic setObject:@"1" forKey:@"PlanType"];
    return mutDic;
}

+ (NSDictionary *)getDictionaryFromVoiceMessage:(MessageModel *)model {
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    [mutDic setObject:model.voice forKey:@"Voice"];
    return mutDic;
}

+ (NSString *)getJsonStrFromEMMessage:(MessageModel *)model {
    NSDictionary *dic = [[NSDictionary alloc] init];
    switch (model.type) {
        case eMessageBodyType_Text:
            dic = [LCMessageConvert getDictionaryFromTextMessage:model];
            break;
        case eMessageBodyType_Image:
            dic = [LCMessageConvert getDictionaryFromImageMessage:model];
            break;
        case eMessageBodyType_Location:
            dic = [LCMessageConvert getDictionaryFromLocationMessage:model];
            break;
        case eMessageBodyType_Plan:
            dic = [LCMessageConvert getDictionaryFromPlanMessage:model];
            break;
        case eMessageBodyType_System:
            dic = [LCMessageConvert getDictionaryFromSystemMessage:model];
            break;
        case eMessageBodyType_CheckIn:
            dic = [LCMessageConvert getDictionaryFromCheckInMessage:model];
            break;
        case eMessageBodyType_Voice:
            dic = [LCMessageConvert getDictionaryFromVoiceMessage:model];
        default:
            break;
    }
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [mutDic setObject:[LCStringUtil integerToString:model.type] forKey:@"Type"];
    if ([LCStringUtil isNotNullString:model.senderTelephone]) {
        [mutDic setObject:model.senderTelephone forKey:@"Telephone"];
    }
    if ([LCStringUtil isNotNullString:model.msgUuid]) {
        [mutDic setObject:model.msgUuid forKey:@"MsgUuid"];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [LCStringUtil getNotNullStr:jsonStr];
}

@end
