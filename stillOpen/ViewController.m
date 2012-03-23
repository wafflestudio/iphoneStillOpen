//
//  ViewController.m
//  stillOpen
//
//  Created by Jae Ho Jeon on 3/19/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "ViewController.h"
#import "storeAnnotation.h"


@implementation ViewController
@synthesize mapView;
@synthesize helpBar;
@synthesize timeButton;
@synthesize doneButton;
@synthesize longPress;
@synthesize userAnnotation;
@synthesize helpLabel;
@synthesize annotationCallOut;



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [timeButton addTarget:self action:@selector(openClock) forControlEvents:UIControlEventTouchDown];
    [doneButton addTarget:self action:@selector(closeClock) forControlEvents:UIControlEventTouchDown];
    [longPress addTarget:self action:@selector(receivedLongPress:)];
    
    
    [self initializeMap];
    [self setAllAnnotations];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
}

- (void)mapView:(MKMapView *)funcMapView didSelectAnnotationView:(MKAnnotationView *)view
{ 
    storeAnnotation * thisAnn = view.annotation;

    if(view.annotation != funcMapView.userLocation)
    {
        annotationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                             target:self
                                                           selector:@selector(annotationUpdater:)    
                                                           userInfo:thisAnn
                                                            repeats:YES];
    }

     // 여기서 업데이트하는 타이머를 켠 후
}


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view 
{
    [annotationUpdateTimer invalidate];    // 여기서 타이머를 끈다
}

-(void) annotationUpdater:(NSTimer *) timer
{
    storeAnnotation * ann = [timer userInfo];
    ann.subtitle = [self makeSubtitle:ann];
}


-(void) setAllAnnotations
{
    NSError *error = nil;
    NSString *mintEngine = @"http://mintengine.com:3000/stores.json";
    NSURL *url = [NSURL URLWithString:mintEngine];
    NSData *json = [NSData dataWithContentsOfURL:url];
    
    if (json != nil)
    {
        
        NSArray *jsonArray= [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:&error];
        
        for (NSDictionary *item in jsonArray)
        {
            storeAnnotation * s = [[storeAnnotation alloc] init];
            
            CLLocationCoordinate2D coord;
            coord.latitude = [[item valueForKey:@"Latitude"] doubleValue];
            coord.longitude = [[item valueForKey:@"Longitude"] doubleValue];
            
            s.coordinate = coord;
            s.title = [item valueForKey:@"Name"];
            s.Opentime = [[item valueForKey:@"Opentime"] intValue];
            s.Closetime = [[item valueForKey:@"Closetime"] intValue];
            s.subtitle = [self makeSubtitle:s];
            
            
            [mapView addAnnotation:s];        
        }
    }
    
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"정보를 가져오지 못했습니다"
                                                        message:@"인터넷이 연결되어 있는지 확인해 주세요"
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil]; 
        [alert show];
    }
   
}





-(void) receivedLongPress: (UILongPressGestureRecognizer *) inputPress
{
    if (mapView.region.span.latitudeDelta < 0.004) // 지도가 최대로 확대되어 있다면 가능하게
    {
    int delay = 3;
    helpLabel.text = @"해당 지점을 추가하시려면 이 곳을 누르세요";
    
    [helpBar setHidden:NO];
    [self.view addSubview:helpBar];
    [self performSelector:@selector(makeInvisible:) withObject:helpBar afterDelay:delay];
    
    CGPoint pointCoords = [inputPress locationInView:mapView];
    CLLocationCoordinate2D mapCoords = [mapView convertPoint:pointCoords toCoordinateFromView:mapView];
    
    
    
    if(userAnnotation != nil)
        [mapView removeAnnotation:userAnnotation];
    
    userAnnotation = [[storeAnnotation alloc] init];
    
    userAnnotation.coordinate = mapCoords;
    userAnnotation.title = @"새로운 가게";
    userAnnotation.subtitle = @"뭐라도 좀 써줘요";
    
    [mapView addAnnotation:userAnnotation];
    }
    else
    {
        int delay = 3;
        helpLabel.text = @"지도를 최대로 확대한 경우에만 상점을 추가할 수 있습니다.";
        
        [helpBar setHidden:NO];
        [self.view addSubview:helpBar];
        [self performSelector:@selector(makeInvisible:) withObject:helpBar afterDelay:delay];

    }
}



- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation:(id ) annotation {
    
    if (annotation == self.mapView.userLocation) // 만약 유저 로케이션이면 (파란 점) 핀을 꼽지 않는다
        return nil;
    
    MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    
    if ([self checkOpenClosed:annotation] == 0)   // 24시간 오픈이면 보라색
        customPinView.pinColor = MKPinAnnotationColorPurple;
    else if ([self checkOpenClosed:annotation] == 1)    //  지금 열려있으면 초록색
        customPinView.pinColor = MKPinAnnotationColorGreen;
    else if ([self checkOpenClosed:annotation] == 2)    //  가게가 닫기 한시간 이내이면 오렌지색
    {
        UIImage * image = [UIImage imageNamed:@"orangePin.png"];
        [customPinView setImage:image];
    }
    
    //  그것도 아닌 경우 - 가게가 현재 닫혀있는 경우에는 스타일을 먹이지 않는다 (그냥 빨간색으로 둔다)
    
    
//    customPinView.animatesDrop = YES; // 떨어지는 모션을 주고
    customPinView.canShowCallout = YES; //  펼쳐지는 화면에 버튼을 단다
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];  //  버튼 타입은 그 꺽쇠 파란버튼
    customPinView.rightCalloutAccessoryView = infoButton;   //붙이기
    
    return customPinView;
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    storeAnnotation * ann = view.annotation;
    
    int delay = 3;
    [helpLabel setText:[ann title]];
    
    [helpBar setHidden:NO];
    [self.view addSubview:helpBar];
    [self performSelector:@selector(makeInvisible:) withObject:helpBar afterDelay:delay];
    

    
    NSLog(@"%@", ann.title);
    NSLog(@"%f", self.mapView.region.span.latitudeDelta);
    NSLog(@"%f", self.mapView.region.span.longitudeDelta);


   
}
























