//
//  PPEListViewController
//  aires
//
//  Created by Gautham on 01/05/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SampleProtectionEquipment;
@protocol PPEListProtocol;

@interface PPEListViewController : UIViewController<UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
	NSArray			*listContent;			// The master content.
	NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.
    NSArray         *sectionedListContent;  // The content filtered into alphabetical sections.
	
	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *ppeTableView;

@property (nonatomic, retain) id<PPEListProtocol> delegate;

@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain, readonly) NSArray *sectionedListContent;

@property (nonatomic, retain) NSMutableArray *selectedContent;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@end

@protocol PPEListProtocol <NSObject>

-(void)ppeListBackPressed;
-(void)selectedPPE:(NSArray*)array;

@end
