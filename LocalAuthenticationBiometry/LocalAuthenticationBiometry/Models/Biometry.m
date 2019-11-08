//
//  Biometry.m
//  LocalAuthenticationBiometry
//
//  Created by Yuki Okudera on 2019/11/08.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

#import "Biometry.h"

static NSString *const kLABiometryTypeNoneDescription = @"ユーザID・パスワードでログインしてください。";
static NSString *const kLABiometryTypeTouchIDDescription = @"ログインするためにTouch IDで認証します。";
static NSString *const kLABiometryTypeFaceIDDescription = @"ログインするためにFace IDで認証します。";

@implementation Biometry

+ (void)auth:(BiometryCompletion _Nonnull)completion {
    
    LAContext *context = [LAContext new];
    NSError *error = nil;
    NSString *description = @"";
    
    // Touch ID・Face IDが利用できるデバイスか確認する
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        NSLog(@"Touch ID・Face IDを利用できる");
        
        switch (context.biometryType) {
            case LABiometryTypeNone:
                description = kLABiometryTypeNoneDescription;
                break;
            case LABiometryTypeTouchID:
                description = kLABiometryTypeTouchIDDescription;
                break;
            case LABiometryTypeFaceID:
                description = kLABiometryTypeFaceIDDescription;
                break;
        }
        
        // 利用できる場合は指紋・顔認証を要求する
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:description reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"認証成功");
                completion(YES, nil);
            } else {
                NSLog(@"認証失敗");
                NSLog(@"error:%@", error);
                completion(NO, error);
            }
        }];
    } else {
        // Touch ID・Face IDが利用できない場合の処理
        NSLog(@"Touch ID・Face IDが利用できない");
        completion(NO, error);
    }
}
@end
