//
//  DataAccessLayer.h
//  mMovies
//
//  Created by Admin on 5/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit+AFNetworking.h>
#import "Movie.h"
#import "getMoviesProtocol.h"
#import "MoviesDataBase.h"
#import "getReviewsProtocol.h"

@interface DataAccessLayer : NSObject 

@property MoviesDataBase  *dataBaseConnection;

@property id<getReviewsProtocol> getMovieReviews;

@property id<getMoviesProtocol> updateMoviesProtocol;

+(instancetype)getSharedInstance;

-(void) getFirstPageDatatype: (NSString*)type;

-(void) getPageData: (int)pageno type: (NSString*)type;

-(void)getReviews:(Movie*)movie;

-(void)upateMovie:(Movie*)movie;

-(NSMutableArray*) getAllFavoraiteMovies;

@end
