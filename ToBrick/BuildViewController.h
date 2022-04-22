#import <UIKit/UIKit.h>

@interface BuildViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *buildLabel;
- (IBAction)completeBuild:(id)sender;

@property (weak, nonatomic) NSString *build;
@property (weak, nonatomic) id delegate;

@end
