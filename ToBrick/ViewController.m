#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.builds = [[NSMutableArray alloc] init];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.builds count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.builds[indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"buildSegue" sender:self.builds[indexPath.row]];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destination = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"buildSegue"]) {
        [destination setValue:sender forKeyPath:@"build"];
    } else {
        destination = [segue.destinationViewController topViewController];
    }
    
    [destination setValue:self forKeyPath:@"delegate"];
}

@end
