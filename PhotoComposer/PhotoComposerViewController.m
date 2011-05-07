#import "PhotoComposerViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

@implementation PhotoComposerViewController

@synthesize compositeBaseView = _compositeBaseView;
@synthesize imageView = _imageView;
@synthesize indicatorView = _indicatorView;
@synthesize toolBar = _toolBar;

@synthesize compositeOverlayViewController = _compositeOverlayViewController;
@synthesize cameraOverlayViewController = _cameraOverlayViewController;

@synthesize imagePickerController = _imagePickerController;

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
    self.imagePickerController.showsCameraControls = YES;
    
    self.compositeOverlayViewController = [[CameraOverlayViewController alloc] init];
    self.cameraOverlayViewController = [[CameraOverlayViewController alloc] init];
    
    [self.compositeBaseView addSubview:self.compositeOverlayViewController.view];
    self.imagePickerController.cameraOverlayView = self.cameraOverlayViewController.view;

    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Camera Actions

- (IBAction)selectFrame
{
    NSLog(@"Select Frame");
}

- (IBAction)activateCamera
{
    [self presentModalViewController:self.imagePickerController animated:TRUE];
}

- (IBAction)savePhoto
{
    // UIを一時的に封印。
    self.indicatorView.hidden = NO;
    for (id object in self.toolBar.items) {
        [object setEnabled:NO];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 合成ビューのイメージを取得する。
        UIGraphicsBeginImageContextWithOptions(self.compositeBaseView.bounds.size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.compositeBaseView.layer renderInContext:context];
        UIImage *image = [UIGraphicsGetImageFromCurrentImageContext() retain];
        UIGraphicsEndImageContext();

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
