#import <UIKit/UIKit.h>

@interface NewBuildViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)saveBuild:(id)sender;

- (IBAction)close:(id)sender;

@property (weak, nonatomic) id delegate;

@end
