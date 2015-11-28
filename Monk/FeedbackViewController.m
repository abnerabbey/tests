//
//  FeedbackViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 06/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "FeedbackViewController.h"
#import <Parse/Parse.h>

@interface FeedbackViewController ()

@property (nonatomic, strong)NSArray *arrayHeaders;
@property (nonatomic, strong)NSArray *arrayServicio;
@property (nonatomic, strong)NSArray *arrayComida;
@property (nonatomic, strong)NSArray *arrayLugar;

@end

@implementation FeedbackViewController
{
    UIBarButtonItem *doneButton;
    
    BOOL rowChecked;
    int rowCount;
    
    NSString *monkURL;
    
    dispatch_queue_t urlQ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrayHeaders = @[@"Por favor marca lo que consideres que debemos mejorar\n\nServicio", @"Comida", @"El lugar"];
    self.arrayServicio = @[@"Trato del personal", @"Rapidez", @"Conocimiento del menú"];
    self.arrayComida = @[@"La comida", @"Sabor de las bebidas", @"Valor nutricional-salud",  @"Originalidad", @"Precios"];
    self.arrayLugar = @[@"Ambientación", @"Orden y limpieza", @"Comodidad", @"Música"];
    
    self.tableViewFeed.delegate = self;
    self.tableViewFeed.dataSource = self;
    
    self.servicioArrayFeed = [[NSMutableArray alloc] init];
    self.comidaArrayFeed = [[NSMutableArray alloc] init];
    self.lugarArrayFeed = [[NSMutableArray alloc] init];
    
    rowChecked = NO;
    rowCount = 0;
    
    monkURL = @"https://monkapp.herokuapp.com";
    
    urlQ = dispatch_queue_create("urls", NULL);
    
    
    //Interface customization
    self.navigationItem.title = @"Tu Feedback";
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo" style:UIBarButtonItemStyleDone target:self action:@selector(moreOptions)];
    [doneButton setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [doneButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = doneButton;
}

#pragma mark TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self arrayHeaders] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
            return self.arrayServicio.count;
            break;
        case 1:
            return self.arrayComida.count;
            break;
        case 2:
            return self.arrayLugar.count;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    
    switch(indexPath.section)
    {
        case 0:
            cell.textLabel.text = [self.arrayServicio objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [self.arrayComida objectAtIndex:indexPath.row];
            break;
        case 2:
            cell.textLabel.text = [self.arrayLugar objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[tableView cellForRowAtIndexPath:indexPath] accessoryType] == UITableViewCellAccessoryNone){
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        rowCount++;
        if(rowCount > 0)
            [doneButton setEnabled:YES];
        rowChecked = YES;
    }
    else{
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
        rowCount--;
        if(rowCount == 0)
            [doneButton setEnabled:NO];
        rowChecked = NO;
    }
    [self addFeedbackToDictionaries:indexPath withRowSelected:rowChecked];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Other Methods
- (void)moreOptions
{
    UIAlertController *doneAlert = [UIAlertController alertControllerWithTitle:@"Casi Listo" message:@"Añade un comentario si así lo prefieres" preferredStyle:UIAlertControllerStyleActionSheet];
    [doneAlert addAction:[UIAlertAction actionWithTitle:@"Listo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self okView];
    }]];
    [doneAlert addAction:[UIAlertAction actionWithTitle:@"Comentar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addComment];
    }]];
    [doneAlert addAction: [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil]];
    [doneAlert.view setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [self presentViewController:doneAlert animated:YES completion:nil];
}

- (void)okView
{
    [self createFeedBackToUpload];
    [self showAbonoAlert];
}

- (void)showAbonoAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¡Gracias por tu Feedback!" message:@"Es importante para nosotros poder mejorar." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [[alert view] setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addFeedbackToDictionaries:(NSIndexPath *)indexPath withRowSelected:(BOOL)checked
{
    if(checked)
    {
        switch(indexPath.section)
        {
            case 0:
                [self.servicioArrayFeed addObject:[self.arrayServicio objectAtIndex:indexPath.row]];
                break;
            case 1:
                [self.comidaArrayFeed addObject:[self.arrayComida objectAtIndex:indexPath.row]];
                break;
            case 2:
                [self.lugarArrayFeed addObject:[self.arrayLugar objectAtIndex:indexPath.row]];
                break;
            default:
                break;
        }
    }
    else
    {
        switch(indexPath.section)
        {
            case 0:
                [self.servicioArrayFeed removeObjectIdenticalTo:[self.arrayServicio objectAtIndex:indexPath.row]];
                break;
            case 1:
                [self.comidaArrayFeed removeObjectIdenticalTo:[self.arrayComida objectAtIndex:indexPath.row]];
                break;
            case 2:
                [self.lugarArrayFeed removeObjectIdenticalTo:[self.arrayLugar objectAtIndex:indexPath.row]];
                break;
            default:
                break;
        }
    }
}

- (void)createFeedBackToUpload
{
    NSLog(@"array: %@", self.servicioArrayFeed);
    for (int i = 0; i < self.servicioArrayFeed.count; i++) {
        NSString *strFeed = [NSString stringWithFormat:@"&calificacions[pregunta]=servicio&calificacions[estrellas]=%d&calificacions[secciones]=%@", self.numberOfStars, self.servicioArrayFeed[i]];
        [self postToServer:strFeed];
    }
    for(int i = 0; i < self.comidaArrayFeed.count; i++){
        NSString *strFeed = [NSString stringWithFormat:@"&calificacions[pregunta]=comida&calificacions[estrellas]=%dcalificacions[secciones]=%@", self.numberOfStars, [self.comidaArrayFeed objectAtIndex:i]];
        [self postToServer:strFeed];
    }
    for(int i = 0; i < self.lugarArrayFeed.count; i++){
        NSString *strFeed = [NSString stringWithFormat:@"&calificacions[pregunta]=lugar&calificacions[estrellas]=%dcalificacions[secciones]=%@", self.numberOfStars, [self.lugarArrayFeed objectAtIndex:i]];
        [self postToServer:strFeed];
    }
    /*NSDictionary *dicServicio = @{@"preguntum_id":@"0",@"secciones":self.servicioArrayFeed,@"estrellas":[NSString stringWithFormat:@"%d", self.numberOfStars]};
    NSDictionary *dicComida = @{@"preguntum_id":@"1",@"secciones":self.comidaArrayFeed,@"estrellas":[NSString stringWithFormat:@"%d",self.numberOfStars]};
    NSDictionary *dicLugar = @{@"preguntum_id":@"2",@"secciones":self.lugarArrayFeed,@"estrellas":[NSString stringWithFormat:@"%d", self.numberOfStars]};
    NSArray *arrayFeed = [NSArray arrayWithObjects:dicServicio,dicComida,dicLugar,nil];
    
    NSDictionary *dicFeed = [NSDictionary dictionaryWithObject:arrayFeed forKey:@"calificacions"];
    PFUser *user = [PFUser currentUser];
    NSURL *URLFeed = [NSURL URLWithString:[NSString stringWithFormat:@"%@/feedback?objectId=%@", monkURL, user.objectId]];
    [self postJSONToServer:dicFeed withURL:URLFeed];*/
}

- (void)postToServer:(NSString *)str
{
    NSLog(@"Entra");
    PFUser *user = [PFUser currentUser];
    NSString *monkappURL = [NSString stringWithFormat:@"http://monkapp.herokuapp.com/feedback?objectId=%@", user.objectId];
    NSString *strLog = [NSString stringWithFormat:@"%@%@", monkappURL, str];
    NSLog(@"strLog: %@", strLog);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", monkappURL, str]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"response: %@", response);
        }
    }];
    [task resume];
    
}

- (void)addComment
{
    ComentViewController *commentView = [[self storyboard] instantiateViewControllerWithIdentifier:@"commentView"];
    commentView.delegate = self;
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:commentView];
    [self presentViewController:nv animated:YES completion:nil];
}

#pragma mark CommentView Delegate
- (void)didComment:(NSString *)comment
{
    [self showAbonoAlert];
}

@end


































































