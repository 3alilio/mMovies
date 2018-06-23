//
//  getReviewsProtocol.h
//  mMovies
//
//  Created by Admin on 5/15/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@protocol getReviewsProtocol <NSObject>

-(void)getMovieReviews:(Movie*)movie;

@end
