//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Timothy Mueller on 3/16/15.
//  Copyright (c) 2015 Timothy Mueller. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property NSMutableArray *toDoListArray;
@property (weak, nonatomic) IBOutlet UITableView *toDoListTableView;
@property UITableViewCell *currentCellLabel;
@property CGPoint pointOfTap;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoListArray = [NSMutableArray arrayWithObjects: @"Laundry", @"Homework", @"Call mom", @"cook dinner", nil];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.toDoListArray.count;
}

- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender {
    NSString *text = self.textField.text;
    [self.toDoListArray addObject:text];
    [self.textField endEditing:YES];
    self.textField.text = @"";
    [self.toDoListTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.toDoListArray objectAtIndex:indexPath.row]];
    return cell;
}

# pragma mark - Gesture Recognition

- (IBAction)onCellTap:(UITapGestureRecognizer)sender{
    if (sender.state == UIGestureRecognizerStateEnded){

    }
}

- (void)findCellUsingPoint:(CGPoint)point {
    for (UITableViewCell *cell in self.toDoListArray) {
        if (CGRectContainsPoint(cell.frame, point)) {
            self.currentCellLabel = cell;
        }
    }
}





@end
