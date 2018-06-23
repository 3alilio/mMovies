//
//  Movie.m
//  mMovies
//
//  Created by Admin on 5/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "Movie.h"

@implementation Movie

static NSString * const typePopular = @"popular";
static NSString * const typeTopRated = @"top_rated";
static NSString * const typeNowPlaying= @"now_playing";

+(NSString*)getPopularName{
    return typePopular;
}
+(NSString*)getTopratedName{
    return typeTopRated;
}
+(NSString*)getNowPlayingName{
    return typeNowPlaying;
}

@end
