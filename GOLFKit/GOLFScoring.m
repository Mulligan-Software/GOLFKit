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

#if TARGET_OS_IOS || TARGET_OS_WATCH
	NSString *clickOrTap = [GOLFLocalizedString(@"TERM_TAP") capitalizedString];
#elif TARGET_OS_MAC
	NSString *clickOrTap = [GOLFLocalizedString(@"TERM_CLICK") capitalizedString];
#endif

	switch (allowanceType) {
		case PeoriaAllowanceType:
			return [NSString stringWithFormat:GOLFLocalizedString(@"INSTRUCTION_PEORIA_%@_CLICKORTAP"), clickOrTap];

		case ModifiedPeoriaAllowanceType:
			return [NSString stringWithFormat:GOLFLocalizedString(@"INSTRUCTION_MODIFIED_PEORIA_%@_CLICKORTAP"), clickOrTap];

		case ScrambleZigZagAllowanceType:
			return [NSString stringWithFormat:GOLFLocalizedString(@"INSTRUCTION_ZIG_ZAG_%@_CLICKORTAP"), clickOrTap];

		default:
			return [NSString stringWithFormat:GOLFLocalizedString(@"INSTRUCTION_SELECTED_HOLES_%@_CLICKORTAP"), clickOrTap];
	}
}

#pragma mark NSStringFrom… Utilities

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
//		SpecifiedPercentageAllowanceType	15			A specified percentage of Playing Handicap
//
//		AverageCombinedAllowanceType		20			Average of teammates' Playing Handicaps (Foursomes)
//		AverageCombined80AllowanceType		21			80% of average teammates' handicap (Greensomes)
//		Aggregate3EighthsAllowanceType		22			3/8 of aggregate team handicap (American Foursomes)
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

	if (authority == nil) authority = GOLFDefaultHandicapAuthority();
	
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
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_MEN_90_WOMEN_95");

		case Men80Women90AllowanceType:
			if (descriptiveText) {
				*descriptiveText = [NSString stringWithFormat:@"%@ %@", [GOLFLocalizedString(@"OF") lowercaseString], GOLFPlayingHandicapTitle(methodIndex, NO)];
			}
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_MEN_80_WOMEN_90");

		case A60B40AllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_TYPE_A_PLAYER_50_B_40_DESC");
			}
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_A_PLAYER_50_B_40");

		case A50B20AllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_TYPE_A_PLAYER_50_B_20_DESC");
			}
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_A_PLAYER_50_B_20");

		case SpecifiedPercentAllowanceType:
			{
				if (descriptiveText) {
#if TARGET_OS_IOS || TARGET_OS_WATCH
					NSString *clickOrTap = [GOLFLocalizedString(@"TERM_TAP") capitalizedString];
#elif TARGET_OS_MAC
					NSString *clickOrTap = [GOLFLocalizedString(@"TERM_CLICK") capitalizedString];
#endif
					*descriptiveText = [NSString stringWithFormat:GOLFLocalizedString(@"CLICKORTAP_%@_NUMBER_TO_ADJUST"), clickOrTap];
				}
				NSNumber *workingNumber = (info ? [info objectForKey:@"allowancePct"] : nil);
				NSInteger pct = (workingNumber ? [workingNumber integerValue] : GOLFDefaultSpecifiedPercentageAllowance);
				NSString *fullTitle = NSStringFromAllowanceType(FullHandicapAllowanceType, nil, nil);	//	"Full Handicap"
				return (needShortText ? [NSString stringWithFormat:@"%ld%%", (long)pct] : [NSString stringWithFormat:GOLFLocalizedString(@"%d_PCT_OF_HANDICAP_%@"), pct, fullTitle]);
			}

		case AverageCombinedAllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_CALCULATED_TEAM_HANDICAP");
			}
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_TEAMMATES_100_AVG");

		case AverageCombined80AllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_CALCULATED_TEAM_HANDICAP");
			}
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_TEAMMATES_80_AVG");

		case Aggregate3EighthsAllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_TYPE_AGGREGATE_3_8_DESC");
			}
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_AGGREGATE_3_8");

		case DifferenceAllowanceType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"ALLOWANCE_TYPE_DIFFERENCE_DESC");
			}
			return GOLFLocalizedString(@"ALLOWANCE_TYPE_DIFFERENCE");

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

//		Play/Competiton Types
//
//		Type							  Numeric		Play Type
//		----------------------------	-------------	-----------------------------------------------------
//		MedalPlayType						1			Medal play
//		SelectedHolesPlayType,				2			Medal play with selected holes
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
			return (needShortText ? GOLFLocalizedString(@"TERM_TOTAL") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_TOTAL"));

		case PlayerAverageTeamPlayType:
			if (descriptiveText) {
				*descriptiveText = GOLFLocalizedString(@"PLAY_TYPE_TEAM_AVG_DESC");
			}
			return (needShortText ? GOLFLocalizedString(@"TERM_AVERAGE") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_AVG"));

		case TeamBestNPlayType:
			{
				if (descriptiveText) {
#if TARGET_OS_IOS || TARGET_OS_WATCH
					*descriptiveText = GOLFLocalizedString(@"TAP_NUMBER_TO_ADJUST");
#elif TARGET_OS_MAC
					*descriptiveText = GOLFLocalizedString(@"CLICK_NUMBER_TO_ADJUST");
#endif
				}
				NSNumber *workingNumber = (info ? [info objectForKey:@"bestRoundsN"] : nil);
				NSInteger bestN = (workingNumber ? [workingNumber integerValue] : 4);
				return (needShortText
						? [NSString stringWithFormat:@"%@ %ld", [GOLFLocalizedString(@"TERM_BEST") capitalizedString], (long)bestN]
						: [NSString stringWithFormat:@"%ld %@", (long)bestN, ((bestN > 1) ? GOLFLocalizedString(@"PLAY_TYPE_TEAM_BEST_ROUNDS") : GOLFLocalizedString(@"PLAY_TYPE_TEAM_BEST_ROUND"))]);
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