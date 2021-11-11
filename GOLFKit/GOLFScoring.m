//
//  GOLFScoring.m
//  GOLFKit
//
//  Created by John Bishop on 4/2/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "GOLFKit.h"
#import "GOLFUtilities.h"
#import "GOLFScoring.h"

//=================================================================
//	GOLFHoleSelectionInstructionsForAllowanceType(allowanceType)
//=================================================================
NSString * GOLFHoleSelectionInstructionsForAllowanceType(GOLFAllowanceType allowanceType) {
	switch (allowanceType) {
		case PeoriaAllowanceType:
			return [NSString stringWithFormat:GOLFLocalizedString(@"ALLOWANCE_TYPE_PEORIA_INSTRUCTION_%@_CLICKORTAP"), [NSStringForClickOrTap() capitalizedString]];

		case ModifiedPeoriaAllowanceType:
			return [NSString stringWithFormat:GOLFLocalizedString(@"ALLOWANCE_TYPE_MODIFIED_PEORIA_INSTRUCTION_%@_CLICKORTAP"), [NSStringForClickOrTap() capitalizedString]];

		case ScrambleZigZagAllowanceType:
			return [NSString stringWithFormat:GOLFLocalizedString(@"ALLOWANCE_TYPE_ZIG_ZAG_SYSTEM_INSTRUCTION_%@_CLICKORTAP"), [NSStringForClickOrTap() capitalizedString]];

		default:
			return [NSString stringWithFormat:GOLFLocalizedString(@"PLAY_TYPE_SELECTED_HOLES_INSTRUCTION_%@_CLICKORTAP"), [NSStringForClickOrTap() capitalizedString]];
	}
}

//=================================================================
//	GOLFMaxPointQuotaForPlayType(playType, for9Holes)
//=================================================================
GOLFHandicapStrokes GOLFMaxPointQuotaForPlayType(GOLFPlayType playType, BOOL for9Holes) {
	switch (playType) {
		case HalfStablefordPlayType:
			return (for9Holes ? 9 : 18);
			
		case ChicagoPlayType:
			return (for9Holes ? 19 : 39);
			
		case StablefordPlayType:
		case ModifiedStablefordPlayType:
		default:
			return (for9Holes ? 18 : 36);
	}
}

#pragma mark NSStringFrom… Utilities

//=================================================================
//	NSStringOrdinalSuffixFromRank(rank)
//=================================================================
NSString * NSStringOrdinalSuffixFromRank(NSUInteger rank) {
	//	Returns a localized suffix for a positive integer rank
	//	In English, "st", "nd", "rd", "th", "th", etc.
	
	if (rank == 1)
		return GOLFLocalizedString(@"ORDINAL_FIRST");
	else if (((rank % 100) > 9) && ((rank % 100) < 15))
		return GOLFLocalizedString(@"ORDINAL_NTH");
	else	
		return [[GOLFLocalizedString(@"ORDINAL_20TH_TO_29TH") componentsSeparatedByString:@","] objectAtIndex:(rank % 10)];
}

//=================================================================
//	NSStringFromMixedScore(score, denominatorHint)
//=================================================================
NSString * NSStringFromMixedScore(float score, NSInteger denominatorHint, float *error) {
	//	Returns a whole or mixed number string from a score - including the whole number followed by its vulgar fraction (if any)
	//	A score of kNotANetScore returns an empty string (@"")
	//	The denominator hint may help decide how precisely to test for fractional parts
	//	If it's not reasonable to be able to return a mixed number, the localized decimal value to a tenth is returned
	if (score != kNotANetScore) {
		BOOL negative = (score < 0.0);
		float workingScore = (negative ? -score : score);
		NSInteger wholeNumber = (NSInteger)floorf(workingScore);
		float remainder = workingScore - (float)wholeNumber;
		BOOL needRemainder = (floorf((fabs(remainder) * 10) + 0.5) > 0.0);
		NSInteger bestNumerator = 0;
		NSInteger bestDenominator = 10;
		float bestError = 999.0;
		BOOL halves = YES;
		BOOL thirds = ((denominatorHint == 2) || (denominatorHint == 4)) ? NO : YES;
		BOOL quarters = ((denominatorHint == 3) || (denominatorHint == 5)) ? NO : YES;
		BOOL fifths = (denominatorHint < 5) ? NO : YES;
		BOOL eighths = (denominatorHint < 8) ? NO : YES;
		BOOL tenths = NO;

		if (halves) {
			for (NSInteger numerator = 1; numerator < 2; numerator++) {
				float error = fabs(fabs((float)numerator / 2.0) - remainder);
				if (error < bestError) {
					bestNumerator = numerator;
					bestDenominator = 2;
					bestError = error;
				}
			}
		}
		if (thirds) {
			for (NSInteger numerator = 1; numerator < 3; numerator++) {
				float error = fabs(fabs((float)numerator / 3.0) - remainder);
				if (error < bestError) {
					bestNumerator = numerator;
					bestDenominator = 3;
					bestError = error;
				}
			}
		}
		if (quarters) {
			for (NSInteger numerator = 1; numerator < 4; numerator++) {
				float error = fabs(fabs((float)numerator / 4.0) - remainder);
				if (error < bestError) {
					bestNumerator = numerator;
					bestDenominator = 4;
					bestError = error;
				}
			}
		}
		if (fifths) {
			for (NSInteger numerator = 1; numerator < 5; numerator++) {
				float error = fabs(fabs((float)numerator / 5.0) - remainder);
				if (error < bestError) {
					bestNumerator = numerator;
					bestDenominator = 5;
					bestError = error;
				}
			}
		}
		if (eighths) {
			for (NSInteger numerator = 1; numerator < 8; numerator++) {
				float error = fabs(fabs((float)numerator / 8.0) - remainder);
				if (error < bestError) {
					bestNumerator = numerator;
					bestDenominator = 8;
					bestError = error;
				}
			}
		}
		for (NSInteger numerator = 0; numerator < (tenths ? 10 : 2); numerator++) {
			float error = fabs(fabs((float)numerator / 10.0) - remainder);
			if (error < bestError) {
				bestNumerator = numerator;
				bestDenominator = 10;
				bestError = error;
			}
		}
		if ((bestNumerator > 0) && (bestError <= 0.05)) {
			NSString *vulgarName = [NSString stringWithFormat:@"VF_%ld/%ld", (long)bestNumerator, (long)bestDenominator];
			NSString *vulgarFraction = GOLFLocalizedString(vulgarName);
			if (error) {
				*error = bestError;
			}
			if ([vulgarFraction isEqualToString:vulgarName]) {
				//	An error finding an appropriate vulgar fraction using GOLFLocalizedString…
				return (needRemainder ? [NSString localizedStringWithFormat:@"%1.1f", score] : [NSString localizedStringWithFormat:@"%1.0f", score]);
			}
			return ((wholeNumber > 0)
					? [NSString stringWithFormat:@"%@%ld%@", (negative ? @"-" : @""), (long)wholeNumber, vulgarFraction]
					: [NSString stringWithFormat:@"%@%@", (negative ? @"-" : @""), vulgarFraction]);
		} else {
			if (error) {
				*error = bestError;
			}
			return (needRemainder ? [NSString localizedStringWithFormat:@"%1.1f", score] : [NSString localizedStringWithFormat:@"%1.0f", score]);	//	Formatting will handle the sign
		}
	}	//	if (score != kNotANetScore)
	return @"";
}

