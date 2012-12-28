//
//  Create_New_File_at_Specified_Path.m
//  Create New File at Specified Path
//
//  Created by Andrew A.A. on 12/3/12.
//  Copyright (c) 2012 Andrew A.A. All rights reserved.
//

#import "Create_New_File_at_Specified_Path.h"
#import "GBSavePanelController.h"

@implementation Create_New_File_at_Specified_Path

- (id)runWithInput:(id)inputArray fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo
{
	for (NSString *folder in inputArray) {

		GBSavePanelController *aController = [[GBSavePanelController alloc] initWithOutputFolderPath:folder];

		[aController runModal];
		[aController release];
	}

	return inputArray;
}

@end
