//
//  Note.m
//  memorial_icloud
//
//  Created by Colin Yang Hong on 13-9-26.
//  Copyright (c) 2013年 Yang Hong. All rights reserved.
//

#import "Note.h"


@implementation Note

@dynamic title;
@dynamic content;
@dynamic create_at;
@dynamic modify_at;

-(NSString *) description{
    return [NSString stringWithFormat:@"%@ create at %@",self.title,self.create_at];
}

@end
