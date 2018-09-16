//
//  GOLFCustomTableViewCells.m
//  GOLFKit (iOS)
//
//  Created by John Bishop on 9/16/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "GOLFCustomTableViewCells.h"

@implementation GOLFSettingsSwitchTableViewCell

+ (id)tableViewCellWithReuseIdentifier:(NSString *)identifier {
	GOLFSettingsSwitchTableViewCell *newCell = [[GOLFSettingsSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
	newCell.accessoryType = UITableViewCellAccessoryNone;
	newCell.selectionStyle = UITableViewCellSelectionStyleNone;

	CGRect contentFrame = newCell.contentView.frame;	//	This will be the unsized default (320.0 wide) UITableViewCell
	
	UILabel *settingsLabel = newCell.textLabel;
	
	settingsLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
	settingsLabel.adjustsFontSizeToFitWidth = YES;
	settingsLabel.backgroundColor = [UIColor clearColor];
	settingsLabel.minimumScaleFactor = 0.5;
	
	newCell.detailTextLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
	newCell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
	newCell.detailTextLabel.backgroundColor = [UIColor clearColor];
	newCell.detailTextLabel.minimumScaleFactor = 0.5;
	
	UISwitch *newSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];	//	Size portion is not used
	CGRect switchFrame = newSwitch.frame;
	//	Put the switch 8 pixels from right edge
	newSwitch.frame = CGRectMake(contentFrame.size.width - switchFrame.size.width - 8.0, floorf((contentFrame.size.height - switchFrame.size.height) / 2), switchFrame.size.width, switchFrame.size.height);
//	[newSwitch addTarget:target action:@selector(action:) forControlEvents:UIControlEventValueChanged];	//	User has to add target to cell.switch
	newSwitch.backgroundColor = [UIColor clearColor];
	//	Make the switch stick to the right side of the contentView…
	newSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[newCell.contentView addSubview:newSwitch];
	newCell.settingsSwitch = newSwitch;
	
	//	Expand the settingsLabel to almost fill the cell…
	CGRect textFrame = settingsLabel.frame;
	settingsLabel.frame = CGRectMake(textFrame.origin.x, 2.0, (contentFrame.size.width - textFrame.origin.x - switchFrame.size.width - 4.0), contentFrame.size.height - 4.0);
	textFrame = newCell.detailTextLabel.frame;
	newCell.detailTextLabel.frame = CGRectMake(textFrame.origin.x, textFrame.origin.y, (contentFrame.size.width - textFrame.origin.x - switchFrame.size.width - 4.0), textFrame.size.height);
	
	return newCell;
}

@end
