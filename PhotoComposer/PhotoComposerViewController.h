#import <UIKit/UIKit.h>
#import "CameraOverlayViewController.h"
#import "FrameSelectorViewController.h"
#import "CommentInputViewController.h"

@interface PhotoComposerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    BOOL dateEnabled;
}

@property (nonatomic, retain) IBOutlet UIButton *dateButton;
@property (nonatomic, retain) IBOutlet UIButton *commentButton;
@property (nonatomic, retain) IBOutlet UIView *compositeBaseView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;

@property (nonatomic, retain) CameraOverlayViewController *compositeOverlayViewController;
@property (nonatomic, retain) CameraOverlayViewController *cameraOverlayViewController;

@property (nonatomic, retain) FrameSelectorViewController *frameSelectorController;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) CommentInputViewController *commentInputViewController;

- (IBAction)editComment;
- (IBAction)switchDate;
- (IBAction)selectFrame;
- (IBAction)activateCamera;
- (IBAction)savePhoto;

@end
