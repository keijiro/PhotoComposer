#import <UIKit/UIKit.h>

@interface FrameSelectorViewController : UIViewController {
}

@property (nonatomic, retain) UIImage *selectedImage;

- (IBAction)selectFrame:(id)sender;
- (IBAction)cancel;

@end
