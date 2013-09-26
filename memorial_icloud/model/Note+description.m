//
//  Note+description.m
//  memorial_icloud
//
//  Created by Colin Yang Hong on 13-9-26.
//  Copyright (c) 2013年 Yang Hong. All rights reserved.
//

#import "Note+description.h"

@implementation Note (description)

-(NSString *) description{
    return [NSString stringWithFormat:@"%@ create at %@",self.content,self.create_at];
}

@end
