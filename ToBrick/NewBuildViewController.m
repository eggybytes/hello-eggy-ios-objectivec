#import "NewBuildViewController.h"
#import "ViewController.h"

@interface NewBuildViewController ()

@end

@implementation NewBuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveBuild:(id)sender {
    if ([self.textField.text length] == 0) {
        return;
    }
    
    ViewController *buildsListView = (ViewController *)self.delegate;
    [buildsListView.builds addObject:self.textField.text];
    [self close:sender];
}
@end
