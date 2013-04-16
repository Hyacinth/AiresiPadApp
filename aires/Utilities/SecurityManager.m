//
//  SecurityManager.m
//  SaveCredentials
//
//  Created by Gautham on 09/04/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "SecurityManager.h"

#pragma mark -
@interface SecurityManager (private)

- (NSMutableDictionary *)getDictionaryWithIdentifier:(NSString *)identifier;

@end

#pragma mark -
@implementation SecurityManager
@synthesize mServiceName;


// Initialization
#pragma mark -
- (id) initWithServiceName:(NSString *) serviceName {
	
    if ((self = [super init])) {
        self.mServiceName = serviceName;
    }
    
	return self;
}


#pragma mark -
- (BOOL)setValue:(NSString *)value forKey:(NSString *)key
{
    //delete the value if already exists for key
    [self deleteValueForKey:key];
    
    NSMutableDictionary *dictionary = [self getDictionaryWithIdentifier:key];
	
    NSData *passwordData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(__bridge_transfer NSString *)kSecValueData];
	
    OSStatus status = SecItemAdd((__bridge_retained CFDictionaryRef)dictionary, NULL);
	
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}


- (NSString *)getValueForKey:(NSString *)key
{
    NSMutableDictionary *searchDictionary = [self getDictionaryWithIdentifier:key];
	
    // Add search attributes
    [searchDictionary setObject:(__bridge_transfer NSString *)kSecMatchLimitOne forKey:(__bridge_transfer NSString *)kSecMatchLimit];
	
    // Add search return types
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer NSString *)kSecReturnData];
	
    CFDataRef cfresult = NULL;
    OSStatus status = SecItemCopyMatching((__bridge_retained CFDictionaryRef)searchDictionary,
                                          (CFTypeRef *)&cfresult);
    
    NSData *result = (__bridge_transfer NSData *)cfresult;
	
    NSString *value = nil;
	if (status == errSecSuccess && result){
		value = [[NSString alloc] initWithData:result   encoding:NSUTF8StringEncoding];
	}
	
	return value;
}


- (BOOL)deleteValueForKey:(NSString *)key
{
    NSMutableDictionary *searchDictionary = [self getDictionaryWithIdentifier:key];
    OSStatus status = SecItemDelete((__bridge_retained CFDictionaryRef)searchDictionary);
    
    if(status == errSecSuccess){
        return YES;
    }
    
    return NO;
}

#pragma mark -
#pragma mark Private Methods
- (NSMutableDictionary *)getDictionaryWithIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init] ;
    [searchDictionary setObject:(__bridge_transfer NSString *)kSecClassGenericPassword forKey:(__bridge_transfer NSString *)kSecClass];
	
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge_transfer NSString *)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge_transfer NSString *)kSecAttrAccount];
    [searchDictionary setObject:self.mServiceName forKey:(__bridge_transfer NSString *)kSecAttrService];
	
    return searchDictionary;
}

@end
