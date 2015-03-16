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
@property UITableViewCell *selectedCell;
@property CGRect cellBounds;
@property CGPoint pointOfSwipe;
@property NSIndexPath *deleteRow;

//TJTrial
@property NSMutableArray *toDoListColor;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoListArray = [NSMutableArray arrayWithObjects: @"Laundry", @"Homework", @"Call mom", @"cook dinner", nil];
    self.toDoListTableView.allowsMultipleSelectionDuringEditing = NO;
    //TJTrial
    self.toDoListColor = [NSMutableArray arrayWithObjects:[UIColor redColor],[UIColor greenColor], [UIColor yellowColor],[UIColor blackColor],  nil];
}

- (IBAction)onRightSwipeOnTable:(UISwipeGestureRecognizer *)gestureRecognizer {

    CGPoint swipeLocation = [gestureRecognizer locationInView:self.toDoListTableView];
    //point swiped in tableview
    NSIndexPath *swipedIndexPath = [self.toDoListTableView indexPathForRowAtPoint:swipeLocation];
    //gives index path of where you swiped based on location passed in
    UITableViewCell *swipedCell = [self.toDoListTableView cellForRowAtIndexPath:swipedIndexPath];
    //tells you which cell is specifically swiped based on the index path passed in
    if (swipedCell.textLabel.textColor == [UIColor blackColor]) {
        swipedCell.textLabel.textColor = [UIColor greenColor];
        [self.toDoListColor setObject:[UIColor greenColor] atIndexedSubscript:swipedIndexPath.row];
    }
    else if (swipedCell.textLabel.textColor ==[UIColor greenColor])
    {
        swipedCell.textLabel.textColor = [UIColor yellowColor];
        [self.toDoListColor setObject:[UIColor yellowColor] atIndexedSubscript:swipedIndexPath.row];
    }
    else if (swipedCell.textLabel.textColor == [UIColor yellowColor])
    {
        swipedCell.textLabel.textColor = [UIColor redColor];
        [self.toDoListColor setObject:[UIColor redColor] atIndexedSubscript:swipedIndexPath.row];
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.toDoListArray.count;
}

- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender {
    NSString *text = self.textField.text;
    [self.toDoListArray addObject:text];
    [self.toDoListColor addObject:[UIColor blackColor]];
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
    //TJTrial
    cell.textColor = [self.toDoListColor objectAtIndex:indexPath.row];
    //Superfluous
    self.cellBounds = cell.bounds;
    self.selectedCell = cell;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textColor = [UIColor greenColor];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.deleteRow = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are You Sure?"
                                                        message:@"It's Final"
                                                       delegate:self
                                              cancelButtonTitle:@"Don't Delete"
                                              otherButtonTitles: @"Delete", nil];
        [alert show];

    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.toDoListArray removeObjectAtIndex:self.deleteRow.row];
        [self.toDoListColor removeObjectAtIndex:self.deleteRow.row];
        [self.toDoListTableView reloadData];


    }
}



-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id buffer = [self.toDoListArray objectAtIndex:sourceIndexPath.row];
    [self.toDoListArray removeObjectAtIndex:sourceIndexPath.row];
    [self.toDoListArray insertObject:buffer atIndex:destinationIndexPath.row];

    id buffer1 = [self.toDoListColor objectAtIndex:sourceIndexPath.row];
    [self.toDoListColor removeObjectAtIndex:sourceIndexPath.row];
    [self.toDoListColor insertObject:buffer1 atIndex:destinationIndexPath.row];
}





@end
