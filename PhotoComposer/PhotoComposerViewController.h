#import <UIKit/UIKit.h>
#import "CameraOverlayViewController.h"
#import "FrameSelectorViewController.h"

@interface PhotoComposerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
}

@property (nonatomic, retain) IBOutlet UIView *compositeBaseView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;

@property (nonatomic, retain) CameraOverlayViewController *compositeOverlayViewController;
@property (nonatomic, retain) CameraOverlayViewController *cameraOverlayViewController;

@property (nonatomic, retain) FrameSelectorViewController *frameSelectorController;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;

- (IBAction)selectFrame;
- (IBAction)activateCamera;
- (IBAction)savePhoto;

@end
