//
//  FlickrPhotosTVC.h
//  Flickr Image Viewer
//
//  Created by Chris on 8/4/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotosTVC : UITableViewController
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) id placeData;
@end
