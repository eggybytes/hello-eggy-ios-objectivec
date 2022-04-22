#import "BuildViewController.h"
#import "ViewController.h"

@interface BuildViewController ()

@end

@implementation BuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buildLabel.text = self.build;
}

- (IBAction)completeBuild:(id)sender {
    ViewController *buildsListView = self.delegate;
    [buildsListView.builds removeObject:self.build];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
