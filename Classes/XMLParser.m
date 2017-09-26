/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

//
//  XMLParser.m
//  Created by Erica Sadun on 4/6/09.
//

#import "XMLParser.h"

@implementation XMLParser

static XMLParser *sharedInstance = nil;

// Use just one parser instance at any time
+(XMLParser *) sharedInstance 
{
    if (![NSThread currentThread].isMainThread)
    {
        return [[[self alloc] init] autorelease];
    }
    else if(!sharedInstance) {
		sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

// Parser returns the tree root. You may have to go down one node to the real results
- (TreeNode *) parse: (NSXMLParser *) parser
{
	stack = [NSMutableArray array];
	
	TreeNode *root = [TreeNode treeNode];
	
	[stack addObject:root];
	
	[parser setDelegate:self];
	[parser parse];
    [parser release];

	// pop down to real root
	TreeNode *realroot = [[root children] lastObject];
    [realroot retain];

	realroot.parent = nil;
	return [realroot autorelease];
}


- (TreeNode *)parseXMLFromURL: (NSURL *) url
{	
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	return [self parse:parser];
}

- (TreeNode *)parseXMLFromData: (NSData *) data
{	
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	return [self parse:parser];
}



// Descend to a new element
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName)
    {
        elementName = qName;
    }
	
    TreeNode* leaf = [[TreeNode alloc] init];
	leaf.parent = [stack lastObject];
    [leaf.parent.children addObject:leaf];
	
    leaf.key = elementName;
	leaf.leafvalue = nil;
    leaf.attributeDict = attributeDict;

	[stack addObject:leaf];
    [leaf release];
    leaf = nil;
}

// Pop after finishing element
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	[stack removeLastObject];
}

// Reached a leaf
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (![[stack lastObject] leafvalue])
	{
		[[stack lastObject] setLeafvalue:string];
		return;
	}
	[[stack lastObject] setLeafvalue:[NSString stringWithFormat:@"%@%@", [[stack lastObject] leafvalue], string]];
}

@end



