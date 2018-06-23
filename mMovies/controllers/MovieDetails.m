//
//  MovieDetails.m
//  mMovies
//
//  Created by Admin on 5/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "MovieDetails.h"

@interface MovieDetails ()
@end

@implementation MovieDetails
UIActivityIndicatorView *loadReviewsIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
// Do any additional setup after loading the view.
    _dataAccesLayer = [DataAccessLayer getSharedInstance];
    _movieDate.text=_detailedMovie.releaseDate;
    _movieRate.text=[NSString stringWithFormat:@"%.2f / 10",_detailedMovie.voteRating];
    NSString *imageUrl= [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w185//%@",_detailedMovie.posterPath];
    [_moviePoster sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                   placeholderImage:[UIImage imageNamed:@"help.png"]];
    loadReviewsIndicator = [[UIActivityIndicatorView alloc]
                                                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadReviewsIndicator.center=self.view.center;
    loadReviewsIndicator.hidesWhenStopped=true;
    loadReviewsIndicator.color=[UIColor orangeColor];
    [self.view addSubview:loadReviewsIndicator];
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favoraiteAction:)];
    rec.numberOfTapsRequired=1;
    _favImage.userInteractionEnabled=TRUE;
    [_favImage addGestureRecognizer:rec];
    if(_detailedMovie.isFavoraite==1){
        _favImage.image=[UIImage imageNamed:@"favoraite.png"];
    }else{
         _favImage.image=[UIImage imageNamed:@"unfavoraite.png"];
    }
    _Movieoverview.text=_detailedMovie.overview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)favoraiteAction:(UITapGestureRecognizer*)sender {
    printf("HElo\n");
    _mdb =[MoviesDataBase new];
    if(_detailedMovie.isFavoraite==0){
        printf("HEllo fav \n");
        _detailedMovie.isFavoraite=1;
       _favImage.image=[UIImage imageNamed:@"favoraite.png"] ;
        [_dataAccesLayer upateMovie:_detailedMovie];
        [_mdb updateMovie:_detailedMovie];
    }else{
        printf("HElo unfav\n");
        _detailedMovie.isFavoraite=0;
        _favImage.image=[UIImage imageNamed:@"unfavoraite.png"] ;
        [_dataAccesLayer upateMovie:_detailedMovie];
          [_mdb updateMovie:_detailedMovie];
    }
}


-(void)loadTrailers{
    _detailedMovie.youtubeKeys=[NSMutableArray new];
    _detailedMovie.trailersName=[NSMutableArray new];
    NSString *url =[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d/videos?api_key=efbbfb76c9deb72102c22be8664fb8b3",_detailedMovie.movieID];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *movieTrailersResponse =(NSDictionary*) responseObject;
        NSMutableArray *trailersKeys =(NSMutableArray*)[movieTrailersResponse objectForKey:@"results"];
        for(NSDictionary *temp in trailersKeys){
            [self->_detailedMovie.youtubeKeys addObject:[temp objectForKey:@"key"]];
            [self->_detailedMovie.trailersName addObject:[temp objectForKey:@"name"]];
            //printf("\n%s\n",[[temp objectForKey:@"name"] UTF8String]);
        }
       // [self.trailersTable reloadData];
        printf("%s",[self->_detailedMovie.overview UTF8String]);
        if(self->_detailedMovie.youtubeKeys.count>0){
            TrailersView *trailersView = [self.storyboard instantiateViewControllerWithIdentifier:@"TrailersView"];
            trailersView.movie=self->_detailedMovie;
            [self.navigationController pushViewController:trailersView animated:YES];
        }else{
            [self showNoTrailersAlert];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showConnectionAlert];
        printf("\nError Retieving youtube links\n");
    }];
}
- (IBAction)readReviewsAction:(id)sender {
        if ([[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            [self showConnectionAlert];
        }
        else
        {
            [loadReviewsIndicator startAnimating];
            _dataAccesLayer=[DataAccessLayer getSharedInstance];
            _dataAccesLayer.getMovieReviews=self;
            [_dataAccesLayer getReviews:_detailedMovie];
            
        }
}

-(void)getMovieReviews:(Movie*)movie{
    [loadReviewsIndicator stopAnimating];
    if(movie.reviewContent.count>0){
        MovieReviews *reviewsView = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieReviews"];
        reviewsView.movie=movie;
        [self.navigationController pushViewController:reviewsView animated:YES];
    }else if (movie.reviewContent==nil){
         [self showConnectionAlert];
    }else{
       [self showNoTrailersAlert];
    }
}

- (IBAction)showTrailersAction:(id)sender {
    if ([[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        [self showConnectionAlert];
    }
    else
    {
         [self loadTrailers];
    }
}

-(void)showConnectionAlert{
    UIAlertController *connectionAlertView = [UIAlertController alertControllerWithTitle:@"Error" message:@"No internet Connection \n Connect your Internet and Try Again" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAlert =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [connectionAlertView addAction:dismissAlert];
    [self presentViewController:connectionAlertView animated:true completion:nil];
    [loadReviewsIndicator stopAnimating];
}

-(void)showNoTrailersAlert{
    UIAlertController *connectionAlertView = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"No Trailers To Show" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAlert =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [connectionAlertView addAction:dismissAlert];
    [self presentViewController:connectionAlertView animated:true completion:nil];
}
@end
