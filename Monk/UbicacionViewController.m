//
//  UbicacionViewController.m
//  Monk
//
//  Created by Abner Castro Aguilar on 30/10/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import "UbicacionViewController.h"

@interface UbicacionViewController ()

@property (nonatomic, strong)CLLocationManager *locationManager;

- (void)getDirections;
- (void)tryAndGetDirections;

@end

@implementation UbicacionViewController
{
    CLLocationCoordinate2D monkCoordinate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Location manager configuration
    self.locationManager = [[CLLocationManager alloc] init];
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        [[self locationManager] requestWhenInUseAuthorization];
    
    //Map view configurations
    [[self mapMonk] setDelegate:self];
    
    //Monk coordinates and its pin on map
    monkCoordinate.latitude = 19.41443;
    monkCoordinate.longitude = -99.17723;
    
    MKPointAnnotation *pinMonk = [[MKPointAnnotation alloc] init];
    pinMonk.coordinate = monkCoordinate;
    pinMonk.title = @"MonK";
    [[self mapMonk] addAnnotation:pinMonk];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    //Map region
    MKCoordinateSpan span = MKCoordinateSpanMake(self.mapMonk.region.span.latitudeDelta + 0.02, self.mapMonk.region.span.longitudeDelta + 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapMonk.userLocation.coordinate, span);
    [[self mapMonk] setRegion:region];
    
    [self tryAndGetDirections];
}

#pragma mark MapView Delegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline *route = overlay;
        MKPolylineRenderer *polyline = [[MKPolylineRenderer alloc] initWithPolyline:route];
        polyline.lineWidth = 5.0;
        polyline.strokeColor = [UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0];
        return polyline;
    }
    else
        return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *pinIdentifier = @"pinId";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    if(annotationView)
        return annotationView;
    else
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
        annotationView.image = [UIImage imageNamed:@"pinMonk.png"];
        annotationView.canShowCallout = YES;
        return annotationView;
    }
}

- (void)getDirections
{
    //Interface customizations
    self.navigationItem.title = @"Obteniendo ruta...";
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2 - 24.0, self.view.frame.size.height / 2 - 24.0, 24.0, 24.0);
    [activityIndicator startAnimating];
    [[self view] addSubview:activityIndicator];
    
    //Get directions stuff
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:monkCoordinate addressDictionary:nil]];
    MKMapItem *currentPosition = [MKMapItem mapItemForCurrentLocation];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setDestination:destination];
    [request setSource:currentPosition];
    [request setRequestsAlternateRoutes:NO];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        //Interface customizations
        self.navigationItem.title = @"Nuestra Ubicación";
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        if(!error)
        {
            //Add route to the map
            [[self mapMonk] addOverlay:[(MKRoute *)[response.routes firstObject] polyline]];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ruta no encontrada" message:@"Hubo un inconveniente al encontrar la ruta. Inténtalo más tarde con el botón actualizar" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [[alert view] setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)tryAndGetDirections
{
    [[self mapMonk] removeOverlays:self.mapMonk.overlays];
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Localización desactivada" message:@"Para mostrarte la ruta a MonK debes activar tu localización" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ajustes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }]];
        [[alert view] setTintColor:[UIColor colorWithRed:0.737 green:0.635 blue:0.506 alpha:1.0]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self getDirections];
    }
}

- (IBAction)updateRoute:(UIBarButtonItem *)sender
{
    [self tryAndGetDirections];
}

@end



























































