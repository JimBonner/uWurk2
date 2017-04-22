//
//  PhotoImageView.m
//  uWurk2
//
//  Created by Rob Bonner on 12/31/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import "PhotoImageView.h"
#import "UrlImageRequest.h"


@implementation PhotoImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setBackgroundColor:[UIColor greenColor]];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleFingerTap];
    }
    return self;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"touch");
    if ( [self.delegate respondsToSelector:@selector(getImage)])
        [self.delegate getImage];
}

- (void)loadPhoto:(NSURL*)photoURL
{
    UrlImageRequest *photoRequest = [[UrlImageRequest alloc]initWithURL:photoURL];
    
    [photoRequest startWithCompletion:^(UIImage *newImage, NSError *error) {
        if(newImage) {
            [self setImage:newImage];
        }
    }];
}

@end