//=================================================================
//	NSStringFromAllowanceType(allowanceType, info, descriptiveText)
//=================================================================
NSString * NSStringFromAllowanceType(GOLFAllowanceType allowanceType, NSDictionary *info, NSString **descriptiveText) {
	//	info (optional):
	//	key					type						description
	//	-----------------	-------------------------	-------------------------------------------------------------------------------------
	//	handicapAuthority	GOLFHandicapAuthority *		The handicap authority associated with this presentation (default provided if missing)
	//	short				NSNumber *					BOOL indicating need for short (abbreviated?) return (if available)
	//	allowancePct		NSNumber *					The allowance percentage (of 100) for the SpecifiedPercentAllowanceType (default provided if missing)
	//	lowHandicap			NSNumber *					GOLFPlayingHandicap for the base (low) handicap player used for DifferenceAllowanceType

	//		Allowance Types
	//
	//		Type							  Numeric		Allowance
	//		----------------------------	-------------	-----------------------------------------------------
	//		StandardAllowanceType				0			Regular allowance (for players)
	//		GrossAllowanceType					1			Gross - no handicap
	//		NetAllowanceType					2			Net team allowance
	//
	//		FullHandicapAllowanceType			10			Full handicap (Net stroke play)
	//		Men90Women95AllowanceType			11			Men 90%, Women 95% (Best-Ball of 2, 2 Best Balls of 4)
	//		Men80Women90AllowanceType			12			Men 80%, Women 90% (Best-Ball of 4)
	//		A60B40AllowanceType					13			A player 60%, B player 40% (Chapman/Pinehurst)
	//		A50B20AllowanceType					14			A player 50%, B player 20%
	//		SpecifiedPercentAllowanceType		15			A specified percentage of Playing Handicap
	//
	//		AverageCombinedAllowanceType		20			Average of teammates' Playing Handicaps (Foursomes)
	//		AverageCombined80AllowanceType		21			80% of average teammates' handicap (Greensomes)
	//		Aggregate3EighthsAllowanceType		22			3/8 (37.5%) of partners’ total handicaps (American Foursomes)
	//
	//		DifferenceAllowanceType				30			Handicap difference vs. opponent (player or team)
	//		QuotaAllowanceType					31			Point Quota (36 / 38 / 18 less Full Handicap)
	//
	//		ScrambleA50AllowanceType			40			50% of A player (2+ player scramble)
	//		ScrambleA35B15AllowanceType			41			35% A, 15% B (2+ player scramble
	//		ScrambleA25B15C10AllowanceType		42			25% A, 15% B, 10% C (3+ player scramble
	//		ScrambleA20B15C10D5AllowanceType	43			20% A, 15% B, 10% C, 5% D (4+ player scramble)
	//
	//		ScrambleScheidAllowanceType			48			Modifid Scheid Scramble (team 1-time)
	//		ScrambleZigZagAllowanceType			49			ZIG-ZAG (team 1-time)
	//
	//		CallawayAllowanceType				50			"Official" Callaway System (player 1-time)
	//		ScheidAllowanceType					51			Scheid System (player 1-time)
	//		PeoriaAllowanceType					52			Peoria Handicap (player 1-time)
	//		ModifiedPeoriaAllowanceType			53			Modified Peoria Handicap (player 1-time)
	//		System36AllowanceType				54			System 36 Handicap (player 1-time)
	//
	//		UnknownAllowanceType				99			Unknown or error
	
	GOLFHandicapAuthority *authority = (info ? [info objectForKey:@"handicapAuthority"] : nil);
	BOOL needShortText = (info ? [[info objectForKey:@"short"] boolValue] : NO);	//	Return "short" variation if available

	if (!GOLFHandicapValidAuthority(authority)) authority = GOLFDefaultHandicapAuthority();
	
	GOLFHandicapMethodIndex methodIndex = GOLFHandicapBestMethodIndexFromAuthority(authority);
	
	switch(allowanceType) {
		case StandardAllowanceType:
			if (descriptiveText) {
				*descriptiveText = @"";
			}
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_STANDARD");

		case GrossAllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_TYPE_GROSS_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_NONE") : [GOLFLocalizedString(@"ALLOWANCE_TYPE_GROSS") capitalizedString]);

		case NetAllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_TYPE_NET_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_NET") : [GOLFLocalizedString(@"ALLOWANCE_TYPE_NET") capitalizedString]);

		case QuotaAllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_TYPE_POINT_QUOTA_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_QUOTA") : GOLFLocalizedString(@"ALLOWANCE_TYPE_POINT_QUOTA"));

		case FullHandicapAllowanceType:
			if (descriptiveText) {
				*descriptiveText = [NSString stringWithFormat:GOLFLocalizedString(@"%d_PCT_OF_HANDICAP_%@"), 100, GOLFPlayingHandicapTitle(methodIndex, NO)];
			}
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_FULL_HANDICAP");

		case Men90Women95AllowanceType:
			if (descriptiveText) {
				*descriptiveText = [NSString stringWithFormat:@"%@ %@", [GOLFLocalizedString(@"OF") lowercaseString], GOLFPlayingHandicapTitle(methodIndex, NO)];
			}
			return (needShortText ? GOLFLocalizedString(@"ALLOWANCE_TYPE_MEN_90_WOMEN_95_ABBR") : GOLFLocalizedString(@"ALLOWANCE_TYPE_MEN_90_WOMEN_95"));

		case Men80Women90AllowanceType:
			if (descriptiveText) {
				*descriptiveText = [NSString stringWithFormat:@"%@ %@", [GOLFLocalizedString(@"OF") lowercaseString], GOLFPlayingHandicapTitle(methodIndex, NO)];
			}
			return (needShortText ? GOLFLocalizedString(@"ALLOWANCE_TYPE_MEN_80_WOMEN_90_ABBR") : GOLFLocalizedString(@"ALLOWANCE_TYPE_MEN_80_WOMEN_90"));

		case A60B40AllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_TYPE_A_PLAYER_60_B_40_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"ALLOWANCE_TYPE_A_PLAYER_60_B_40_ABBR") : GOLFLocalizedString(@"ALLOWANCE_TYPE_A_PLAYER_60_B_40"));

		case A50B20AllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_TYPE_A_PLAYER_50_B_20_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"ALLOWANCE_TYPE_A_PLAYER_50_B_20_ABBR") : GOLFLocalizedString(@"ALLOWANCE_TYPE_A_PLAYER_50_B_20"));

		case SpecifiedPercentAllowanceType:
			{
				NSNumber *workingNumber = (info ? [info objectForKey:@"allowancePct"] : nil);
				NSInteger pct = (workingNumber ? [workingNumber integerValue] : GOLFDefaultSpecifiedPercentageAllowance);
				NSString *shortPct = [NSString stringWithFormat:@"%ld%% %@", (long)pct, GOLFLocalizedString(@"TITLE_HANDICAP_ABBR")];
				if (descriptiveText) {
#if TARGET_OS_IOS || TARGET_OS_WATCH
					NSString *clickOrTap = [GOLFLocalizedString(@"TERM_TAP") capitalizedString];
#elif TARGET_OS_MAC
					NSString *clickOrTap = [GOLFLocalizedString(@"TERM_CLICK") capitalizedString];
#endif
					*descriptiveText = [NSString stringWithFormat:GOLFLocalizedString(@"FORMAT_CLICKORTAP_%@_NUMBER_%@_TO_ADJUST"), clickOrTap, shortPct];
				}
				NSString *fullTitle = NSStringFromAllowanceType(FullHandicapAllowanceType, nil, nil);	//	"Full Handicap"
				return (needShortText ? shortPct : [NSString stringWithFormat:GOLFLocalizedString(@"%d_PCT_OF_HANDICAP_%@"), pct, fullTitle]);
			}

		case AverageCombinedAllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_CALCULATED_TEAM_HANDICAP");
			}
			return (needShortText ? GOLFLocalizedString(@"ALLOWANCE_TYPE_TEAMMATES_100_AVG_ABBR") : GOLFLocalizedString(@"ALLOWANCE_TYPE_TEAMMATES_100_AVG"));

		case AverageCombined80AllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_CALCULATED_TEAM_HANDICAP");
			}
			return (needShortText ? GOLFLocalizedString(@"ALLOWANCE_TYPE_TEAMMATES_80_AVG_ABBR") : GOLFLocalizedString(@"ALLOWANCE_TYPE_TEAMMATES_80_AVG"));

		case Aggregate3EighthsAllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_TYPE_AGGREGATE_3_8_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"ALLOWANCE_TYPE_AGGREGATE_3_8_ABBR") : GOLFLocalizedString(@"ALLOWANCE_TYPE_AGGREGATE_3_8"));

		case DifferenceAllowanceType:
			{
				if (descriptiveText) {
					*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_TYPE_DIFFERENCE_DESC");
				}
				NSString *fullTitle = (needShortText ? GOLFLocalizedString(@"ALLOWANCE_TYPE_DIFFERENCE_ABBR") : GOLFLocalizedString(@"ALLOWANCE_TYPE_DIFFERENCE"));
				NSNumber *workingNumber = (info ? [info objectForKey:@"lowHandicap"] : nil);
				if (workingNumber) {
					GOLFPlayingHandicap lowHdcp = [workingNumber playingHandicapValue];
					if (lowHdcp != kNotAPlayingHandicap) {
						return [fullTitle stringByAppendingString:[NSString stringWithFormat:@" (v. %@)", NSStringFromPlayingHandicap(lowHdcp)]];
					}
				}
				return fullTitle;
			}

		case ScrambleA50AllowanceType:
			if (descriptiveText) {
				*descriptiveText = [NSString stringWithFormat:GOLFLocalizedString(@"ALLOWANCE_TEAM_FOR_%d_OR_MORE_PLAYERS"), 1];
			}
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_A_PLAYER_50");

		case ScrambleA35B15AllowanceType:
			if (descriptiveText) {
				*descriptiveText = [NSString stringWithFormat:GOLFLocalizedString(@"ALLOWANCE_TEAM_FOR_%d_OR_MORE_PLAYERS"), 2];
			}
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_A_PLAYER_35_B_15");

		case ScrambleA25B15C10AllowanceType:
			if (descriptiveText) {
				*descriptiveText = [NSString stringWithFormat:GOLFLocalizedString(@"ALLOWANCE_TEAM_FOR_%d_OR_MORE_PLAYERS"), 3];
			}
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_A_PLAYER_25_B_15_C_10");

		case ScrambleA20B15C10D5AllowanceType:
			if (descriptiveText) {
				*descriptiveText = [NSString stringWithFormat:GOLFLocalizedString(@"ALLOWANCE_TEAM_FOR_%d_OR_MORE_PLAYERS"), 4];
			}
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_A_PLAYER_20_B_15_C_10_D_5");

		case ScrambleScheidAllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_ONE_TIME_TEAM");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_SCHEID") : GOLFLocalizedString(@"ALLOWANCE_TYPE_SCHEID_SCRAMBLE"));

		case ScrambleZigZagAllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_ONE_TIME_TEAM");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_ZIGZAG") : GOLFLocalizedString(@"ALLOWANCE_TYPE_ZIG_ZAG_SYSTEM"));

		case CallawayAllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_ONE_TIME_PLAYER");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_CALLAWAY") : GOLFLocalizedString(@"ALLOWANCE_TYPE_OFFICIAL_CALLAWAY"));

		case ScheidAllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_ONE_TIME_PLAYER");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_SCHEID") : GOLFLocalizedString(@"ALLOWANCE_TYPE_SCHEID_SYSTEM"));

		case PeoriaAllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_ONE_TIME_PLAYER");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_PEORIA") : GOLFLocalizedString(@"ALLOWANCE_TYPE_PEORIA"));

		case ModifiedPeoriaAllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_ONE_TIME_PLAYER");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_PEORIA") : GOLFLocalizedString(@"ALLOWANCE_TYPE_MODIFIED_PEORIA"));

		case System36AllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_ONE_TIME_PLAYER");
			}
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_SYSTEM_36");

		case UnknownAllowanceType:
		default:
			if (descriptiveText) {
				*descriptiveText = @"";
			}
			return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	}
}

