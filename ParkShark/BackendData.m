//
//  BackendData.m
//  ParkShark
//
//  Created by Steven Gerhard on 2/21/15.
//  Copyright (c) 2015 ParkShark. All rights reserved.
//
//  Access ParkShark API to grab all parkinglot data

#import "BackendData.h"

@implementation BackendData

static NSString *const apiLotsURL = @"http://parkshark.justintimmons.org/api/lots/";

-(void)getParkingLotData:(completion)parkingLotData
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:apiLotsURL]];
    
    __block NSMutableArray *allLotData = [[NSMutableArray alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data) {
                                   NSDictionary *jsonAllLots;
                                   jsonAllLots = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];
                                   
                                   NSMutableArray *apiLotTags = [[NSMutableArray alloc] init];
                                   
                                   if([jsonAllLots isKindOfClass:[NSArray class]]) {
                                       for (NSDictionary *parkingLot in (NSArray *)jsonAllLots) {
                                           NSString *safeName = [parkingLot objectForKey:@"safe_name"];
                                           [apiLotTags addObject:safeName];
                                       }
                                   }
                                   for(NSString *lotTag in apiLotTags) {
                                       NSString *lotAPI = [apiLotsURL stringByAppendingString:lotTag];
                                       
                                       NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:lotAPI]];
                                       
                                       NSData *specificLotData = [NSURLConnection sendSynchronousRequest:request
                                                                               returningResponse:nil
                                                                                           error:nil];
                                       if (specificLotData) {
                                           NSDictionary *jsonLot = [NSJSONSerialization JSONObjectWithData:specificLotData
                                                                                               options:0
                                                                                                 error:nil];
                                           [allLotData addObject:jsonLot];
                                       }
                                       else {
                                           NSLog(@"Failure retrieving %@  lot data", lotTag);
                                       }
                                   }
                                   // return the array of all parkinglot data through completion block
                                   parkingLotData(allLotData);
                               }
                               
                               else {
                                   NSLog(@"Failure retrieving api lot safe names");
                               }
                           }];
}

@end