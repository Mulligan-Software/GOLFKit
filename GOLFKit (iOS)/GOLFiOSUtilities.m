//
//  GOLFiOSUtilities.m
//  GOLFKit (iOS)
//
//  Created by John Bishop on 7/2/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "GOLFiOSUtilities.h"

//=================================================================
//	GOLFActivitiesPrintScorecardIcon()
//=================================================================
UIImage * GOLFActivitiesPrintScorecardIcon(void) {
	NSBundle *ourBundle = GOLFKitBundle();
	UIImage *scorecardIcon = (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
			? [UIImage imageNamed:@"SCRActivityPrintScorecardiPad" inBundle:ourBundle compatibleWithTraitCollection:nil]
			: [UIImage imageNamed:@"SCRActivityPrintScorecard" inBundle:ourBundle compatibleWithTraitCollection:nil]);

	return scorecardIcon;
}