//=================================================================
//	NSStringFromPlayType(playType, info, descriptiveText)
//=================================================================
NSString * NSStringFromPlayType(GOLFPlayType playType, NSDictionary *info, NSString **descriptiveText) {
//	info (optional):
//	key					type			description
//	------------------	--------------	-------------------------------------------------------
//	short				NSNumber *		BOOL indicating need for short (abbreviated?) return (if available)
//	bestRoundsN			NSNumber *		Integer N of TeamBestNPlayType (Team total of best N rounds) - default: 4
//	maxScoreMethod		NSNumber *		GOLFMaxScoreMethod identifying MaxScore allowance calculation

//		Play/Competition Types
//
//		Type							  Numeric		Play Type
//		----------------------------	-------------	-----------------------------------------------------
//		MedalPlayType						1			Medal play
//		SelectedHolesPlayType,				2			Medal play with selected holes
//		MaximumScorePlayType,				3			Medal play with limited hole scores	(WHS)
//		StablefordPlayType					10			Stableford												(FirstStablefordPlayType)
//		ModifiedStablefordPlayType			11			Modified Stableford
//		HalfStablefordPlayType				12			Half-Stableford
//		ChicagoPlayType						13			Chicago (modified Stableford)
//		InternationalPlayType				14			International scoring									(LastStablefordPlayType)
//		NinePointGamePlayType				20			9's (9-Point Game)
//		SixPointGamePlayType				21			6-Point Game
//		MedalMatchPlayType					22			Medal Match Play (2 pts/hole per co-competitor)			(LastPlayerPlayType)
//		BetterBallTeamPlayType				30			Better-ball (1 best ball of team)
//		TwoBestBallsTeamPlayType			31			2-ball total (2 best balls of team)
//		ThreeBestBallsTeamPlayType			32			3-ball total (3 best balls of team)
//		TheRitzTeamPlayType					33			The Ritz (best gross, best net)
//		TheRitzReverseTeamPlayType			34			The Ritz in Reverse (best net, best gross)
//		FourBallTeamPlayType				35			Four-ball (1 best ball of 2)
//		FoursomesTeamPlayType				40			Multi-player ball (Foursomes)							(FirstTeamOnlyPlayType)
//		GreensomesTeamPlayType				41			Multi-player ball (Foursomes with selected drive)
//		ScrambleTeamPlayType				42			Multi-player ball (Scramble)
//		ChapmanTeamPlayType					43			Multi-player ball (Chapman/Pinehurst)					(LastTeamOnlyPlayType)
//		WaltzTeamPlayType					50			3-ball (par 3's), 2-ball (par 4's), 1-ball (par 5's)
//		ModifiedWaltzTeamPlayType			51			2-ball (par 3's and 4's), 1-ball (par 5's)
//		ChaChaChaTeamPlayType				52			1-ball, 2-balls, 3-balls (repeated)
//		ChaChaTeamPlayType					53			1-ball, 2-balls (repeated)
//		IrishFourBallTeamPlayType			54			1-ball (x6), 2-balls (x5), 3-balls (x4), 4-balls (x3)
//		BowmakerThreeBallTeamPlayType		55			1-ball (x6), 2-balls (x6), 3-balls (x6)
//		TotalTeamPlayType					80			Team total
//		PlayerAverageTeamPlayType			81			Team-member average
//		TeamBestNPlayType					82			Team total of best N rounds	(N = "bestRoundsN")
//		FourballComboTeamPlayType			89			Multi-teams per scorecard
//		NoTeamPlayType						90			Individual-only competition
//		TeamOnlyPlayType					91			Team-only scoring (no individual scoring)
//		UnknownPlayType						99			Unknown or erroneous play type / round style

	BOOL needShortText = (info ? [[info objectForKey:@"short"] boolValue] : NO);	//	Return "short" variation if available

	switch(playType) {
		case MedalPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_MEDAL_PLAY_DESC");
			}
			return (needShortText ? [GOLFLocalizedString(@"TERM_MEDAL") capitalizedString] : GOLFLocalizedString(@"PLAY_TYPE_MEDAL_PLAY"));

		case SelectedHolesPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_SELECTED_HOLES_DESC");
			}
			return (needShortText ? [GOLFLocalizedString(@"TERM_SELECTED") capitalizedString] : GOLFLocalizedString(@"PLAY_TYPE_SELECTED_HOLES"));

		case MaximumScorePlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_MAXIMUM_SCORE_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"PLAY_TYPE_MAXIMUM_SCORE_ABBR") : GOLFLocalizedString(@"PLAY_TYPE_MAXIMUM_SCORE"));

		case StablefordPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_STABLEFORD_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_STABLEFORD") : GOLFLocalizedString(@"PLAY_TYPE_STABLEFORD"));

		case ModifiedStablefordPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_MODIFIED_STABLEFORD_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_STABLEFORD") : GOLFLocalizedString(@"PLAY_TYPE_MODIFIED_STABLEFORD"));

		case HalfStablefordPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_HALF_STABLEFORD_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_STABLEFORD") : GOLFLocalizedString(@"PLAY_TYPE_HALF_STABLEFORD"));

		case ChicagoPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_CHICAGO_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_CHICAGO") : GOLFLocalizedString(@"PLAY_TYPE_CHICAGO"));

		case InternationalPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_INTERNATIONAL_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_INTERNATIONAL") : GOLFLocalizedString(@"PLAY_TYPE_INTERNATIONAL"));

		case NinePointGamePlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_9_POINT_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_NINEPT") : GOLFLocalizedString(@"PLAY_TYPE_9_POINT"));

		case SixPointGamePlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_6_POINT_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_SIXPT") : GOLFLocalizedString(@"PLAY_TYPE_6_POINT"));

		case MedalMatchPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_MEDAL_MATCH_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_MEDALMATCH") : GOLFLocalizedString(@"PLAY_TYPE_MEDAL_MATCH"));

		case BetterBallTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_BETTER_BALL_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_BESTBALL") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_BETTER_BALL"));

		case TwoBestBallsTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_TWO_BEST_BALLS_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_BESTBALL") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_TWO_BEST_BALLS"));

		case ThreeBestBallsTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_THREE_BEST_BALLS_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_BESTBALL") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_THREE_BEST_BALLS"));

		case TheRitzTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_RITZ_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_RITZ") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_RITZ"));

		case TheRitzReverseTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_RITZ_REVERSE_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_REVERSERITZ") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_RITZ_REVERSE"));

		case FourBallTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_FOUR_BALL_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_FOURBALL") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_FOUR_BALL"));

		case FoursomesTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_FOURSOMES_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_FOURSOMES") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_FOURSOMES"));

		case GreensomesTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_GREENSOMES_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_GREENSOMES") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_GREENSOMES"));

		case ScrambleTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_SCRAMBLE_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_SCRAMBLE") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_SCRAMBLE"));

		case ChapmanTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_CHAPMAN_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_CHAPMAN") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_CHAPMAN"));

		case WaltzTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_WALTZ_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_WALTZ") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_WALTZ"));

		case ModifiedWaltzTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_MODIFIED_WALTZ_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_WALTZ") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_MODIFIED_WALTZ"));

		case ChaChaChaTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_CHA_CHA_CHA_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_CHACHACHA") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_CHA_CHA_CHA"));

		case ChaChaTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_CHA_CHA_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_CHACHA") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_CHA_CHA"));

		case IrishFourBallTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_IRISH_4_BALL_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_IRISH") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_IRISH_4_BALL"));

		case BowmakerThreeBallTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_BOWMAKER_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_BOWMAKER") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_BOWMAKER"));

		case TotalTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_TOTAL_DESC");
			}
			return (needShortText ? [GOLFLocalizedString(@"TERM_TOTAL") capitalizedString] : GOLFLocalizedString(@"PLAY_TYPE_TEAM_TOTAL"));

		case PlayerAverageTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_AVG_DESC");
			}
			return (needShortText ? [GOLFLocalizedString(@"TERM_AVERAGE") capitalizedString] : GOLFLocalizedString(@"PLAY_TYPE_TEAM_AVG"));

		case TeamBestNPlayType:
			{
				if (descriptiveText) {
#if TARGET_OS_IOS || TARGET_OS_WATCH
					NSString *clickOrTap = [GOLFLocalizedString(@"TERM_TAP") capitalizedString];
#elif TARGET_OS_MAC
					NSString *clickOrTap = [GOLFLocalizedString(@"TERM_CLICK") capitalizedString];
#endif
					*descriptiveText = [NSString stringWithFormat:GOLFLocalizedString(@"FORMAT_CLICKORTAP_%@_NUMBER_TO_ADJUST"), clickOrTap];
				}
				NSNumber *workingNumber = (info ? [info objectForKey:@"bestRoundsN"] : nil);
				if (workingNumber == nil) {
					return (needShortText
							? [GOLFLocalizedString(@"TERM_BEST") capitalizedString]				//	"Best"
							: GOLFLocalizedString(@"PLAY_TYPE_TEAM_BEST_TEAMMATES_ROUNDS"));	//	"Best Rounds of Teammates"
				} else {
					NSInteger bestN = MAX(1, [workingNumber integerValue]);
					return (needShortText
							? [NSString stringWithFormat:@"%@ %ld", [GOLFLocalizedString(@"TERM_BEST") capitalizedString], (long)bestN]
							: [NSString stringWithFormat:@"%ld %@", (long)bestN, ((bestN > 1) ? GOLFLocalizedString(@"PLAY_TYPE_TEAM_BEST_ROUNDS") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_BEST_ROUND"))]);
				}
			}

		case FourballComboTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_FOURBALL_COMBO_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_FOURBALL") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_FOURBALL_COMBO"));

		case NoTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_NO_TEAM_PLAY_DESC");
			}
			return (needShortText ? nil : GOLFLocalizedString(@"PLAY_TYPE_NO_TEAM_PLAY"));

		case TeamOnlyPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_NO_PLAYER_SCORES_DESC");
			}
			return (needShortText ? nil : GOLFLocalizedString(@"PLAY_TYPE_NO_PLAYER_SCORES"));

		case UnknownPlayType:
		default:
			if (descriptiveText) {
				*descriptiveText = @"";
			}
			return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	}
}

