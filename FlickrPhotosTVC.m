//
//  FlickrPhotosTVC.m
//  Flickr Image Viewer
//
//  Created by Chris on 8/4/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#import "FlickrPhotosTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface FlickrPhotosTVC ()

@end

@implementation FlickrPhotosTVC

- (void)viewDidLoad {
   [super viewDidLoad];
   [self fetchPhotos];
}


-(IBAction) fetchPhotos {
   // fetch url for place_id (from placeData)
   [self.refreshControl beginRefreshing];
   NSURL *url = [FlickrFetcher URLforPhotosInPlace:_placeData maxResults:50];
   dispatch_queue_t fetchQphoto = dispatch_queue_create("flicker photo fetcher", NULL);
   dispatch_async(fetchQphoto, ^{
      NSData *jsonResults = [NSData dataWithContentsOfURL:url];
      NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                          options:0
                                                                            error:NULL];
    //NSLog(@"Flickr results = %@", propertyListResults);
      NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
      dispatch_async(dispatch_get_main_queue(), ^{
         [self.refreshControl endRefreshing];
         self.photos = photos;
      });
   });
}



-(void) setPhotos:(NSArray *)photos {
   _photos = photos;
   [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
   NSDictionary *photo = self.photos[indexPath.row];
   if (![[photo valueForKeyPath:FLICKR_PHOTO_TITLE] isEqualToString:@""]) {
      cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
      cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
   }
   else if (![[photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] isEqualToString:@""]) {
      cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
      cell.detailTextLabel.text = @"";
   }
   else {
      cell.textLabel.text = @"Unknown";
      cell.detailTextLabel.text = @"";
   }
   return cell;
}


#pragma mark - Table view delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   id detail = self.splitViewController.viewControllers[1];
   if ([detail isKindOfClass:[UINavigationController class]]) {
      detail = [((UINavigationController *)detail).viewControllers firstObject];
   }
   if ([detail isKindOfClass:[ImageViewController class]]) {
      [self prepareImageViewController:detail toDisplayPhoto:self.photos[indexPath.row]];
   }
}



#pragma mark - Navigation

-(void)prepareImageViewController:(ImageViewController *)ivc toDisplayPhoto:(NSDictionary *)photo {
   ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
   ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
   if ([segue.identifier isEqualToString:@"Display Photo"]) {
      if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
         [self prepareImageViewController:segue.destinationViewController toDisplayPhoto:self.photos[indexPath.row]];
      }
   }
}























@end
