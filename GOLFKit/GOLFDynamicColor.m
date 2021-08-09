//
//  GOLFDynamicColor.m
//  GOLFKit
//
//  Created by John Bishop on 10/22/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "GOLFDynamicColor.h"

#define FORWARD(PROP, TYPE) \
- (TYPE)PROP { return [self.effectiveColor PROP]; }

@interface GOLFDynamicColor ()

@property (nonatomic, strong) GOLFColor *aquaColor;
@property (nonatomic, strong, nullable) GOLFColor *darkAquaColor;

@property (nonatomic, strong, readonly) GOLFColor *effectiveColor;

@end


@implementation GOLFDynamicColor

+ (GOLFColor *)dynamicColorWithAquaColor:(GOLFColor *)aquaColor darkAquaColor:(GOLFColor *)darkAquaColor {
	GOLFColor *newDynamicColor = [[GOLFDynamicColor alloc] initWithAquaColor:aquaColor darkAquaColor:darkAquaColor];
	return newDynamicColor;
}

+ (BOOL)supportsSecureCoding {
	return YES;
}

- (instancetype)initWithAquaColor:(GOLFColor *)aquaColor darkAquaColor:(GOLFColor *)darkAquaColor {
	self = [super init];
	if (self) {
		self.aquaColor = aquaColor;
		self.darkAquaColor = darkAquaColor;
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self) {
		self.aquaColor = [coder decodeObjectOfClass:[GOLFColor class] forKey:@"aquaColor"];
		self.darkAquaColor = [coder decodeObjectOfClass:[GOLFColor class] forKey:@"darkAquaColor"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[super encodeWithCoder:aCoder];
	[aCoder encodeObject:self.aquaColor forKey:@"aquaColor"];
	if (self.darkAquaColor) {
		[aCoder encodeObject:self.darkAquaColor forKey:@"darkAquaColor"];
	}
}

- (GOLFColor *)effectiveColor {
	if (@available(macOS 10.14, *)) {
		NSAppearance *appearance = [NSAppearance currentAppearance] ?: [NSApp effectiveAppearance];
		NSAppearanceName appearanceName = [appearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameAqua, NSAppearanceNameDarkAqua]];
		
		if ((self.darkAquaColor != nil) && [appearanceName isEqualToString:NSAppearanceNameDarkAqua]) {
			return self.darkAquaColor;
		}
	}
	return self.aquaColor;
}

FORWARD(colorSpace, NSColorSpace *)
- (GOLFColor *)colorUsingColorSpace:(NSColorSpace *)space {
	return [self.effectiveColor colorUsingColorSpace:space];
}

//FORWARD(colorSpaceName, NSColorSpaceName)
//- (GOLFColor *)colorUsingColorSpaceName:(NSColorSpaceName)name {
//	return [self.effectiveColor colorUsingColorSpaceName:name];
//}

FORWARD(numberOfComponents, NSInteger)
- (void)getComponents:(CGFloat *)components {
	return [self.effectiveColor getComponents:components];
}

#pragma mark RGB colorspace

FORWARD(redComponent, CGFloat)
FORWARD(greenComponent, CGFloat)
FORWARD(blueComponent, CGFloat)

- (void)getRed:(nullable CGFloat *)red green:(nullable CGFloat *)green blue:(nullable CGFloat *)blue alpha:(nullable CGFloat *)alpha {
	return [self.effectiveColor getRed:red green:green blue:blue alpha:alpha];
}

#pragma mark HSB colorspace

FORWARD(hueComponent, CGFloat)
FORWARD(saturationComponent, CGFloat)
FORWARD(brightnessComponent, CGFloat)

- (void)getHue:(nullable CGFloat *)hue saturation:(nullable CGFloat *)saturation brightness:(nullable CGFloat *)brightness alpha:(nullable CGFloat *)alpha {
	return [self.effectiveColor getHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

#pragma mark Gray colorspace

FORWARD(whiteComponent, CGFloat)

- (void)getWhite:(nullable CGFloat *)white alpha:(nullable CGFloat *)alpha {
	return [self.effectiveColor getWhite:white alpha:alpha];
}

#pragma mark CMYK colorspace

FORWARD(cyanComponent, CGFloat)
FORWARD(magentaComponent, CGFloat)
FORWARD(yellowComponent, CGFloat)
FORWARD(blackComponent, CGFloat)

- (void)getCyan:(nullable CGFloat *)cyan magenta:(nullable CGFloat *)magenta yellow:(nullable CGFloat *)yellow black:(nullable CGFloat *)black alpha:(nullable CGFloat *)alpha {
	return [self.effectiveColor getCyan:cyan magenta:magenta yellow:yellow black:black alpha:alpha];
}

#pragma mark Others

FORWARD(alphaComponent, CGFloat)
FORWARD(CGColor, CGColorRef)
FORWARD(catalogNameComponent, NSColorListName)
FORWARD(colorNameComponent, NSColorName)
FORWARD(localizedCatalogNameComponent, NSColorListName)
FORWARD(localizedColorNameComponent, NSString *)

- (void)setStroke {
	[self.effectiveColor setStroke];
}

- (void)setFill {
	[self.effectiveColor setFill];
}

- (void)set {
	[self.effectiveColor set];
}

- (nullable GOLFColor *)highlightWithLevel:(CGFloat)val {
	return [self.effectiveColor highlightWithLevel:val];
}

- (GOLFColor *)shadowWithLevel:(CGFloat)val {
	return [self.effectiveColor shadowWithLevel:val];
}

- (GOLFColor *)colorWithAlphaComponent:(CGFloat)alpha {
	return [self.effectiveColor colorWithAlphaComponent:alpha];
}

- (nullable GOLFColor *)blendedColorWithFraction:(CGFloat)fraction ofColor:(NSColor *)color {
	return [self.effectiveColor blendedColorWithFraction:fraction ofColor:color];
}

- (GOLFColor *)colorWithSystemEffect:(NSColorSystemEffect)systemEffect NS_AVAILABLE_MAC(10_14) {
	return [self.effectiveColor colorWithSystemEffect:systemEffect];
}

@end
