//
//  ChemicalsListViewController.m
//  aires
//
//  Created by Gautham on 01/05/13.
//  Copyright (c) 2013 Imaginea. All rights reserved.
//

#import "ChemicalsListViewController.h"
#import "SampleChemical.h"

@interface NSArray (SSArrayOfArrays)
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation NSArray (SSArrayOfArrays)

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
}

@end

@interface NSMutableArray (SSArrayOfArrays)
// If idx is beyond the bounds of the reciever, this method automatically extends the reciever to fit with empty subarrays.
- (void)addObject:(id)anObject toSubarrayAtIndex:(NSUInteger)idx;
@end

@implementation NSMutableArray (SSArrayOfArrays)

- (void)addObject:(id)anObject toSubarrayAtIndex:(NSUInteger)idx
{
    while ([self count] <= idx) {
        [self addObject:[NSMutableArray array]];
    }
    
    [[self objectAtIndex:idx] addObject:anObject];
}

@end


@implementation ChemicalsListViewController
@synthesize listContent, filteredListContent, sectionedListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;

- (void)setListContent:(NSArray *)inListContent
{
    if (listContent == inListContent) {
        return;
    }
    listContent = inListContent ;
    
    NSMutableArray *sections = [NSMutableArray array];
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    for (SampleChemical *chemical in listContent) {
        NSInteger section = [collation sectionForObject:chemical collationStringSelector:@selector(sampleChemical_Name)];
        [sections addObject:chemical toSubarrayAtIndex:section];
    }
    
    NSInteger section = 0;
    for (section = 0; section < [sections count]; section++) {
        NSArray *sortedSubarray = [collation sortedArrayFromArray:[sections objectAtIndex:section]
                                          collationStringSelector:@selector(sampleChemical_Name)];
        [sections replaceObjectAtIndex:section withObject:sortedSubarray];
    }
    sectionedListContent = sections;
}

#pragma mark -
#pragma mark Lifecycle methods

- (void)viewDidLoad
{
    [self setTitle:@"Choose a Chemical"];
    
	// create a filtered list that will contain products for the search results table.
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
}


- (void)viewDidUnload
{
	// Save the state of the search UI so that it can be restored if the view is re-created.
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
	
	self.filteredListContent = nil;
}

#pragma mark -
#pragma mark UITableView data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return 1;
    }
	else
	{
        return [self.sectionedListContent count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [[self.sectionedListContent objectAtIndex:section] count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] ;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	SampleChemical *chemical = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        chemical = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        chemical = [self.sectionedListContent objectAtIndexPath:indexPath];
    }
	
	cell.textLabel.text = chemical.sampleChemical_Name;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	/*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	SampleChemical *chemical = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        chemical = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        chemical = [self.sectionedListContent objectAtIndexPath:indexPath];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(addChemicalNumber:chemical:)])
    {
        [_delegate addChemicalNumber:indexPath.row+1 chemical:chemical];
    }
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
    for (NSArray *section in self.sectionedListContent) {
        for (SampleChemical *chemical in section)
        {
            NSComparisonResult result = [chemical.sampleChemical_Name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
            {
                [self.filteredListContent addObject:chemical];
            }
        }
    }
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[self.sectionedListContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

@end
