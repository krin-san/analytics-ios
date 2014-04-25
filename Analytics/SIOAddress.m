//
//  SIOLocation.m
//  Analytics
//
//  Created by Travis Jeffery on 4/25/14.
//  Copyright (c) 2014 Segment.io. All rights reserved.
//

#import "SIOAddress.h"

#import <CoreLocation/CoreLocation.h>


@interface SIOAddress () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLPlacemark *currentPlacemark;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation SIOAddress

- (id)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _geocoder = [[CLGeocoder alloc] init];
        // need to start updating location at some point
    }
    return self;
}

- (NSString *)state {
    return self.currentPlacemark.administrativeArea;
}

- (NSString *)country {
    return self.currentPlacemark.country;
}

- (NSString *)city {
    return self.currentPlacemark.locality;
}

- (NSString *)postalCode {
    return self.currentPlacemark.postalCode;
}

- (NSString *)street {
    return self.currentPlacemark.thoroughfare;
}

- (BOOL)hasKnownLocation {
    return self.currentPlacemark != nil;
}

- (NSNumber *)latitude {
    return @(self.currentPlacemark.location.coordinate.latitude);
}

- (NSNumber *)longitude {
    return @(self.currentPlacemark.location.coordinate.longitude);
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (!locations.count) return;
    
    [self.geocoder reverseGeocodeLocation:locations.firstObject completionHandler:^(NSArray *placemarks, NSError *error) {
        self.currentPlacemark = placemarks.firstObject;
    }];
}

@end
