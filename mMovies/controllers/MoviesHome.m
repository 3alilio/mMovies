//
//  MoviesHome.m
//  mMovies
//
//  Created by Admin on 5/9/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "MoviesHome.h"

@interface MoviesHome (){
    NSMutableArray *myMovies;
    NSMutableArray *myFavoratieMovies;
    int page;
    
    NSString *type;
}

@end

@implementation MoviesHome
DataAccessLayer *dataAccessLayer;
static NSString * const reuseIdentifier = @"movieCell";
int flag=0;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"firstTime"]!=nil){
        if ([[AFNetworkReachabilityManager sharedManager] isReachable])
        {
            [self showFirstTimeAlert];
        }
        else
        {
            [defaults setObject:@"Yes" forKey:@"firstTime"];
            [defaults synchronize];
        }
        
    }
    
    
    
    
    
    myMovies = [NSMutableArray new];
    dataAccessLayer = [DataAccessLayer getSharedInstance];
    dataAccessLayer.updateMoviesProtocol=self;
        // Uncomment the following line to preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = NO;
    type=[Movie getPopularName];
    [dataAccessLayer getFirstPageDatatype:[Movie getPopularName]];
    page=2;
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    myFavoratieMovies=[dataAccessLayer getAllFavoraiteMovies];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //printf("%d",myMovies.count);
    return myMovies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    UIImageView *moviePoster = [cell viewWithTag:1];
    //moviePoster.image = [UIImage imageNamed:@"1.png"];
    Movie  *m = [myMovies objectAtIndex:indexPath.row];
    
    NSString *imageUrl= [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w185//%@",m.posterPath];
    NSLog(@"\n%@\n",imageUrl);
    
    [moviePoster sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                 placeholderImage:[UIImage imageNamed:@"help.png"]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Movie *movieSelected= [myMovies objectAtIndex:indexPath.row];
    
    MovieDetails *movieDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieDetails"];
    movieDetailView.detailedMovie=movieSelected;
    [self.navigationController pushViewController:movieDetailView animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.item==myMovies.count-1){
        [dataAccessLayer getPageData:page type:type];
        printf("\nPage : %d\n",page);
    }
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/


// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}


#pragma network



- (IBAction)segmentedControlAction:(id)sender {
    switch (_segmentedControlType.selectedSegmentIndex) {
        case 0:
            type=[Movie getPopularName];
            [dataAccessLayer getFirstPageDatatype:type];
            break;
        case 1:
             type=[Movie getTopratedName];
            [dataAccessLayer getFirstPageDatatype:type];
            break;
        case 2:
            type=[Movie getNowPlayingName];
            [dataAccessLayer getFirstPageDatatype:type];
            break;
        default:
            break;
    }
    page=2;
}

-(void)updateMovies:(NSMutableArray*)movies{
    if(movies==nil){
        [self showConnectionAlert];
    }else{
        for(Movie *temp in movies){
            
            for(Movie *favmovie in myFavoratieMovies)
            {
                if(temp.movieID==favmovie.movieID){
                    temp.isFavoraite=1;
                    break;
                }
            }
            [myMovies addObject:temp];
        }
        [self.collectionView reloadData];
        page++;
    }
   
}

-(void)showConnectionAlert{
    UIAlertController *connectionAlertView = [UIAlertController alertControllerWithTitle:@"Error" message:@"No internet Connection \n Connect your Internet and Try Again" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAlert =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [connectionAlertView addAction:dismissAlert];
    [self presentViewController:connectionAlertView animated:true completion:nil];
}



-(void)firstPageMovies:(NSMutableArray*)movies{
    if(movies==nil){
        [self showFirstTimeAlert];
        
    }
    else{
        myMovies=movies;
        if(flag==0){
            
            flag=1;
        }else{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO] ;
        }
        [self.collectionView reloadData];
    }
    
}


-(void)showFirstTimeAlert{
    UIAlertController *connectionAlertView = [UIAlertController alertControllerWithTitle:@"Error" message:@"Connect Your Internet AND Try Again" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAlert =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [connectionAlertView addAction:dismissAlert];
    [self presentViewController:connectionAlertView animated:true completion:nil];
}



@end
