//
//  GOLFColors.m
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import "GOLFColors.h"

#if TARGET_OS_IOS || TARGET_OS_WATCH

#define GOLFColor UIColor

#elif TARGET_OS_MAC

#define GOLFColor NSColor

#endif


//	#undef GOLFColor


@implementation GOLFColor (GOLFColorCategories)

+ (id)GOLFFactoryEagleScoreColor {
	return [GOLFColor purpleColor];
}

+ (id)GOLFFactoryBirdieScoreColor {
	return [GOLFColor redColor];
}

+ (id)GOLFFactoryParScoreColor {
	return [GOLFColor blueColor];
}

+ (id)GOLFFactoryBogeyScoreColor {
	return [GOLFColor blackColor];
}

+ (id)GOLFFactoryUnderParScoreColor {
	return [GOLFColor GOLFFactoryBirdieScoreColor];
}

+ (id)GOLFFactoryOverParScoreColor {
	return [GOLFColor GOLFFactoryBogeyScoreColor];
}

@end
