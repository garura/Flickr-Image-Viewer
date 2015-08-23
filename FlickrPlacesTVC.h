//
//  FlickrPlacesTVC.h
//  Flickr Image Viewer
//
//  Created by Chris on 8/4/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPlacesTVC : UITableViewController
@property (strong, nonatomic) NSArray *places;
@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSDictionary *placesInCountry;
@end
