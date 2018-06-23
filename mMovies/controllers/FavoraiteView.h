//
//  FavoraiteView.h
//  mMovies
//
//  Created by Admin on 5/15/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Movie.h"
#import "DataAccessLayer.h"

@interface FavoraiteView : UITableViewController

@property NSMutableArray *myFavMovies;
@property DataAccessLayer *connection;
@end