//=================================================================
//	NSStringFromTiebreakerMethod(method, descriptiveText)
//=================================================================
NSString * NSStringFromTiebreakerMethod(GOLFTiebreakerMethod method, NSString **descriptiveText) {

//		Tiebreaker Methods
//
//		Method								Value		Description
//		--------------------------------	--------	-----------------------------------
//		GOLFTiebreakerMethodNone				0		No tie-breaking
//		GOLFTiebreakerMethodUSGA				1		USGA tie-breaking method (back nine, last 6, last 3, last hole)
//		GOLFTiebreakerMethodHandicapsForward	2		Hole-by-hole handicap tie-breaking method (no. 1 handicap, no. 2 handicap, etc.)
//		GOLFTiebreakerMethodHandicapsBackward	3		Hole-by-hole handicap tie-breaking method (no. 18 handicap, no. 17 handicap, etc.)
//		GOLFTiebreakerMethodHolesForward		4		Hole-by-hole handicap tie-breaking method (1st hole, 2nd hole, etc.)
//		GOLFTiebreakerMethodHolesBackward		5		Hole-by-hole handicap tie-breaking method (18th hole, 17th hole, etc.)
//		GOLFTiebreakerMethodHigherHandicap		6		Higher team or individual handicap wins
//		GOLFTiebreakerMethodLowerHandicap		7		Lower team or individual handicap wins
//		GOLFTiebreakerMethodUnknown				99		Unknown or error method
	
	switch(method) {
		case GOLFTiebreakerMethodNone:
			if (descriptiveText) {
				*descriptiveText = @"";
			}
			return GOLFLocalizedString(@"TIEBREAKING_NONE");
			
		case GOLFTiebreakerMethodUSGA:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"TIEBREAKING_USGA_DESC");
			}
			return GOLFLocalizedString(@"TIEBREAKING_USGA");
			
		case GOLFTiebreakerMethodHandicapsForward:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"TIEBREAKING_HDCP_FORWARD_DESC");
			}
			return GOLFLocalizedString(@"TIEBREAKING_HDCP_FORWARD");
			
		case GOLFTiebreakerMethodHandicapsBackward:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"TIEBREAKING_HDCP_BACKWARD_DESC");
			}
			return GOLFLocalizedString(@"TIEBREAKING_HDCP_BACKWARD");
			
		case GOLFTiebreakerMethodHolesForward:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"TIEBREAKING_HOLE_FORWARD_DESC");
			}
			return GOLFLocalizedString(@"TIEBREAKING_HOLE_FORWARD");
			
		case GOLFTiebreakerMethodHolesBackward:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"TIEBREAKING_HOLE_BACKWARD_DESC");
			}
			return GOLFLocalizedString(@"TIEBREAKING_HOLE_BACKWARD");

		case GOLFTiebreakerMethodHigherHandicap:
			if (descriptiveText != nil) {
				*descriptiveText = @"";
			}
			return GOLFLocalizedString(@"TIEBREAKING_HIGH_HANDICAP");

		case GOLFTiebreakerMethodLowerHandicap:
			if (descriptiveText != nil) {
				*descriptiveText = @"";
			}
			return GOLFLocalizedString(@"TIEBREAKING_LOW_HANDICAP");
		
		default:
			if (descriptiveText != nil) {
				*descriptiveText = ((method == GOLFTiebreakerMethodUnknown) ? @"" : [NSString stringWithFormat:@"(%lu)", (unsigned long)method]);
			}
			return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	}
}

