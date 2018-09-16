//
//  GOLFCustomTableViewCells.h
//  GOLFKit (iOS)
//
//  Created by John Bishop on 9/16/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define GOLFSettingsSwitchTableViewCellReuseIdentifier @"SettingsSwitchTableViewCell"

@interface GOLFSettingsSwitchTableViewCell : UITableViewCell
{
}

+ (id)tableViewCellWithReuseIdentifier:(NSString *)identifier;

//	@property (nonatomic, readonly, retain) IBOutlet UILabel *textLabel;		//	from UITableViewCell
//	@property (nonatomic, readonly, retain) IBOutlet UILabel *detailTextLabel;	//	from UITableViewCell
//	@property (nonatomic, readonly, retain) IBOutlet UIImageView *imageView;	//	from UITableViewCell

@property (nonatomic, retain) IBOutlet UISwitch *settingsSwitch;

@end

NS_ASSUME_NONNULL_END
