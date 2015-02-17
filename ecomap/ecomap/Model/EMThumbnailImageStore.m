//
//  EMThumbnailImageStore.m
//  ecomap
//
//  Created by Vasya on 2/17/15.
//  Copyright (c) 2015 SoftServe. All rights reserved.
//

#import "EMThumbnailImageStore.h"

//Setup DDLog
#import "GlobalLoggerLevel.h"

@interface EMThumbnailImageStore ()
@property (nonatomic, strong) NSMutableDictionary *cache; //key - link; value - UIImage
@end

@implementation EMThumbnailImageStore

#pragma mark -
+ (instancetype)sharedStore
{
    static EMThumbnailImageStore *shareStore = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareStore = [[EMThumbnailImageStore alloc] init];
        
        if (shareStore) {
            //Register observer to receive memory warning notifications
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:shareStore
                   selector:@selector(clearCache:)
                       name:UIApplicationDidReceiveMemoryWarningNotification
                     object:nil];
        }
        
    });
    
    return shareStore;
}

-(NSMutableDictionary *)cache
{
    if(!_cache) _cache = [[NSMutableDictionary alloc] init];
    return _cache;
}

#pragma mark -
-(void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.cache[key] = image;
}

-(UIImage *)imageForKey:(NSString *)key
{

    return self.cache[key];
}

#pragma mark -
//Notificatin trigger
- (void)clearCache:(NSNotification *)note
{
    DDLogWarn(@"Flushing %ul images out if the cache", [self.cache count]);
    [self.cache removeAllObjects];
}
@end
