//
//  TextViewController.m
//  memorial_icloud
//
//  Created by Colin Yang Hong on 13-9-26.
//  Copyright (c) 2013年 Yang Hong. All rights reserved.
//

#import "TextViewController.h"
#import "AppDelegate.h"

@interface TextViewController ()

- (IBAction)tapTextView:(id)sender;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (weak) AppDelegate *myDelegate;
@end

@implementation TextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _textView.delegate = (id) self;
    

	// Do any additional setup after loading the view.
    if (_aNote == nil) {
        [self insertNote];
    }
    self.navigationItem.title = _aNote.title;
    _textView.text = _aNote.content;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (_textView.text.length == 0) {
        [self deleteNote];
    } else {
        [self updateNote];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    for (NSString *subStr in [_textView.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        if (subStr.length > 0) {
            self.navigationItem.title = subStr;
            break;
        }
    }
}

- (void)updateNote
{
    _aNote.title = self.navigationItem.title;
    _aNote.content = _textView.text;
    _aNote.modify_at = [NSDate date];
    
    NSError *error;
    BOOL isUpdateSuccess = [self.myDelegate.managedObjectContext save:&error ];
    if (!isUpdateSuccess) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
}

- (void)deleteNote
{
    [self.myDelegate.managedObjectContext deleteObject:_aNote];
    
    NSError *error;
    if (![self.myDelegate.managedObjectContext save:&error]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
}

- (void)insertNote
{
    self.aNote = (Note *)[NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:self.myDelegate.managedObjectContext];
    _aNote.title = @"";
    _aNote.content = @"";
    _aNote.create_at = [NSDate date];
    
    NSError *error;
    
    //托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    BOOL isSaveSuccess = [self.myDelegate.managedObjectContext save:&error];
    
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }else {
        NSLog(@"Save successful!");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapTextView:(id)sender
{
    [_textView resignFirstResponder];
}
@end
