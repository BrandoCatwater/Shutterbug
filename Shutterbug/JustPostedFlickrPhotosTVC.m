//
//  JustPostedFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Brandon Chatreau on 2014-06-09.
//  Copyright (c) 2014 Brandon Chatreau. All rights reserved.
//

#import "JustPostedFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface JustPostedFlickrPhotosTVC ()

@end

@implementation JustPostedFlickrPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
    // Do any additional setup after loading the view.
}

- (IBAction)fetchPhotos
{
    [self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListsResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
        
        NSLog(@"Flickr resutlts = %@", propertyListsResults);
        NSArray *photos = [propertyListsResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });

    });
    
}


@end
