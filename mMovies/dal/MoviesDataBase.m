//
//  MoviesDataBase.m
//  mMovies
//
//  Created by Admin on 5/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "MoviesDataBase.h"

@implementation MoviesDataBase
NSString *docsDir;
NSArray *dirPaths;
const char *dbpath;

-(id) init{
    
    self=[super init];
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"mMovies.db"]];
    dbpath = [_databasePath UTF8String];
    return self;
}

-(void) createDB{
    if (sqlite3_open(dbpath, &_mMoviesDB) == SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt =
        "CREATE TABLE IF NOT EXISTS MOVIES (ID INTEGER PRIMARY KEY, TITLE TEXT, POSTERPATH TEXT, OVERVIEW TEXT,TYPE TEXT,RELEASEDATE Text, RATING FLOAT,ISFAVORAITE INTEGER)";
        printf("DataBase exists\n");
        if (sqlite3_exec(_mMoviesDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            printf("Failed to open/create database");
        }
        sqlite3_close(_mMoviesDB);
    } else {
        printf("Failed to open/create database");
    }
    
}

-(void) addMovie:(Movie*)movie{
    printf("Hello From ADD MOVIE\n");
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_mMoviesDB) == SQLITE_OK)
    {
        printf("Hello From Function");
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO MOVIES (ID, TITLE, POSTERPATH, OVERVIEW ,TYPE ,RELEASEDATE , RATING,ISFAVORAITE) VALUES (\"%d\",\"%@\",\"%@\", \"%@\", \"%@\",\"%@\", \"%f\", \"%d\")",movie.movieID,movie.title,movie.posterPath,movie.overview,movie.type,movie.releaseDate,movie.voteRating,movie.isFavoraite];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_mMoviesDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            printf("Added\n");
        } else {
            printf("Can't Add\n");
            // printf("%s",)
        }
        sqlite3_finalize(statement);
        sqlite3_close(_mMoviesDB);
    }
}



-(void) deleteMovie:(Movie *)Movie{
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_mMoviesDB) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:
                               @"DELETE  FROM MOVIES WHERE ID=\"%d\"",
                               Movie.movieID];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_mMoviesDB, delete_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            printf("Deleted");
        } else {
            printf("Can't Delete");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_mMoviesDB);
    }
}

-(NSMutableArray*) getAllMovies:(NSString *)type{
    NSMutableArray *allMovies = [NSMutableArray new];
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_mMoviesDB) == SQLITE_OK)
    {
        NSString *reteiveSQL =[NSString stringWithFormat:@"Select ID, TITLE, POSTERPATH, OVERVIEW ,TYPE ,RELEASEDATE , RATING,ISFAVORAITE from MOVIES WHERE TYPE = \'%@\'",type];
        
        const char *reteive_stmt = [reteiveSQL UTF8String];
        if(sqlite3_prepare_v2(_mMoviesDB, reteive_stmt,-1, &statement, NULL)==SQLITE_OK)
            
            //        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            
            NSLog(@"%d",sqlite3_step(statement));
            while(sqlite3_step(statement) == SQLITE_ROW){
                
                NSString *movieId = [[NSString alloc]initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];
                
                int movieid = [movieId intValue];
                NSString *title = [[NSString alloc]initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *posterPath = [[NSString alloc]initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *overview = [[NSString alloc]initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *type = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 4)];
                NSString *releaseDate = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *rating = [[NSString alloc]initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 6)];
                
                float rate = [rating floatValue];
                
                NSString *isFav = [[NSString alloc]initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 7)];
                
                int isFavoraite = [isFav intValue];
                
                Movie *movieTemp = [Movie new];
                movieTemp.title=title;
                movieTemp.overview=overview;
                movieTemp.posterPath = posterPath;
                movieTemp.type=type;
                movieTemp.isFavoraite=isFavoraite;
                movieTemp.movieID=movieid;
                movieTemp.voteRating=rate;
                movieTemp.releaseDate=releaseDate;
                
                [allMovies addObject:movieTemp];
                printf("Movie retieved \n");
            }
            printf("data retrieved \n");
        }else {
            printf("Can't get Data");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_mMoviesDB);
    }
    
    return allMovies;
}




-(NSMutableArray*) getAllFavoraiteMovies{
    NSMutableArray *allMovies = [NSMutableArray new];
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_mMoviesDB) == SQLITE_OK)
    {
        NSString *reteiveSQL =[NSString stringWithFormat:@"Select ID, TITLE, POSTERPATH, OVERVIEW ,TYPE ,RELEASEDATE , RATING,ISFAVORAITE from MOVIES WHERE ISFAVORAITE =\"%d\"",1];
        
        const char *reteive_stmt = [reteiveSQL UTF8String];
        if(sqlite3_prepare_v2(_mMoviesDB, reteive_stmt,-1, &statement, NULL)==SQLITE_OK)
            
            //        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            
            NSLog(@"%d",sqlite3_step(statement));
            while(sqlite3_step(statement) == SQLITE_ROW){
                
                NSString *movieId = [[NSString alloc]initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];
                
                int movieid = [movieId intValue];
                NSString *title = [[NSString alloc]initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *posterPath = [[NSString alloc]initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *overview = [[NSString alloc]initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *type = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 4)];
                NSString *releaseDate = [[NSString alloc]initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *rating = [[NSString alloc]initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 6)];
                
                float rate = [rating floatValue];
                
                NSString *isFav = [[NSString alloc]initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 7)];
                
                int isFavoraite = [isFav intValue];
                
                Movie *movieTemp = [Movie new];
                movieTemp.title=title;
                movieTemp.overview=overview;
                movieTemp.posterPath = posterPath;
                movieTemp.type=type;
                movieTemp.isFavoraite=isFavoraite;
                movieTemp.movieID=movieid;
                movieTemp.voteRating=rate;
                movieTemp.releaseDate=releaseDate;
                
                [allMovies addObject:movieTemp];
                printf("Movie retieved \n");
            }
            printf("data retrieved \n");
        }else {
            printf("Can't get Data");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_mMoviesDB);
    }
    
    return allMovies;
}








-(void) updateMovie:(Movie*)movie{
    printf("\nHello From myconnection update\n");
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_mMoviesDB) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:
                               @"UPDATE MOVIES SET ID= \"%d\" , TITLE= \"%@\" , POSTERPATH= \"%@\" , OVERVIEW= \"%@\" , TYPE= \"%@\" , RELEASEDATE= \"%@\" , RATING= \"%f\" , ISFAVORAITE= \"%d\" WHERE ID= \"%d\"",movie.movieID,movie.title,movie.posterPath,movie.overview,movie.type,movie.releaseDate,movie.voteRating,movie.isFavoraite,movie.movieID];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_mMoviesDB, delete_stmt,
                           -1, &statement, NULL);
        printf("%d\n",sqlite3_prepare_v2(_mMoviesDB, delete_stmt,
                                         -1, &statement, NULL));
        printf("%d\n",sqlite3_step(statement));
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            printf("\nUpdated\n");
        } else {
            printf("Can't Update");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_mMoviesDB);
    }
    
}







@end
