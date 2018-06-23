//
//  MoviesDataBase.h
//  mMovies
//
//  Created by Admin on 5/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import <sqlite3.h>

@interface MoviesDataBase : NSObject

@property (strong , nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *mMoviesDB;

-(void) createDB;

-(void) addMovie:(Movie*)movie;

-(void) deleteMovie:(Movie*)Movie;

-(NSMutableArray*) getAllMovies:(NSString*)type;

-(NSMutableArray*) getAllFavoraiteMovies;

-(void) updateMovie:(Movie*)movie;




@end
