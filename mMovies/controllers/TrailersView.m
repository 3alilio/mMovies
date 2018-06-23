//
//  TrailersView.m
//  mMovies
//
//  Created by Admin on 5/15/18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "TrailersView.h"

@interface TrailersView ()

@end

@implementation TrailersView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _movie.youtubeKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trailerCell"];
    
    UIImageView *playImage=[cell viewWithTag:1];
    UILabel *trailerName = [cell viewWithTag:2];
    
    trailerName.text = [_movie.trailersName objectAtIndex:indexPath.row];
    playImage.image = [UIImage imageNamed:@"play.png"];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //printf("You select Trailer %d",indexPath.row);
    NSString *url = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",[_movie.youtubeKeys objectAtIndex:indexPath.row]];
    
    NSString *youtubeURL = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",[_movie.youtubeKeys objectAtIndex:indexPath.row]];
    // Page name(or channel name)
    
    // Check if the device can open in Youtube app or not.
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: youtubeURL]]){
        // Open in Youtube app
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: youtubeURL]];
    }else{
        // If device cannot open in youtube app, open the page in browser.
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
    }
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;{
    return @"Trailers";
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