//=================================================================
//	NSStringFromTiebreakerOutcome(outcome, result)
//=================================================================
NSString * NSStringFromTiebreakerOutcome(GOLFTiebreakerOutcome outcome, NSNumber *result) {

//		Tiebreaker Outcomes
//
//		Outcome								Value		Description
//		--------------------------------	--------	-----------------------------------
//		GOLFTiebreakerOutcomeTied				0		Couldn't break tie
//		GOLFTiebreakerOutcomeHoleScore			1		Tie was broken by score at a particular hole (forward, backward, hole handicaps, hole numbers)
//		GOLFTiebreakerOutcomeLastHole			2		Tie was broken based on score of last hole
//		GOLFTiebreakerOutcomeLast3Holes			3		Tie was broken based on total score of last 3 holes
//		GOLFTiebreakerOutcomeLast6Holes			4		Tie was broken based on total score of last 6 holes
//		GOLFTiebreakerOutcomeLast9Holes			5		Tie was broken based on total score of last 9 holes
//		GOLFTiebreakerOutcomeLast18Holes		6		Tie was broken based on total score of last 18 holes
//		GOLFTiebreakerOutcomeRoundTotal			7		Tie was broken based on total round score
//		GOLFTiebreakerOutcomeHandicap			8		Tie was broken based on individual or team handicap
//		GOLFTiebreakerOutcomeRoundComplete		9		Tie was broken based on complete / incomplete round
//		GOLFTiebreakerOutcomeCoinFlip			98		Tie was broken by lot
//		GOLFTiebreakerOutcomeUnknown			99		Unknown or error result
	
	switch(outcome) {
		case GOLFTiebreakerOutcomeTied:
			return GOLFLocalizedString(@"TIEBREAKER_OUTCOME_TIED");
			
		case GOLFTiebreakerOutcomeHoleScore:
			return [NSString stringWithFormat:GOLFLocalizedString(@"TIEBREAKER_HOLE_NO_%d"), [result integerValue]];
			
		case GOLFTiebreakerOutcomeLastHole:
			return GOLFLocalizedString(@"TIEBREAKER_OUTCOME_LAST");
			
		case GOLFTiebreakerOutcomeLast3Holes:
			return GOLFLocalizedString(@"TIEBREAKER_OUTCOME_LAST_3");
			
		case GOLFTiebreakerOutcomeLast6Holes:
			return GOLFLocalizedString(@"TIEBREAKER_OUTCOME_LAST_6");
			
		case GOLFTiebreakerOutcomeLast9Holes:
			return GOLFLocalizedString(@"TIEBREAKER_OUTCOME_LAST_9");

		case GOLFTiebreakerOutcomeLast18Holes:
			return GOLFLocalizedString(@"TIEBREAKER_OUTCOME_LAST_18");

		case GOLFTiebreakerOutcomeRoundTotal:
			return GOLFLocalizedString(@"TIEBREAKER_OUTCOME_ROUND_TOTAL");

		case GOLFTiebreakerOutcomeHandicap:
			return GOLFLocalizedString(@"TIEBREAKER_OUTCOME_BY_HANDICAP");
			
		case GOLFTiebreakerOutcomeRoundComplete:
			return GOLFLocalizedString(@"TIEBREAKER_OUTCOME_BY_COMPLETE");
			
		case GOLFTiebreakerOutcomeCoinFlip:
			return GOLFLocalizedString(@"TIEBREAKER_OUTCOME_BY_LOT");

		default:
			return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	}
}

