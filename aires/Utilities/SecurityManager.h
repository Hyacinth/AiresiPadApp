//
//  SecurityManager.h
//  SaveCredentials
//
//  Created by Gautham on 09/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface SecurityManager : NSObject
{
    NSString *mServiceName;
}

@property (nonatomic, strong) NSString *mServiceName;

- (id)initWithServiceName:(NSString *)serviceName;

- (BOOL)setValue:(NSString *)value forKey:(NSString *)key;
- (BOOL)deleteValueForKey:(NSString *)key;
- (NSString *)getValueForKey:(NSString *)key;

@end
