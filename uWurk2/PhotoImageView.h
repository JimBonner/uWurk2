//
//  PhotoImageView.h
//  uWurk2
//
//  Created by Rob Bonner on 12/31/15.
//  Copyright (c) 2015 Michael Brown. All rights reserved.
//  Copyright (c) 2017 Jim Bonner. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PhotoImageViewGetImageProtocol <NSObject>
-(void)getImage;
@end

@interface PhotoImageView : UIImageView

- (void)loadPhoto:(NSURL*)photoURL;
@property(nonatomic, assign) id delegate;

@end