//=================================================================
//	NSStringFromMaxScoreType(type, descriptiveText)
//=================================================================
NSString * NSStringFromMaxScoreType(GOLFMaxScoreType type, NSString **descriptiveText) {

	//	Type									  Value		Description
	//	------------------------------------	--------	-----------------------------------
	//	GOLFMaxScoreTypeNone						0		Maximum score is unlimited
	//	GOLFMaxScoreTypeBogey						1		Maximum returned score is bogey (par + 1)
	//	GOLFMaxScoreTypeDoubleBogey					2		Maximum returned score is double-bogey (par + 2)
	//	GOLFMaxScoreTypeTripleBogey					3		Maximum returned score is triple-bogey (par + 3)
	//	GOLFMaxScoreTypeQuadrupleBogey				4		Maximum returned score is quadruple-bogey (par + 4)
	//	GOLFMaxScoreTypeQuintupleBogey				5		Maximum returned score is quintuple-bogey (par + 5)
	//	GOLFMaxScoreTypeWithoutHandicap				5		GOLFMaxScoreTypeQuintupleBogey for players without a handicap
	//	GOLFMaxScoreTypeSextupleBogey				6		Maximum returned score is sextuple-bogey (par + 6)
	//	GOLFMaxScoreTypeNetBogey					11      Maximum returned score equivalent to net bogey (par + 1 + strokes)
	//	GOLFMaxScoreTypeNetDoubleBogey				12		Maximum returned score equivalent to net double-bogey (par + 2 + strokes)
	//	GOLFMaxScoreTypeNetTripleBogey				13		Maximum returned score equivalent to net triple-bogey (par + 3 + strokes)
	//	GOLFMaxScoreTypeNetQuadrupleBogey			14		Maximum returned score equivalent to net quadruple-bogey (par + 4 + strokes)
	//	GOLFMaxScoreTypeDoublePar					21		Maximum returned score is twice par (par x 2)
	//	GOLFMaxScoreTypeTriplePar					22		Maximum returned score is 3 times par (par x 3)
	//	GOLFMaxScoreTypeFixedLimit					51		Maximum returned score is fixed maximum (WHSMaxScoreFixedLimitScore)
	//	GOLFMaxScoreTypeFixed_6_9_12				52		Maximum returned score is fixed maximum (6 on par 3, 9 on par 4, 12 on par 5 or higher)
	//	GOLFMaxScoreTypeUnknown						99		Maximum returned score unknown
	
	switch(type) {
		case GOLFMaxScoreTypeNone:
			if (descriptiveText) {
				*descriptiveText = @"";
			}
			return GOLFLocalizedString(@"MAX_SCORE_NONE");
			
		case GOLFMaxScoreTypeBogey:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"MAX_SCORE_BOGEY_DESC");
			}
			return GOLFLocalizedString(@"MAX_SCORE_BOGEY");
			
		case GOLFMaxScoreTypeDoubleBogey:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"MAX_SCORE_DOUBLE_BOGEY_DESC");
			}
			return GOLFLocalizedString(@"MAX_SCORE_DOUBLE_BOGEY");
			
		case GOLFMaxScoreTypeTripleBogey:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"MAX_SCORE_TRIPLE_BOGEY_DESC");
			}
			return GOLFLocalizedString(@"MAX_SCORE_TRIPLE_BOGEY");
			
		case GOLFMaxScoreTypeQuadrupleBogey:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"MAX_SCORE_QUADRUPLE_BOGEY_DESC");
			}
			return GOLFLocalizedString(@"MAX_SCORE_QUADRUPLE_BOGEY");
			
		case GOLFMaxScoreTypeQuintupleBogey:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"MAX_SCORE_QUINTUPLE_BOGEY_DESC");
			}
			return GOLFLocalizedString(@"MAX_SCORE_QUINTUPLE_BOGEY");
			
		case GOLFMaxScoreTypeSextupleBogey:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"MAX_SCORE_SEXTUPLE_BOGEY_DESC");
			}
			return GOLFLocalizedString(@"MAX_SCORE_SEXTUPLE_BOGEY");
			
		case GOLFMaxScoreTypeNetBogey:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"MAX_SCORE_NET_BOGEY_DESC");
			}
			return GOLFLocalizedString(@"MAX_SCORE_NET_BOGEY");

		case GOLFMaxScoreTypeNetDoubleBogey:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"MAX_SCORE_NET_DOUBLE_BOGEY_DESC");
			}
			return GOLFLocalizedString(@"MAX_SCORE_NET_DOUBLE_BOGEY");

		case GOLFMaxScoreTypeNetTripleBogey:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"MAX_SCORE_NET_TRIPLE_BOGEY_DESC");
			}
			return GOLFLocalizedString(@"MAX_SCORE_NET_TRIPLE_BOGEY");
		
		case GOLFMaxScoreTypeNetQuadrupleBogey:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"MAX_SCORE_NET_QUADRUPLE_BOGEY_DESC");
			}
			return GOLFLocalizedString(@"MAX_SCORE_NET_QUADRUPLE_BOGEY");
		
		case GOLFMaxScoreTypeDoublePar:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"MAX_SCORE_DOUBLE_PAR_DESC");
			}
			return GOLFLocalizedString(@"MAX_SCORE_DOUBLE_PAR");
		
		case GOLFMaxScoreTypeTriplePar:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"MAX_SCORE_TRIPLE_PAR_DESC");
			}
			return GOLFLocalizedString(@"MAX_SCORE_TRIPLE_PAR");
		
		case GOLFMaxScoreTypeFixedLimit:
			{
				GOLFScore limit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"WHSMaxScoreFixedLimitScore"] scoreValue];
				if (descriptiveText != nil) {
					*descriptiveText = [NSString stringWithFormat:GOLFLocalizedString(@"MAX_SCORE_FIXED_LIMIT_%ld_DESC"), limit];
				}
				return [NSString stringWithFormat:GOLFLocalizedString(@"MAX_SCORE_FIXED_LIMIT_%ld"), limit];
			}
		
		case GOLFMaxScoreTypeFixed_6_9_12:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"MAX_SCORE_FIXED_6_9_12_DESC");
			}
			return GOLFLocalizedString(@"MAX_SCORE_FIXED_6_9_12");
		
		default:
			if (descriptiveText != nil) {
				*descriptiveText = ((type == GOLFMaxScoreTypeUnknown) ? @"" : [NSString stringWithFormat:@"(%lu)", (unsigned long)type]);
			}
			return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	}
}

