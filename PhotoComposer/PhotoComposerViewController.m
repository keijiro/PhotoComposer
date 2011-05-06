#import "PhotoComposerViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

@implementation PhotoComposerViewController

@synthesize compositeBaseView = _compositeBaseView;
@synthesize imageView = _imageView;

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
    [self.imagePickerController.cameraOverlayView addSubview:self.cameraOverlayViewController.view];

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

- (IBAction)activateCamera
{
    [self presentModalViewController:self.imagePickerController animated:TRUE];
}

- (IBAction)savePhoto
{
    UIGraphicsBeginImageContextWithOptions(self.compositeBaseView.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.compositeBaseView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    ALAssetsLibrary *library = [[[ALAssetsLibrary alloc] init] autorelease];
    [library writeImageToSavedPhotosAlbum:image.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
        NSLog(@"Written: %@, %@", assetURL, error);
        [image autorelease];
     }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissModalViewControllerAnimated:YES];
}

@end
