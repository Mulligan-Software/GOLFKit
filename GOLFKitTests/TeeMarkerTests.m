//
//  TeeMarkerTests.m
//  GOLFKitTests
//
//  Created by John Bishop on 10/24/17.
//  Copyright © 2017 Mulligan Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <GOLFKit/GOLFKit.h>
#import <GOLFKit/GOLFTeeMarkers.h>

@interface TeeMarkerTests : XCTestCase
@end

@implementation TeeMarkerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testTeeMarkerNameLocalizations {
	for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
		GOLFTeeColorIndex colorIndex = [[colorDict objectForKey:@"teeColorIndex"] teeColorIndexValue];
		NSString *testName = GOLFTeeColorNameFromTeeColorIndex(colorIndex);
		XCTAssertNotNil(testName, @"English name for colorIndex %ld is nil", (long)colorIndex);
	}
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

//@interface TableValidationTests: XCTestCase
//@end
//@implementation TableValidationTests
///// Tests that a new table instance has zero rows and columns.
//- (void)testEmptyTableRowAndColumnCount {
//    Table *table = [[Table alloc] init];
//    XCTAssertEqual(table.rowCount, 0, "Row count was not zero.");
//    XCTAssertEqual(table.columnCount, 0, "Column count was not zero.");
//}
//@end