-(NSString *) makeSubtitle:(storeAnnotation *) annotation
{
    int openTime = annotation.Opentime;
    int closeTime = annotation.Closetime;
    
    int curTime = [self timeGetter];
    NSString * resultString = @"";
    
    if (openTime == closeTime)
        resultString = @"24시간 영업";
    
    else if(openTime < closeTime)                  //정상인 경우 -> 하루 안에 다 시작하고 끝날 경우            
    {
        if(openTime < curTime && curTime < closeTime) // 영업시간 내인 경우
            resultString = [self minToHuman:(closeTime - curTime)];
        else if (closeTime < curTime && curTime < 1440) //영업시간이 아니고 24시 이전
            resultString = [NSString stringWithFormat:@"오픈까지 %@", [self minToHuman:(1440 - curTime + openTime)]];
        else                                            //영업시간이 아니고 24시 이후
            resultString = [NSString stringWithFormat:@"오픈까지 %@", [self minToHuman:(openTime - curTime)]];
    }
    
    else        //시작과 끝이 다른 날짜에 있는 경우 - 오늘 시작해 내일 끝나는 경우
    {
        if(openTime < curTime && curTime < 1440) // 영업시간 내, 24시 이전
            resultString = [self minToHuman:(1440 - curTime + closeTime)];
        else if (curTime < closeTime)   //영업시간 내, 24시 이후
            resultString = [self minToHuman:(closeTime - curTime)];
        else    //영업시간 아닌경우
            resultString = [NSString stringWithFormat:@"오픈까지 %@", [self minToHuman:(openTime - curTime)]];
    }
    
    // 위에는 남은시간 계산, 아래는 거리 계산
    
    MKUserLocation * currentLoc = self.mapView.userLocation;
    CLLocationCoordinate2D currentCoord = currentLoc.location.coordinate;
    
    CLLocation * userLoc = [[CLLocation alloc] initWithLatitude:currentCoord.latitude 
                                                      longitude:currentCoord.longitude];
    
    CLLocation * shopLoc = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude 
                                                      longitude:annotation.coordinate.longitude];

    int distance = [userLoc distanceFromLocation:shopLoc];
    
    return [NSString stringWithFormat:@"%@, %d미터", resultString, distance];
       
}
-(NSString * ) minToHuman:(NSInteger) inputMin
{
    NSInteger hour = inputMin / 60;
    NSInteger min = inputMin % 60;
    NSString * result;
    
    
    if (hour != 0)
        result = [NSString stringWithFormat:@"%d시간 %d분 남음", hour, min];
    else
        result = [NSString stringWithFormat:@"%d분 남음", min];
    
    return result;
}
-(int) checkOpenClosed:(storeAnnotation *) annotation
{
    int curTime = [self timeGetter];
    int closeTime = annotation.Closetime;
    int openTime = annotation.Opentime;
    
    // 0 24시간 영업점, 1이 열림, -1 이 닫힘.
    
    if (openTime == closeTime) //24시간 영업
        return 0;
    else if (openTime < closeTime) // 하루 안에 시작과 끝이 다 있는 경우
    {
        if (openTime <curTime && curTime < closeTime)
            return 1;
        else
            return -1;
    }
    else // 시작한 후 다음 날 끝나는 경우
    {
        if (openTime < curTime && curTime < 1440) // 영업시간 내, 24시 이전
            return 1;
        else if (curTime < closeTime) // 영업시간 내, 24시 이후
            return 1;
        else //영업시간 아닌경우
            return -1;
    }
}
-(void) makeInvisible:(id) inputObject
{
    [inputObject setHidden:YES];
}
-(void) makeVisible:(id) inputObject
{    
    [inputObject setHidden:NO];
}
-(void) closeClock
{
    [helpBar setHidden:YES];
}
-(void) openClock
{
    int delay = 3;
    [helpBar setHidden:NO];
    annotationCallOut = [[callOutView alloc] init];
    
    [self.view addSubview:annotationCallOut.view];
    [self.view addSubview:helpBar];

    [self performSelector:@selector(makeInvisible:) withObject:helpBar afterDelay:delay];
    
}
-(int) timeGetter
{
    NSDateFormatter *hour = [[NSDateFormatter alloc] init];
    NSDateFormatter *min = [[NSDateFormatter alloc] init];
    [hour setDateFormat:@"HH"];
    [min setDateFormat:@"mm"];
    NSString * hourStr = [hour stringFromDate:[NSDate date]];
    NSString * minStr = [min stringFromDate:[NSDate date]];
    return ([hourStr intValue] * 60 + [minStr intValue]);
}
-(void) initializeMap
{
    gpsUpdatedOnce = NO;
    MKCoordinateRegion region;
    region.center.latitude = 37.4788;
    region.center.longitude = 126.9523;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.005;    
    mapView.region = region;
}
- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setHelpBar:nil];
    [self setTimeButton:nil];
    [self setDoneButton:nil];
    [self setLongPress:nil];
    [self setHelpLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
