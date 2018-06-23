//
//  MovieDetails.h
//  mMovies
//
//  Created by Admin on 5/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIKit+AFNetworking.h>
#import "getReviewsProtocol.h"
#import "MovieReviews.h"
#import "DataAccessLayer.h"
#import "MoviesDataBase.h"
#import "TrailersView.h"
@interface MovieDetails : UIViewController <getReviewsProtocol>


@property MoviesDataBase *mdb;


- (IBAction)readReviewsAction:(id)sender;

@property DataAccessLayer *dataAccesLayer;

@property (weak, nonatomic) IBOutlet UIImageView *favImage;


- (IBAction)showTrailersAction:(id)sender;

@property Movie *detailedMovie;

@property (weak, nonatomic) IBOutlet UILabel *movieDate;

@property (weak, nonatomic) IBOutlet UILabel *movieRate;

@property (weak, nonatomic) IBOutlet UIImageView *moviePoster;


@property (weak, nonatomic) IBOutlet UITextView *Movieoverview;

@end
