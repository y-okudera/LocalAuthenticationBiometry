//
//  Biometry.h
//  LocalAuthenticationBiometry
//
//  Created by Yuki Okudera on 2019/11/08.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

typedef void (^BiometryCompletion)(BOOL, NSError * _Nullable);

@interface Biometry : NSObject
+ (void)auth:(BiometryCompletion _Nonnull)completion;
@end
