//
//  MoviesHome.h
//  mMovies
//
//  Created by Admin on 5/9/18.
//  Copyright © 2018 Admin. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Movie.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIKit+AFNetworking.h>
#import "MovieDetails.h"
#import "getMoviesProtocol.h"
#import "DataAccessLayer.h"

@interface MoviesHome : UICollectionViewController<getMoviesProtocol>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlType;

- (IBAction)segmentedControlAction:(id)sender;

@end
