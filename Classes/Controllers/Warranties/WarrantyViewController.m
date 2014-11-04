//
//  WarrantyViewController.m
//  CardReader
//
//  Created by Arturo Jaime Guerrero on 15/10/14.
//  Copyright (c) 2014 Gonet. All rights reserved.
//

#import "WarrantyViewController.h"
#import "Warranty.h"
#import "Styles.h"

@interface WarrantyViewController ()
@property (retain, nonatomic) IBOutlet UIButton *denyButton;
@property (retain, nonatomic) Warranty *selectedWarranty;
@property (retain, nonatomic) IBOutlet UILabel *productLabel;

@end

@implementation WarrantyViewController
@synthesize warrantiesTableView = _warrantiesTableView;
@synthesize warrantiesList = _warrantiesList;
@synthesize registerButton = _registerButton;
@synthesize denyButton = _denyButton;
@synthesize selectedWarranty = _selectedWarranty;
@synthesize productLabel = _productLabel;
@synthesize productName = _productName;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registerButton.userInteractionEnabled = NO;
    self.productLabel.text = self.productName;
    self.warrantiesTableView.backgroundColor=[UIColor clearColor];
    [Styles bgGradientColorPurple:self.view];
    [Styles silverButtonStyle:self.denyButton];
    [Styles silverButtonStyle:self.registerButton];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.warrantiesList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...    
    if (cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.textLabel.backgroundColor=[UIColor clearColor];
    }
    
    Warranty *warranty = (Warranty *)[self.warrantiesList objectAtIndex:indexPath.row];
    cell.textLabel.text = warranty.detail;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger catIndex = [self.warrantiesList indexOfObject:self.selectedWarranty];
    if (catIndex == indexPath.row) {
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:catIndex inSection:0];
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedWarranty = [self.warrantiesList objectAtIndex:indexPath.row]; //Holds the selected warranty
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    self.registerButton.userInteractionEnabled = YES;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellImage;
    NSString *cellImageSelected;
    // first cell check
    if ([indexPath length]==1) {
        cellImage=@"oneCell.png";
        cellImageSelected=@"oneCell.ong";
    }
    else if (indexPath.row == 0) {
        cellImage=@"topTable.png";
        cellImageSelected=@"topTable.png";
        
    }
    // last cell check
    else if (indexPath.row ==[self.warrantiesTableView numberOfRowsInSection:indexPath.section] - 1) {
        cellImage=@"bottomTable.png";
        cellImageSelected=@"bottomTable.png";
        // middle cells
    } else {
        cellImage=@"middleTable1.png";
        cellImageSelected=@"bottomTable.png";
    }
    
    UIImageView *backgroundNormal;
    UIImageView *backgroundSelected;
    
    backgroundNormal = [[UIImageView alloc] initWithImage:
                        [UIImage imageNamed:cellImage]];
    
    backgroundSelected = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:cellImageSelected]];
    
    [cell setBackgroundView:backgroundNormal];
    [cell setSelectedBackgroundView:backgroundSelected];
    
    [backgroundNormal release];
    [backgroundSelected release];
}

- (IBAction)registerWarranty:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WARRANTYSELECTED_NOTIFICATION object:self.selectedWarranty];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)denyWarranty:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)dealloc {
    [_warrantiesTableView release];
    [_registerButton release];
    [_denyButton release];
    [_registerButton release];
    [_productLabel release];
    [super dealloc];
}
@end
