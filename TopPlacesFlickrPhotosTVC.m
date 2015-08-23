//
//  TopPlacesFlickrPhotosTVC.m
//  Flickr Image Viewer
//
//  Created by Chris on 8/4/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#import "TopPlacesFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface TopPlacesFlickrPhotosTVC ()

@end

@implementation TopPlacesFlickrPhotosTVC


- (void)viewDidLoad {
   [super viewDidLoad];
   [self fetchPlaces];
}

-(IBAction) fetchPlaces {
   [self.refreshControl beginRefreshing];
   NSURL *url = [FlickrFetcher URLforTopPlaces];
   dispatch_queue_t fetchQplace = dispatch_queue_create("flicker place fetcher", NULL);
   dispatch_async(fetchQplace, ^{
      NSData *jsonResults = [NSData dataWithContentsOfURL:url];
      NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                              options:0
                                                                error:NULL];
      NSLog(@"Flickr results = %@", results);
      NSArray *places = [results valueForKeyPath:FLICKR_RESULTS_PLACES];
      dispatch_async(dispatch_get_main_queue(), ^{
         [self.refreshControl endRefreshing];
         self.places = places;
         self.countries = [FlickrFetcher countryListfromPlaces:self.places];
         self.placesInCountry = [FlickrFetcher placesFromCountries:self.countries inPlaces:self.places];
      });
   });
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
@end
