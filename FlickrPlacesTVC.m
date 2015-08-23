//
//  FlickrPlacesTVC.m
//  Flickr Image Viewer
//
//  Created by Chris on 8/4/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#import "FlickrPlacesTVC.h"
#import "FlickrFetcher.h"
#import "FlickrPhotosTVC.h"

@interface FlickrPlacesTVC ()

@end

@implementation FlickrPlacesTVC

-(void) setPlaces:(NSArray *)places {
   _places = places;
   [self.tableView reloadData];
}

-(void) setCountries:(NSArray *)countries {
   _countries = countries;
   [self.tableView reloadData];
}

-(void) setPlacesInCountry:(NSDictionary *)placesInCountry {
   _placesInCountry = placesInCountry;
   [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
   return [self.countries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // return [self.places count];
   return [self.placesInCountry[self.countries[section]] count];
}


- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
   return self.countries[section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Place Cell" forIndexPath:indexPath];
    
    // Configure the cell...
   NSDictionary *place = self.placesInCountry[self.countries[indexPath.section]][indexPath.row];
   //self.places[indexPath.row];
   cell.textLabel.text = [place valueForKeyPath:FLICKR_PLACE_CITY];
   cell.detailTextLabel.text = [[place valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "][1];
   
   return cell;
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


#pragma mark - Navigation

-(void) prepareFlickrPhotosTVC:(FlickrPhotosTVC *)ivc toDisplayPlace:(NSDictionary *)place {
   ivc.placeData = [place valueForKeyPath:FLICKR_PLACE_ID];
   ivc.title = [place valueForKeyPath:FLICKR_PLACE_CITY];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
   if ([segue.identifier isEqualToString:@"Display Photos At Location"]) {
      if ([segue.destinationViewController isKindOfClass:[FlickrPhotosTVC class]]) {
         [self prepareFlickrPhotosTVC:segue.destinationViewController toDisplayPlace:self.placesInCountry[self.countries[indexPath.section]][indexPath.row]];
      }
   }
}


@end
