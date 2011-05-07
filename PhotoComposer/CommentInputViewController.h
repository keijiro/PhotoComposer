#import <UIKit/UIKit.h>


@interface CommentInputViewController : UIViewController {
}

@property (nonatomic, retain) IBOutlet UITextField *textField;

@property (nonatomic, copy) NSString *commentText;

- (IBAction)done;
- (IBAction)cancel;

@end
