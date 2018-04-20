//
//  ViewController.m
//  AtomSDK Demo

#import "ViewController.h"
#import "AppDelegate.h"
#import "PopOverViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate>

@property (nonatomic) NSArray *connectionList;
@property (nonatomic) NSArray *viewControllerList;

@property (nonatomic) IBOutlet UITableView *tableViewConnectionList;
@property (nonatomic) IBOutlet UISwitch *switchUserCredentials;

@property (nonatomic) IBOutlet UILabel *labelUsername;
@property (nonatomic) IBOutlet UILabel *labelPassword;
@property (nonatomic) IBOutlet UILabel *labelUDID;
@property (nonatomic) IBOutlet UILabel *labelSecretKey;

@property (nonatomic) IBOutlet UITextField *textfieldUsername;
@property (nonatomic) IBOutlet UITextField *textfieldPassword;
@property (nonatomic) IBOutlet UITextField *textfieldUDID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Atom SDK Demo";
    
    self.connectionList = @[@"Connect with Pre-Shared key", @"Connect with params", @"Connect with Dedicated IP"];
    self.viewControllerList = @[@"ConnectWithPskViewController", @"ConnectWithParamsViewController", @"ConnectWithDedicatedIPViewController"];
    
    self.labelSecretKey.text = [NSString stringWithFormat:@"Secret Key %@",[AppDelegate sharedInstance].secretKey];
    self.tableViewConnectionList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    [AppDelegate sharedInstance].isAutoGeneratedUserCredentials = self.switchUserCredentials.isOn;
}

-(void)moveToNextController:(NSIndexPath*)indexPath {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:self.viewControllerList[indexPath.row]];
    [self.navigationController pushViewController:controller animated:true];
}

#pragma mark - IB Actions -

-(IBAction)switchChangeAction:(id)sender {
    [AppDelegate sharedInstance].isAutoGeneratedUserCredentials = self.switchUserCredentials.isOn;
    
    if(self.switchUserCredentials.isOn) {
        self.textfieldUsername.enabled = false;
        self.textfieldUsername.text = @"";
        self.textfieldPassword.enabled = false;
        self.textfieldPassword.text = @"";
        self.textfieldUDID.enabled = true;
        self.textfieldUDID.text = [AppDelegate sharedInstance].UDID;

        self.labelUsername.textColor = [UIColor lightGrayColor];
        self.labelPassword.textColor = [UIColor lightGrayColor];
        self.labelUDID.textColor = [UIColor blackColor];
    }
    else {
        self.textfieldUsername.enabled = true;
        self.textfieldUsername.text = [AppDelegate sharedInstance].username;
        self.textfieldPassword.enabled = true;
        self.textfieldPassword.text = [AppDelegate sharedInstance].password;
        self.textfieldUDID.enabled = false;
        self.textfieldUDID.text = @"";

        self.labelUsername.textColor = [UIColor blackColor];
        self.labelPassword.textColor = [UIColor blackColor];
        self.labelUDID.textColor = [UIColor lightGrayColor];
    }
}

#pragma mark - UITableView DataSource -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.connectionList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.connectionList[indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self endEditing];
    if (self.switchUserCredentials.isOn) {
        if (self.textfieldUDID.text.length == 0) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"UUID is required for generating vpn credentials to connect VPN." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [alert dismissViewControllerAnimated:true completion:nil];
            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            [AppDelegate sharedInstance].UDID = self.textfieldUDID.text;
            [self moveToNextController:indexPath];
        }
    }
    else {
        if (self.textfieldUsername.text.length == 0) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Username is required for connecting VPN" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [alert dismissViewControllerAnimated:true completion:nil];
            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (self.textfieldPassword.text.length == 0) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password is required for connecting VPN" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [alert dismissViewControllerAnimated:true completion:nil];
            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            [AppDelegate sharedInstance].username = self.textfieldUsername.text;
            [AppDelegate sharedInstance].password = self.textfieldPassword.text;
            [self moveToNextController:indexPath];
        }
    }
}

#pragma mark - UITextField Delegate -

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.textfieldUsername == textField) {
        [AppDelegate sharedInstance].username = self.textfieldUsername.text;
    }
    else if (self.textfieldPassword == textField) {
        [AppDelegate sharedInstance].password = self.textfieldPassword.text;

    }
    else if (self.textfieldUDID == textField) {
        [AppDelegate sharedInstance].UDID = self.textfieldUDID.text;

    }
    return true;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing];
    return YES;
}

-(void)endEditing {
    [self.textfieldUsername resignFirstResponder];
    [self.textfieldPassword resignFirstResponder];
    [self.textfieldUDID resignFirstResponder];
}

#pragma mark - Show Popover -

-(IBAction)showPopOver:(UIButton *)sender {
    PopOverViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    controller.tooltipText = @"If checked, a unique user identifier (UUID) is required to generate username and password.";
    controller.preferredContentSize = CGSizeMake(280,70);
    controller.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popoverController = controller.popoverPresentationController;
    popoverController.sourceRect = sender.frame;
    popoverController.sourceView = self.view;
    popoverController.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end
