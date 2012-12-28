//
//  GBSavePanel.h
//  Create New File at Specified Path
//
//  Created by Andrew A.A. on 12/4/12.
//  Copyright (c) 2012 Andrew A.A. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GBSavePanelController : NSViewController

- (id)initWithOutputFolderPath:(NSString *)outputFolderPath;

- (BOOL)runModal;

@end
