#import "PhotoComposerViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

@implementation PhotoComposerViewController

@synthesize dateButton = _dateButton;
@synthesize commentButton = _commentButton;
@synthesize compositeBaseView = _compositeBaseView;
@synthesize imageView = _imageView;
@synthesize indicatorView = _indicatorView;
@synthesize toolBar = _toolBar;

@synthesize compositeOverlayViewController = _compositeOverlayViewController;
@synthesize cameraOverlayViewController = _cameraOverlayViewController;

@synthesize frameSelectorController = _frameSelectorController;
@synthesize imagePickerController = _imagePickerController;
@synthesize commentInputViewController = _commentInputViewController;

- (void)dealloc
{
    self.compositeOverlayViewController = nil;
    self.cameraOverlayViewController = nil;
    self.imagePickerController = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    self.compositeOverlayViewController = [[CameraOverlayViewController alloc] init];
    self.cameraOverlayViewController = [[CameraOverlayViewController alloc] init];

    self.frameSelectorController = [[FrameSelectorViewController alloc] init];
    
    self.compositeOverlayViewController.dateLabel.hidden = YES;
    self.compositeOverlayViewController.commentLabel.hidden = YES;
    [self.compositeBaseView addSubview:self.compositeOverlayViewController.view];

    self.cameraOverlayViewController.view.alpha = 0.5;
    self.imagePickerController.cameraOverlayView = self.cameraOverlayViewController.view;
    
    self.commentInputViewController = [[CommentInputViewController alloc] init];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    UIImage *selectedImage = self.frameSelectorController.selectedImage;
    if (selectedImage) {
        self.compositeOverlayViewController.frameImageView.image = selectedImage;
        self.cameraOverlayViewController.frameImageView.image = selectedImage;
    }
    
    if (self.commentInputViewController.commentText.length) {
        NSString *comment = self.commentInputViewController.commentText;
        [self.commentButton setTitle:comment forState:UIControlStateNormal];
        self.compositeOverlayViewController.commentLabel.text = comment;
        self.cameraOverlayViewController.commentLabel.text = comment;
    } else {
        [self.commentButton setTitle:NSLocalizedString(@"(Edit Comment)", @"") forState:UIControlStateNormal];
        self.compositeOverlayViewController.commentLabel.text = nil;
        self.cameraOverlayViewController.commentLabel.text = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Camera Actions

- (IBAction)editComment
{
    [self presentModalViewController:self.commentInputViewController animated:YES];
}

- (IBAction)switchDate
{
    dateEnabled = !dateEnabled;
    if (dateEnabled) {
        [self.dateButton setTitle:NSLocalizedString(@"Date On", @"") forState:UIControlStateNormal];
        NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
        self.compositeOverlayViewController.dateLabel.text = dateString;
        self.cameraOverlayViewController.dateLabel.text = dateString;
    } else {
        [self.dateButton setTitle:NSLocalizedString(@"Date Off", @"") forState:UIControlStateNormal];
        self.compositeOverlayViewController.dateLabel.text = nil;
        self.cameraOverlayViewController.dateLabel.text = nil;
    }
}

- (IBAction)selectFrame
{
    [self presentModalViewController:self.frameSelectorController animated:YES];
}

- (IBAction)activateCamera
{
    self.imagePickerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:self.imagePickerController animated:YES];
}

- (IBAction)savePhoto
{
    // UIを一時的に封印。
    self.indicatorView.hidden = NO;
    for (id object in self.toolBar.items) {
        [object setEnabled:NO];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.compositeOverlayViewController.dateLabel.hidden = NO;
        self.compositeOverlayViewController.commentLabel.hidden = NO;

        // 合成ビューのイメージを取得する。
        UIGraphicsBeginImageContextWithOptions(self.compositeBaseView.bounds.size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.compositeBaseView.layer renderInContext:context];
        UIImage *image = [UIGraphicsGetImageFromCurrentImageContext() retain];
        UIGraphicsEndImageContext();

        self.compositeOverlayViewController.dateLabel.hidden = YES;
        self.compositeOverlayViewController.commentLabel.hidden = YES;

        // カメラロールに保存。
        ALAssetsLibrary *library = [[[ALAssetsLibrary alloc] init] autorelease];
        [library writeImageToSavedPhotosAlbum:image.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSLog(@"ALAssetLibrary error - %@", error);
            } else {
                NSLog(@"Image saved: %@", assetURL);
            }
            [image release];

            // UIの封印を解除。
            self.indicatorView.hidden = YES;
            for (id object in self.toolBar.items) {
                [object setEnabled:YES];
            }
        }];
    });
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissModalViewControllerAnimated:YES];
}

@end
