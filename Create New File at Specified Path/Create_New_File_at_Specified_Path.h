//
//  Create_New_File_at_Specified_Path.h
//  Create New File at Specified Path
//
//  Created by Andrew A.A. on 12/3/12.
//  Copyright (c) 2012 Andrew A.A. All rights reserved.
//

#import <Automator/AMBundleAction.h>

@interface Create_New_File_at_Specified_Path : AMBundleAction

- (id)runWithInput:(id)inputArray fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end
