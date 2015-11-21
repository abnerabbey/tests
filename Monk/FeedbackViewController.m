//
//  FeedbackViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 06/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "FeedbackViewController.h"

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
    NSURL *URLFeed;
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
    URLFeed = [NSURL URLWithString:[NSString stringWithFormat:@"%@/feedback", monkURL]];
    
    
    //Interface customization
    self.navigationItem.title = @"Tu Feedback";
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo" style:UIBarButtonItemStyleDone target:self action:@selector(okView)];
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
- (void)okView
{
    [self createFeedBackToUpload];
    [self showAbonoAlert];
}

- (void)showAbonoAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¡Gracias por tu Feedback!" message:@"Es importante para nosotros poder mejorar.\nTe hemos abonado $15.00 MXN para tu siguiente compra." preferredStyle:UIAlertControllerStyleAlert];
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
    NSDictionary *dicServicio = @{@"preguntum_id": @"0", @"secciones": self.servicioArrayFeed, @"estrellas": [NSString stringWithFormat:@"%d", self.numberOfStars]};
    NSDictionary *dicComida = @{@"preguntum_id": @"1", @"secciones": self.comidaArrayFeed, @"estrellas": [NSString stringWithFormat:@"%d", self.numberOfStars]};
    NSDictionary *dicLugar = @{@"preguntum_id": @"2", @"secciones": self.lugarArrayFeed, @"estrellas": [NSString stringWithFormat:@"%d", self.numberOfStars]};
    NSArray *arrayFeed = @[dicServicio, dicComida, dicLugar];
    
    NSDictionary *dicFeed = @{@"calificacions": arrayFeed};
    [self postJSONToServer:dicFeed withURL:URLFeed];
}

- (void)postJSONToServer:(NSDictionary *)dictionary withURL:(NSURL *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *sessionPost = [NSURLSession sharedSession];
    [request setHTTPMethod:@"POST"];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    
    NSError *error;
    [request setHTTPBody:jsonData];
    if(!error){
        NSURLSessionDataTask *task = [sessionPost dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(!error){
                NSError *errorJSON;
                NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errorJSON];
                NSLog(@"dictResponse: %@", dictResponse);
            }
        }];
        [task resume];
    }
    
}
@end


































































