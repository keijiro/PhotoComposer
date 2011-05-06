//
//  PhotoComposerAppDelegate.h
//  PhotoComposer
//
//  Created by 高橋 啓治郎 on 11/05/06.
//  Copyright 2011 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoComposerViewController;

@interface PhotoComposerAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet PhotoComposerViewController *viewController;

@end
