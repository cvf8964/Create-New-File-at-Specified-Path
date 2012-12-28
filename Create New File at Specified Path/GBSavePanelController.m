//
//  GBSavePanel.m
//  Create New File at Specified Path
//
//  Created by Andrew A.A. on 12/4/12.
//  Copyright (c) 2012 Andrew A.A. All rights reserved.
//

#import "GBSavePanelController.h"
#import "GBMenuItemWithFileExtention.h"

#define _duplicateFilePrompt(fileName) [NSString stringWithFormat:@"An item with the name \"%@\" already exists in the same folder.", fileName]
#define _duplicateFilePromptInfo(folderName) @"Do you want to replace the existing item in folder \"%@\"?", folderName

#define kGBPrefFormatPopUpSelectionKey @"kGBPrefFormatPopUpSelectionKey"
#define NSStandardUserDefaults [NSUserDefaults standardUserDefaults]

@interface GBSavePanelController ()

@property (nonatomic, strong) NSURL *outputFolderURL;
@property (nonatomic, strong) NSBundle *serviceBundle;
@property (unsafe_unretained) IBOutlet NSPopUpButton *formatPopUp;

- (IBAction)formatPopUpIsPressed:(id)sender;

@end

@implementation GBSavePanelController

- (void)dealloc
{
	[_serviceBundle release];
	[_outputFolderURL release];
	[super dealloc];
}


- (id)initWithOutputFolderPath:(NSString *)outputFolderPath
{
    self = [super initWithNibName:@"GBSavePanel" bundle:self.serviceBundle];
    if (self)
		self.outputFolderURL = [NSURL fileURLWithPath:outputFolderPath];
    return self;
}

- (void)formatPopUpIsPressed:(id)sender
{
	[NSStandardUserDefaults setInteger:self.formatPopUp.selectedTag forKey:kGBPrefFormatPopUpSelectionKey];
}

- (BOOL)runModal
{
	BOOL isSuccessful = NO;
	NSSavePanel *savePanel = [[NSSavePanel alloc] init];
	NSFileManager *fileManager = [NSFileManager defaultManager];

	[savePanel setPrompt:@"Create"];
	[savePanel setExtensionHidden:YES];
	[savePanel setAccessoryView:self.view];
	[savePanel setNameFieldStringValue:@"Untitled"];

	BOOL isDirectory;
	
	[fileManager fileExistsAtPath:self.outputFolderURL.path isDirectory:&isDirectory];

	if (!isDirectory)
		self.outputFolderURL = [self.outputFolderURL URLByDeletingLastPathComponent];

	[savePanel setDirectoryURL:self.outputFolderURL];

	[self.formatPopUp selectItemWithTag:[NSStandardUserDefaults integerForKey:kGBPrefFormatPopUpSelectionKey]];
	NSInteger savePanelReturnCode = [savePanel runModal];

	while (savePanelReturnCode == NSFileHandlingPanelOKButton) {
		if (savePanel.directoryURL != self.outputFolderURL)
			self.outputFolderURL = savePanel.directoryURL;	// no retain

		NSString *extention = [(GBMenuItemWithFileExtention *)self.formatPopUp.selectedItem fileExtention];
		NSString *fileName = [NSString stringWithFormat:@"%@.%@", savePanel.nameFieldStringValue, extention];
		NSString *filePath = [self.outputFolderURL.path stringByAppendingPathComponent:fileName];

		// present the save panel again if file already exists
		if ([fileManager fileExistsAtPath:filePath]) {
			NSAlert *anAlert = [NSAlert alertWithMessageText:_duplicateFilePrompt(fileName) defaultButton:@"Rename" alternateButton:@"Overwrite" otherButton:@"Cancel" informativeTextWithFormat:_duplicateFilePromptInfo(self.outputFolderURL.lastPathComponent)];

			NSInteger alertReturnCode = [anAlert runModal];

			if (alertReturnCode == NSAlertOtherReturn)
				break;
			else if (alertReturnCode == NSAlertDefaultReturn) {
				savePanelReturnCode = [savePanel runModal];
				continue;
			}
			else if (alertReturnCode == NSAlertAlternateReturn) {
				NSError *anError = nil;
				
				[fileManager removeItemAtPath:filePath error:&anError];

				if (anError) {
					NSAlert *anotherAlert = [NSAlert alertWithError:anError];
					[anotherAlert runModal];
					break;
				}
			}
		}

		NSDictionary *fileAttributes = @{NSFileExtensionHidden : [NSNumber numberWithBool:YES]};
		NSMutableData *fileData = [NSData dataWithContentsOfFile:[self.serviceBundle pathForResource:@"Template" ofType:extention]];
		NSError *anError = nil;
		
		[fileData writeToFile:filePath options:NSDataWritingAtomic error:&anError];

		if (!anError) {
			isSuccessful = YES;
			[fileManager setAttributes:fileAttributes ofItemAtPath:filePath error:nil];
		}
		else {
			NSAlert *anotherAlert = [NSAlert alertWithError:anError];
			[anotherAlert runModal];
		}

		break;
	}
	return YES;
}

- (NSBundle *)serviceBundle
{
	if (!_serviceBundle)
		_serviceBundle = [NSBundle bundleForClass:[self class]];
	return _serviceBundle;
}

@end
