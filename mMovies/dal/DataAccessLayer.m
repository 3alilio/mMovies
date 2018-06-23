//
//  DataAccessLayer.m
//  mMovies
//
//  Created by Admin on 5/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "DataAccessLayer.h"

@implementation DataAccessLayer

+(instancetype)getSharedInstance{
    
    static DataAccessLayer *sharedInstance =nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate,^{
        sharedInstance = [[DataAccessLayer alloc]init];
        
    });
   
    return sharedInstance;
}


-(id)init{
    self=[super init];
    _dataBaseConnection=[MoviesDataBase new];
    [_dataBaseConnection createDB];
    return self;
}

-(void) getFirstPageDatatype: (NSString*)type{

   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:type]!=nil){
        printf("/n/nmovies from data base/n");
          [self->_updateMoviesProtocol  firstPageMovies:[_dataBaseConnection getAllMovies:type]];
    }else{
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        NSString *url = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=ad7b6dbe2cd8c3b637d59a7ac1677960",type];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableArray *myMovies = [NSMutableArray new];
            NSDictionary *mydic =(NSDictionary*) responseObject;
            NSMutableArray *myMovies2 =(NSMutableArray*)[mydic objectForKey:@"results"];
            for(NSDictionary *temp in myMovies2){
                Movie *movieTemp =[Movie new];
                movieTemp.title = [temp objectForKey:@"title"];
                movieTemp.posterPath = [temp objectForKey:@"poster_path"];
                movieTemp.releaseDate = [temp objectForKey:@"release_date"];
                movieTemp.voteRating=[[temp objectForKey:@"vote_average"] floatValue];
                movieTemp.overview = [temp objectForKey:@"overview"];
                movieTemp.movieID =[[temp objectForKey:@"id"] intValue];
                movieTemp.type=type;
                [myMovies addObject:movieTemp];
                [_dataBaseConnection addMovie:movieTemp];
            }
            [defaults setInteger:1 forKey:type];
            [defaults synchronize];
            [self->_updateMoviesProtocol  firstPageMovies:myMovies];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            printf("Error");
             [self->_updateMoviesProtocol  firstPageMovies:nil];
        }];
   }
}



-(void) getPageData: (int)pageno type: (NSString*)type{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?page=%d&api_key=ad7b6dbe2cd8c3b637d59a7ac1677960",type,pageno];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *myMovies = [NSMutableArray new];
        NSDictionary *mydic =(NSDictionary*) responseObject;
        NSMutableArray *myMovies2 =(NSMutableArray*)[mydic objectForKey:@"results"];
        for(NSDictionary *temp in myMovies2){
            Movie *movieTemp =[Movie new];
            movieTemp.title = [temp objectForKey:@"title"];
            movieTemp.posterPath = [temp objectForKey:@"poster_path"];
            movieTemp.releaseDate = [temp objectForKey:@"release_date"];
            movieTemp.voteRating=[[temp objectForKey:@"vote_average"] floatValue];
            movieTemp.overview = [temp objectForKey:@"overview"];
            movieTemp.movieID =[[temp objectForKey:@"id"] intValue];
            [myMovies addObject:movieTemp];
        }
        [self->_updateMoviesProtocol  updateMovies:myMovies];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        printf("Error");
        [self->_updateMoviesProtocol  updateMovies:nil];
    }];
}


-(void)getReviews:(Movie*)movie{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d/reviews?api_key=ad7b6dbe2cd8c3b637d59a7ac1677960",movie.movieID];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        movie.reviewAuthors = [NSMutableArray new];
        movie.reviewContent = [NSMutableArray new];
        NSDictionary *mydic =(NSDictionary*) responseObject;
        NSMutableArray *myMovies2 =(NSMutableArray*)[mydic objectForKey:@"results"];
        for(NSDictionary *temp in myMovies2){
            [ movie.reviewAuthors addObject: [temp objectForKey:@"author"]];
            [movie.reviewContent addObject: [temp objectForKey:@"content"]];
                 }
        [_getMovieReviews getMovieReviews:movie];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        printf("Error");
        [_getMovieReviews getMovieReviews:nil];
    }];
}


-(void)upateMovie:(Movie*)movie{
    [_dataBaseConnection updateMovie:movie];
}

-(NSMutableArray*) getAllFavoraiteMovies{
   return [_dataBaseConnection getAllFavoraiteMovies];
}


@end
