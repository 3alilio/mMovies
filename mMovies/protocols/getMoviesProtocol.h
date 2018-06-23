//
//  getMoviesProtocol.h
//  mMovies
//
//  Created by Admin on 5/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol getMoviesProtocol <NSObject>

-(void)updateMovies:(NSMutableArray*)movies;

-(void)firstPageMovies:(NSMutableArray*)movies;

@end
