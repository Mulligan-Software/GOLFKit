//
//  GOLFColors.m
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import "GOLFColors.h"

#if TARGET_OS_IOS || TARGET_OS_WATCH

#define GOLFAppColor UIColor

#elif TARGET_OS_MAC

#define GOLFAppColor NSColor

#endif


//	#undef GOLFAppColor


@implementation GOLFAppColor (GOLFColorCategories)

+ (id)GOLFFactoryEagleScoreColor {
	return [GOLFAppColor purpleColor];
}

+ (id)GOLFFactoryBirdieScoreColor {
	return [GOLFAppColor redColor];
}

+ (id)GOLFFactoryParScoreColor {
	return [GOLFAppColor blueColor];
}

+ (id)GOLFFactoryBogeyScoreColor {
	return [GOLFAppColor blackColor];
}

+ (id)GOLFFactoryUnderParScoreColor {
	return [GOLFAppColor GOLFFactoryBirdieScoreColor];
}

+ (id)GOLFFactoryOverParScoreColor {
	return [GOLFAppColor GOLFFactoryBogeyScoreColor];
}

@end
