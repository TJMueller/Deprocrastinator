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
@property NSIndexPath *deleteRow;
@property NSMutableArray *toDoListColorArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Array of to-do list tasks
    self.toDoListArray = [NSMutableArray arrayWithObjects:
                          @"Laundry", @"Homework", @"Call mom",
                          @"cook dinner", nil];

    //Array of colors for the to-do tasks
    self.toDoListColorArray = [NSMutableArray arrayWithObjects:
                          [UIColor redColor],
                          [UIColor greenColor],
                          [UIColor yellowColor],
                          [UIColor blackColor],  nil];

    //Prevents users from editing more than on cell at a time
    self.toDoListTableView.allowsMultipleSelectionDuringEditing = NO;
}

- (IBAction)onRightSwipeOnTable:(UISwipeGestureRecognizer *)gestureRecognizer {

    //point swiped in tableview
    CGPoint swipePoint = [gestureRecognizer locationInView:self.toDoListTableView];

    //gives index path of where you swiped based on location passed in
    NSIndexPath *swipedIndexPath = [self.toDoListTableView indexPathForRowAtPoint:swipePoint];

    //tells you which cell is specifically swiped based on the index path passed in
    UITableViewCell *swipedCell = [self.toDoListTableView cellForRowAtIndexPath:swipedIndexPath];

    //changing the color of the swiped cell based on its current color
    //adding that new color to the color array at the index corresponding to its row
    if (swipedCell.textLabel.textColor == [UIColor blackColor]) {
        swipedCell.textLabel.textColor = [UIColor greenColor];
        [self.toDoListColorArray setObject:[UIColor greenColor] atIndexedSubscript:swipedIndexPath.row];
    } else if (swipedCell.textLabel.textColor ==[UIColor greenColor]) {
        swipedCell.textLabel.textColor = [UIColor yellowColor];
        [self.toDoListColorArray setObject:[UIColor yellowColor] atIndexedSubscript:swipedIndexPath.row];
    } else if (swipedCell.textLabel.textColor == [UIColor yellowColor]) {
        swipedCell.textLabel.textColor = [UIColor redColor];
        [self.toDoListColorArray setObject:[UIColor redColor] atIndexedSubscript:swipedIndexPath.row];
    } else if (swipedCell.textLabel.textColor == [UIColor redColor]) {
        swipedCell.textLabel.textColor = [UIColor blackColor];
        [self.toDoListColorArray setObject:[UIColor blackColor] atIndexedSubscript:swipedIndexPath.row];
    }
}

//setting the number of rows in the table view equal to the number of items in the to do list array
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.toDoListArray.count;
}

- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender {
    //adding a text field entry to the to do list array as an object
    //adding a corresponding black color object to the color array
    NSString *text = self.textField.text;
    [self.toDoListArray addObject:text];
    [self.toDoListColorArray addObject:[UIColor blackColor]];

    //hides the keyboard
    [self.textField endEditing:YES];

    //resets the text field
    self.textField.text = @"";

    //reloads the table view to display the new data
    [self.toDoListTableView reloadData];
}

-(IBAction)onEditButtonPressed:(UIBarButtonItem *)sender {

    //sets the editing capability on or off depending on button's title
    //animates going both ways switching between the two
    if ([sender.title isEqualToString:@"Edit"]) {
        sender.title = @"Done";
        [self.toDoListTableView setEditing:YES animated:YES];
    } else{
        sender.title = @"Edit";
        [self.toDoListTableView setEditing:NO animated:YES];
    }
}

//required method for construction of table views
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //sets up offscreen table view cells for re-use
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];

    //inserts the content of the to do list array (which originated in the text field) into the table view cells
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.toDoListArray objectAtIndex:indexPath.row]];

    //sets the colors for those contents
    cell.textColor = [self.toDoListColorArray objectAtIndex:indexPath.row];
    return cell;
}

//turns table view cell text green on click
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textColor = [UIColor greenColor];
}

//when in delete mode, call an alert view to give them a chance to reconsider deleting
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

//enacting their choice to delete or cancel and reloading the table view's data
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.toDoListArray removeObjectAtIndex:self.deleteRow.row];
        [self.toDoListColorArray removeObjectAtIndex:self.deleteRow.row];
        [self.toDoListTableView reloadData];
    }
}

//method enabling user to change order of table view cells
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    //taking and reinserting the object in the to do list array based on its cell's placement in the table view
    id buffer = [self.toDoListArray objectAtIndex:sourceIndexPath.row];
    [self.toDoListArray removeObjectAtIndex:sourceIndexPath.row];
    [self.toDoListArray insertObject:buffer atIndex:destinationIndexPath.row];

    //same thing for the color array
    id buffer1 = [self.toDoListColorArray objectAtIndex:sourceIndexPath.row];
    [self.toDoListColorArray removeObjectAtIndex:sourceIndexPath.row];
    [self.toDoListColorArray insertObject:buffer1 atIndex:destinationIndexPath.row];
}

@end
