//
//  TerminalsView.m
//  CardReader
//


#import "TerminalsView.h"
#import "CardReaderAppDelegate.h"
#import "Styles.h"

@implementation TerminalsView
@synthesize selectBtn,gridView,arrayTerminals;;



#define ROW_SEPARATOR		10
#define COLUMN_SEPARATOR	10
#define BUTTON_HEIGTH		40
#define BUTTON_WIDTH		50


-(void)viewDidLoad
{
	NSString *aStr = @"Terminales";
	[self setTitle:aStr];
	
	gridView.contentSize = CGSizeMake(300, ((100/4)*BUTTON_HEIGTH)+COLUMN_SEPARATOR);

	[self styleApply];	
	
	arrayTerminals=[NSArray arrayWithObjects: @"501",@"503",@"506",@"510",@"520",@"590",@"550",@"572",nil];
	[self getAvailableTerminals:500 forMaxRange:600 forBusyTerminals:arrayTerminals];
	[super viewDidLoad];
}

//----------------------------------------
//            STYLES 
//----------------------------------------
-(void)styleApply{
	[Styles bgGradientColorPurple:self.view];
	[Styles estiloGeneralDelBoton:selectBtn];
}

//----------------------------------------
//            ACTIONS
//----------------------------------------
-(IBAction) selectTerminal
{
	[(CardReaderAppDelegate*)([UIApplication sharedApplication].delegate) mainScreen];

}
-(IBAction) getTerminalNumber:(id)sender
{
	UIButton *button=(UIButton*) sender;
	DLog(@"terminal Seleccionada: %i",button.tag);
	[self selectTerminal];

	[Styles bgGradientButtonSelected:button];
}
//----------------------------------------
//            DATA SOURCE
//----------------------------------------
-(void) getAvailableTerminals:(int) minRange forMaxRange:(int)maxRange forBusyTerminals:(NSArray*) terminalArrays
{
//	int rowNumber=0;
//	int colNumber=0;
//	for (minRange; minRange<maxRange; minRange++) {
//		
//		[self createButtonForRow:rowNumber forColumn:colNumber forTNumber:minRange];
//		
//		rowNumber++;
//		if (rowNumber%5==0) 
//		{	colNumber++;
//			rowNumber=0;
//		}
//
//	}
	
}
// creates the button and add it to the scrollview, if the terminal is occupied , the button is
// draw with a red Background
-(void) createButtonForRow:(int) row forColumn:(int)col forTNumber:(int) terminalNumber
{

	UIButton *aButton=[UIButton buttonWithType:UIButtonTypeCustom];
	aButton.frame=CGRectMake(row*(BUTTON_WIDTH+ROW_SEPARATOR) ,col*(BUTTON_HEIGTH+COLUMN_SEPARATOR), BUTTON_WIDTH, BUTTON_HEIGTH);
	//DLog(@"rowx:%i coly:%i",(row*BUTTON_WIDTH)+ROW_SEPARATOR,(col*BUTTON_HEIGTH)+COLUMN_SEPARATOR);
	aButton.tag=terminalNumber;
	NSString* aTitle=[NSString stringWithFormat:@"%i",terminalNumber];
	[aButton setTitle:aTitle forState:UIControlStateNormal];
	// DLog(@"aButton=%@ tag=%d", aButton, aButton.tag);
	[aButton addTarget:self action:@selector(getTerminalNumber:) forControlEvents:UIControlEventTouchUpInside];
	
	if([self isTerminalOccupied:terminalNumber])
		[Styles	bgGradientButtonBusy:aButton];
	else
		[Styles	bgGradientButtonEmpty:aButton];

	[gridView addSubview:aButton];
}
// check if the terminal is being used
-(BOOL) isTerminalOccupied:(int) terminalNumber
{
	NSString* terminalNum=[NSString stringWithFormat:@"%i",terminalNumber];
	
	for(NSString* number in arrayTerminals)
	{
		if ([number isEqualToString:terminalNum]) {
			return YES;
		}
	}
	return NO;
}

/*
//----------------------------------------
//            TABLE VIEW MANAGEMENT
//----------------------------------------
#pragma mark -
#pragma mark TABLE VIEW MANAGEMENT

-(UITableViewCell *)tableView:(UITableView *)tableView 
		cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	if (cell == nil) 
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									  reuseIdentifier:@"Cell"];
	}else{//MPSA
        for (UIView* subview in [cell.contentView subviews]) {
			// if (subview.tag!=0) {
			[subview removeFromSuperview];
            //}
        }
    }
	cell.textLabel.textColor=[UIColor whiteColor];
	[cell.textLabel setText:[[tableData objectAtIndex:indexPath.row] objectForKey:@"Text"]];
	[cell.detailTextLabel setText:[[tableData objectAtIndex:indexPath.row] objectForKey:@"DetailText"]];
	[cell.imageView setImage:[[tableData objectAtIndex:indexPath.row] objectForKey:@"Image"]];
	UILabel *aLabel = [[UILabel alloc] initWithFrame:
					   CGRectMake(cell.frame.size.width - 50, 
								  cell.frame.size.height - 30, 
								  50, 30)];
	[aLabel setText:[[tableData objectAtIndex:indexPath.row] objectForKey:@"Price"]];
	[aLabel setBackgroundColor:[UIColor clearColor]];
	[[cell contentView] addSubview:aLabel];
	[aLabel release];
	[[cell contentView] addSubview:cellView];
	//[cellView release];
	return cell;
}

-(NSInteger)tableView:(UITableView *)tableView 
numberOfRowsInSection:(NSInteger)section
{
	//return [tableData count];
	return 3;
}

-(void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)tableView:(UITableView *)tableView 
willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(BOOL)tableView:(UITableView *)tableView 
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}


-(NSString *)tableView:(UITableView *)tableView 
titleForFooterInSection:(NSInteger)section
{
	return @"";
}*/

-(void) dealloc
{
	[super dealloc];
	
	[selectBtn release]; selectBtn =nil;
	[gridView release]; gridView=nil;
	
}
@end
