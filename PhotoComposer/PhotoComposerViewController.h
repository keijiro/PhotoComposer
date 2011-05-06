#import <UIKit/UIKit.h>
#import "CameraOverlayViewController.h"

@interface PhotoComposerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
}

@property (nonatomic, retain) IBOutlet UIView *compositeBaseView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) CameraOverlayViewController *compositeOverlayViewController;
@property (nonatomic, retain) CameraOverlayViewController *cameraOverlayViewController;

@property (nonatomic, retain) UIImagePickerController *imagePickerController;

- (IBAction)activateCamera;
- (IBAction)savePhoto;

@end
