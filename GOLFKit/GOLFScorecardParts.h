//
//  GOLFScorecardParts.h
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GOLFKit/GOLFKitTypes.h>
#import <GOLFKit/GOLFColors.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, ScorecardPartType) {
        ScorecardPartTypeBaseView	= 0,	//	(0) Overall transparent non-drawing coordinating view
        ScorecardPartTypeRoundView,			//	(1)	Side views and total
        ScorecardPartTypeSideView,			//	(2)	hole views and total
        ScorecardPartTypeHoleView,			//	(3)	text label or entry field
};

typedef NS_OPTIONS(NSUInteger, ScorecardPartBorder) {
	ScorecardPartBorderNone				= 0,			//	(0)
	ScorecardPartBorderTop				= 1 << 0,		//	(1)		Visible border (or drawing space)
	ScorecardPartBorderLeft				= 1 << 1,		//	(2)		around the dynamically-sized part
	ScorecardPartBorderBottom			= 1 << 2,		//	(4)
	ScorecardPartBorderRight			= 1 << 3,		//	(8)
};


@interface ScorecardPartView : NSView		//	An NSView for macOS
{
}

@property(nonatomic, retain) NSColor *ourColor;
@property(nonatomic, assign) ScorecardPartType partType;
@property(nonatomic, assign) NSEdgeInsets borders;	//	top, left, bottom, right

//	Dynamic resizeable part sizes (excluding border(s)
@property(nonatomic, assign) CGFloat partHeight;
@property(nonatomic, assign) CGFloat partHoleScoreWidth;
@property(nonatomic, assign) CGFloat partSideTotalWidth;
@property(nonatomic, assign) CGFloat partRoundTotalWidth;
@property(nonatomic, assign) CGFloat partStrokesTotalWidth;
@property(nonatomic, assign) CGFloat partNetTotalWidth;

//- (NSRect)margins;	//	left = .origin.x, right = .origin.y, bottom = .size.width, top = .size.height
//- (void)setMargins:(NSRect)margins;
//- (BOOL)insertPagebreaks;
//- (void)setInsertPagebreaks:(BOOL)insert;
//- (void)insertView:(NSView *)viewToBeInserted atIndex:(NSInteger)index;
//- (void)removeViewAtIndex:(NSInteger)index;
//- (void)removeLastView;
//- (void)updateKeyViews;

#pragma mark NSView overrides
//- (NSSize)intrinsicContentSize;
//- (NSRect)rectForPage:(NSInteger)page;
//- (BOOL)knowsPageRange:(NSRange *)pageRange;
//- (NSAttributedString *)pageHeader;
//- (NSAttributedString *)pageFooter;
//- (NSMutableDictionary *)footerAttributes;
//- (NSArray *)footerTabStops;

@end

NS_ASSUME_NONNULL_END

