//
//  ImageCache.m
//  zup
//

#import "ImageCache.h"

@implementation ImageCache

static ImageCache* _defaultCache = nil;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self->images = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (ImageCache*)defaultCache
{
    if (!_defaultCache)
        _defaultCache = [[ImageCache alloc] init];
    
    return _defaultCache;
}

//- (UIImage*)imageWithId:(int)imageid
- (UIImage*)imageWithName:(NSString*)key
{
    //NSString* key = [[NSNumber numberWithInt:imageid] stringValue];
    return [self->images valueForKey:key];
}

//- (void)addImage:(UIImage*)image withId:(int)imageid
- (void)addImage:(UIImage*)image withName:(NSString*)key
{
    //NSString* key = [[NSNumber numberWithInt:imageid] stringValue];
    [self->images setValue:image forKey:key];
}

@end
