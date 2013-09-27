//
//  MainViewController.m
//  memorial_icloud
//
//  Created by Colin Yang Hong on 13-9-26.
//  Copyright (c) 2013年 Yang Hong. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "Note.h"
#import "MainTableViewCell.h"
#import "TextViewController.h"

@interface MainViewController ()

@property (strong) NSMutableArray *notes;
@property (strong) AppDelegate *myDelegate;

@property (strong) Note *selectedNote;

@end

@implementation MainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateData];
    self.navigationItem.title = [NSString stringWithFormat:@"备忘录(%d)",[self.notes count]];
    [self.tableView reloadData];
}

// 查询操作
- (void)updateData
{
    //创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //设置要检索哪种类型的实体对象 (Student)
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.myDelegate.managedObjectContext];
    
    //设置请求实体
    [request setEntity:entity];
    
    //指定对结果的排序方式 (对data字段进行排序)
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"create_at"ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[self.myDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    self.notes = mutableFetchResult;
    
    NSLog(@"The count of entry:%i",[self.notes count]);
    
    // 遍历所有取得的数据
    for (Note *note in self.notes) {
        NSLog(@"%@",note);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellOfNotes";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    Note *aNote = _notes[indexPath.row];
    cell.title.text = aNote.content;
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:aNote.create_at];
    cell.date.text = currentDateStr;
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedNote = _notes[indexPath.row];
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteNote:[_notes objectAtIndex:[indexPath row]]];
        [_notes removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.navigationItem.title = [NSString stringWithFormat:@"备忘录(%d)",[self.notes count]];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)deleteNote:(Note *)aNote
{
    [self.myDelegate.managedObjectContext deleteObject:aNote];
    
    NSError *error;
    if (![self.myDelegate.managedObjectContext save:&error]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"openNote"]) {
        TextViewController * viewController = (TextViewController *)segue.destinationViewController;
        viewController.aNote = _selectedNote;
    }
}


@end
