//
//  MMXMLAnalysisUnit.m
//  MMUnitLib
//
//  Created by Loren on 2018/5/29.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "MMXMLAnalysisUnit.h"

@interface MMXMLAnalysisUnit()<NSXMLParserDelegate>
@property (nonatomic, strong)NSMutableDictionary * controlDictionary;
@property (nonatomic, strong)NSMutableArray * xmlArray;
@property (nonatomic, strong)NSMutableArray * elementArray;
@end

@implementation MMXMLAnalysisUnit

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)analysXMLWithURL:(NSURL *)url{
    NSXMLParser * parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    parser.delegate = self;
    self.controlDictionary = [NSMutableDictionary dictionary];
    self.xmlArray = [NSMutableArray array];
    self.elementArray = [NSMutableArray array];
    BOOL isError = ![parser parse];
    if (isError) {
        MM_NSLog(@"%@",parser.parserError);
    }
    MM_NSLog(@"");
}

#pragma mark - NSXMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
    MM_NSLog(@"%@ %@",NSStringFromSelector(_cmd),self.xmlArray);
}

- (void)parser:(NSXMLParser *)parser foundNotationDeclarationWithName:(NSString *)name publicID:(nullable NSString *)publicID systemID:(nullable NSString *)systemID{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)parser:(NSXMLParser *)parser foundUnparsedEntityDeclarationWithName:(NSString *)name publicID:(nullable NSString *)publicID systemID:(nullable NSString *)systemID notationName:(nullable NSString *)notationName{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(nullable NSString *)type defaultValue:(nullable NSString *)defaultValue{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(nullable NSString *)value{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)name publicID:(nullable NSString *)publicID systemID:(nullable NSString *)systemID{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    [self.elementArray addObject:elementName];
    [self.xmlArray addObject:attributeDict];
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    [self.elementArray removeLastObject];
//    [self.xmlArray addObject:self.controlDictionary];
    if (self.elementArray.count == 0) {
        self.controlDictionary = [NSMutableDictionary dictionary];
    }
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(nullable NSString *)data{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (nullable NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)name systemID:(nullable NSString *)systemID{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
    return nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    MM_NSLog(@"%@",NSStringFromSelector(_cmd));
 }
@end
