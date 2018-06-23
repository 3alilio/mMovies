//
//  Movie.h
//  mMovies
//
//  Created by Admin on 5/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property int movieID;
@property BOOL video;
@property NSString *title;
@property NSString *releaseDate;
@property NSString *posterPath;
@property NSString *overview;
@property float voteRating;
@property NSString *type;
@property int isFavoraite;
@property NSMutableArray *youtubeKeys;
@property NSMutableArray *trailersName;
@property NSMutableArray *reviewAuthors;
@property NSMutableArray *reviewContent;


+(NSString*)getPopularName;
+(NSString*)getTopratedName;
+(NSString*)getNowPlayingName;


@end
