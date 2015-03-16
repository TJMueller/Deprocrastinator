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
@property BOOL shouldEdit;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoListArray = [NSMutableArray arrayWithObjects: @"Laundry", @"Homework", @"Call mom", @"cook dinner", nil];
    self.toDoListTableView.allowsMultipleSelectionDuringEditing = NO;
}

-(IBAction)swipeToChangeColor:(UISwipeGestureRecognizer *)sender {
    
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

-(IBAction)onEditButtonPressed:(UIBarButtonItem *)sender {
    
    if ([sender.title isEqualToString:@"Edit"]) {
        sender.title = @"Done";
        [self.toDoListTableView setEditing:YES animated:YES];
    } else{
        sender.title = @"Edit";
        [self.toDoListTableView setEditing:NO animated:YES];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.toDoListArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textColor = [UIColor greenColor];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.toDoListArray removeObjectAtIndex:indexPath.row];
    }

    [self.toDoListTableView reloadData];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
