//
//  BackendData.h
//  ParkShark
//
//  Created by Steven Gerhard on 2/21/15.
//  Copyright (c) 2015 ParkShark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackendData : NSObject

typedef void(^completion)(NSMutableArray*);

-(void)getParkingLotData:(completion)parkingLotData;

@end