//=================================================================
//	NSStringFromSkinsEligibility(eligibility, descriptiveText)
//=================================================================
NSString * NSStringFromSkinsEligibility(GOLFSkinsEligibility eligibility, NSString **descriptiveText) {

	//	Eligibility								  Value		Description
	//	------------------------------------	--------	-----------------------------------
	//	GOLFSkinsEligibilityAllScores				0		All hole scores are eligible for skins
	//	GOLFSkinsEligibilityBogeyOrBetter			1		Only scores of bogey or better are eligible
	//	GOLFSkinsEligibilityParOrBetter				2		Only scores of par or better are eligible
	//	GOLFSkinsEligibilityUnderPar				3		Only hole scores under par are eligible

	switch(eligibility) {
		case GOLFSkinsEligibilityAllScores:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_SKINS_ALL_SCORES");
			}
			return GOLFLocalizedString(@"MENU_SKINS_ALL_SCORES");
			
		case GOLFSkinsEligibilityBogeyOrBetter:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_SKINS_BOGEY_OR_BETTER");
			}
			return GOLFLocalizedString(@"MENU_SKINS_BOGEY_OR_BETTER");
			
		case GOLFSkinsEligibilityParOrBetter:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_SKINS_PAR_OR_BETTER");
			}
			return GOLFLocalizedString(@"MENU_SKINS_PAR_OR_BETTER");
			
		case GOLFSkinsEligibilityUnderPar:
			if (descriptiveText != nil) {
				*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_SKINS_BIRDIE_OR_BETTER");
			}
			return GOLFLocalizedString(@"MENU_SKINS_UNDER_PAR");
			
		default:
			if (descriptiveText != nil) {
				*descriptiveText = [NSString stringWithFormat:@"(%lu)", (unsigned long)eligibility];
			}
			return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	}
}
