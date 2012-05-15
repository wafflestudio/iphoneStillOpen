//
//  ViewController.m
//  stillOpen
//
//  Created by Jae Ho Jeon on 3/19/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "ViewController.h"



@implementation ViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self initializeMap];
    [self setAllAnnotations];
    
    [longPress addTarget:self action:@selector(receivedLongPress:)];
    menuView = [[menuViewController alloc] initWithParentViewController:self];
    messageBox = [[messageBoxViewController alloc] initWithParentViewController:self];
    cafeAddBox = [[newCafeAddWindow alloc] initWithParentViewController:self];
    callOutView = [[annotationDetailViewer alloc] init];
    hiddenCallOutView = [[annotationDetailViewer alloc] init];

    
    [self.view addSubview:menuView.view];
    [self.view addSubview:callOutView.view];
    [self.view addSubview:hiddenCallOutView.view];
    [self.view addSubview:messageBox.view];
    [self.view addSubview:cafeAddBox.view];
    
    mapviewGestureRecognizer * tapInterceptor = [[mapviewGestureRecognizer alloc] init];
    tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event){
        [self hideMenuBar];
        
    };
    [mapView addGestureRecognizer:tapInterceptor];
    

}

-(void) hideMenuBar
{
    if ([callOutView isClosed])
        [menuView hideBox];
}


- (void) checkAndAddStore
{
    
    if (plusMenuToggled == YES)
    {
        if (mapView.region.span.latitudeDelta < 0.004) // 지도가 최대로 확대되어 있다면..
        {
            [messageBox setWithMessage:@"추가할 지점을 꾹 눌러주세요"];
            [messageBox showCancelMessage];
            [messageBox showBox];
        }
        
        else
        {
            [messageBox setWithMessage:@"카페를 추가합니다!\n지도를 최대로 확대해 주세요"];
            [messageBox showCancelMessage];
            [messageBox showBox];
        }
    }
    
}



-(void) annotationUpdater:(NSTimer *) timer
{
    storeAnnotation * ann = [timer userInfo];
    callOutView.distanceLabel.text = [self getDistanceFromCurrentLocation:ann];
    ann.subtitle = [self makeSubtitle:ann];
}



-(void) receivedLongPress: (UILongPressGestureRecognizer *) inputPress
{
    if (inputPress.state != UIGestureRecognizerStateBegan || !plusMenuToggled) 
        return;
    
    [callOutView hideBoxFast];
    [mapView deselectAnnotation:currentAnnotation animated:YES];

    if (mapView.region.span.latitudeDelta < 0.004) // 지도가 최대로 확대되어 있다면 가능하게
    {
        plusMenuToggled = NO;
        
        CGPoint pointCoords = [inputPress locationInView:mapView];
        CLLocationCoordinate2D mapCoords = [mapView convertPoint:pointCoords toCoordinateFromView:mapView];
        
        if(userAnnotation != nil)
            [mapView removeAnnotation:userAnnotation];
        
        userAnnotation = [[storeAnnotation alloc] init];
        [userAnnotation setIsUserAddedAnnotation:YES];
        
        userAnnotation.coordinate = mapCoords;
        userAnnotation.title = @"새로운 가게";
        userAnnotation.subtitle = @"뭐라도 좀 써줘요";
        
        [mapView addAnnotation:userAnnotation];
        
        [messageBox setWithMessage:@"추가하시려면 파란 버튼을 누르세요"];
        [messageBox hideCancelMessage];
        
        [messageBox showBox];
    }
}








-(void) completeAddingCafe:(storeAnnotation * ) ann
{
    
    [mapView removeAnnotation:userAnnotation];
    [mapView addAnnotation:ann];
    

    [messageBox setWithMessage:@"새로운 카페가 추가되었습니다!"];
    [messageBox showMessageForDuration:3];
}




- (void)mapView:(MKMapView *)mV regionDidChangeAnimated:(BOOL)animated
{
    // if addmenu toggled.. 조건추가 
    if (plusMenuToggled)
        [self checkAndAddStore];
}

- (void)mapView:(MKMapView *)mV didSelectAnnotationView:(MKAnnotationView *)view
{
    
    storeAnnotation * selectedAnn = [mapView.selectedAnnotations objectAtIndex:0];
    
    if ([selectedAnn isUserAddedAnnotation])
    {
        currentAnnotation = selectedAnn;
        return;
    }
    
    
    [menuView hideBox];    //화면이 좁기때문에 메뉴바가 열려있으면 이를 미리 닫는다
    [messageBox cancelMessageBox];  // 이것과 겹치기 때문에 메시지 박스도 닫는다(그냥 닫는게 아니라 cancel 한다)
    currentAnnotation = view.annotation;    //전역변수로 저장해놓아 나중에 처리할 수 있도록..
    
    [self moveMapWithHeight:callOutView.view.frame.size.height]; // 핀이 콜아웃 메시지보다 낮게 있으면 맵을 이동함.. 
    
    if([view.annotation isKindOfClass:[MKUserLocation class]])
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    //  만약 이 어노테이션이 파란 점(유저로케이션) 이라면 추가 버튼을 만들어준다
    
    else
        annotationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(annotationUpdater:) userInfo:currentAnnotation repeats:YES];
        //   걍 폄범한 핀이라면 여기서 업데이트하는 타이머를 켠 후
    
    if ([view.annotation isKindOfClass:[MKUserLocation class]])
    {
        annotationDetailViewer * temp = callOutView;
        callOutView = hiddenCallOutView;
        hiddenCallOutView = temp;
        
        [callOutView setWithAnnotation:currentAnnotation];
        [callOutView showBox];        
    }
    
    else if (![currentAnnotation isUserAddedAnnotation])
    {
        annotationDetailViewer * temp = callOutView;
        callOutView = hiddenCallOutView;
        hiddenCallOutView = temp;
        
        [callOutView setWithAnnotation:currentAnnotation];
        [callOutView showBox];        
    }
}

- (void)mapView:(MKMapView *)mV didDeselectAnnotationView:(MKAnnotationView *)view 
{
    if ([currentAnnotation isUserAddedAnnotation])
    {
        [messageBox cancelMessageBox];
        [cafeAddBox cancelCafeAdd];
        [mapView removeAnnotation:userAnnotation];
        return;
    }
    
    [annotationUpdateTimer invalidate]; // 여기서 타이머를 끈다
    
    if(![currentAnnotation isKindOfClass:[MKUserLocation class]])
        currentAnnotation.subtitle = nil;   //매번 누를때마다 콜아웃 애니메이션 적용되도록 subtitle 지움.. (현재 위치인 파란 dot이 아닐때만)
    
    [callOutView hideBox];
    [menuView hideBox];
}

- (void)mapView:(MKMapView *)mV didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView* view in views)
    {
        if ([view.annotation isKindOfClass:[MKUserLocation class]])
        {
            view.annotation.title = @"현재 위치";
            view.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeContactAdd];
        }  // 현재 위치에는 파란색 '추가' 버튼을 붙인다
        
        else if ([view.annotation isKindOfClass:[storeAnnotation class]] && [((storeAnnotation * )view.annotation) isUserAddedAnnotation])
        {
            view.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeContactAdd];
            [mapView selectAnnotation:userAnnotation animated:NO];
        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    [cafeAddBox setWithAnnotation:view.annotation];
    [cafeAddBox showBox];
    
    [self moveMapWithHeight:cafeAddBox.view.frame.size.height];
    
    [callOutView hideBox];
    [messageBox hideBox];
}

- (MKAnnotationView *) mapView:(MKMapView *) mV viewForAnnotation:(id ) annotation {
    
    if (annotation == mapView.userLocation) // 만약 유저 로케이션이면 (파란 점) 핀을 꼽지 않는다
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
    
    customPinView.canShowCallout = YES; //  콜아웃을 나오도록
    return customPinView;
    
}

-(void) moveMapWithHeight:(int) height
{
    CGPoint newMapCenterPoint = [mapView convertCoordinate:currentAnnotation.coordinate toPointToView:mapView];
    newMapCenterPoint.x = 160;  // 중심은 지금 맵의 x값과 똑같이 - 수직만 이동..
    newMapCenterPoint.y += 230 - (height + 101); // + 는 더 위로 보내고.. - 는 더 밑으로 보낸다..!
    
    // 어노테이션+팝아웃이 한 94픽셀정도 되고.. 7픽셀정도 짬을 만드려면 height + 101의 위치에 어노테이션의 중심이 와야한다..
   // 중심은 230 픽셀 지점에 있음..!
    
    
    CLLocationCoordinate2D newMapCenterCoordinates = [mapView convertPoint:newMapCenterPoint toCoordinateFromView:mapView];
    
    if ([mapView convertCoordinate:currentAnnotation.coordinate toPointToView:mapView].y < height + 101) //만약에 핀이 화면 중심 위로 가있다면.. 
    {        
        MKCoordinateRegion newRegion = [mapView region];
        newRegion.center = newMapCenterCoordinates; //region의 중심을 annotation의 중심 높이로 맞춘 후
        [mapView setRegion:newRegion animated:YES]; //맵을 움직인다.
    }
    
}

-(void) plusMenuOn
{
    plusMenuToggled = YES;
}

-(void) plusMenuOff
{
    plusMenuToggled = NO;
}

-(void) hideCalloutView
{
    [callOutView hideBox];
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
            s.imageURL = [item valueForKey:@"Image"];
            
            //      s.subtitle = [self makeSubtitle:s]; 
            //  처음에 subtitle값을 주지 않음으로써 콜아웃이 커지는 애니메이션 효과..
            
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
    
    return resultString;
    
    //return [NSString stringWithFormat:@"%@, %d미터", resultString, distance];
}

-(NSString * ) getDistanceFromCurrentLocation:(storeAnnotation *) annotation
{
    MKUserLocation * currentLoc = mapView.userLocation;
    CLLocationCoordinate2D currentCoord = currentLoc.location.coordinate;
    
    CLLocation * userLoc = [[CLLocation alloc] initWithLatitude:currentCoord.latitude 
                                                      longitude:currentCoord.longitude];
    
    CLLocation * shopLoc = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude 
                                                      longitude:annotation.coordinate.longitude];
    
    int distance = [userLoc distanceFromLocation:shopLoc];
    int doboMin = (distance / 60) + 1;
    
    return [NSString stringWithFormat:@"현위치에서 %d미터\n도보 %d분거리", distance, doboMin];
    
}

-(NSString * ) minToHuman:(NSInteger) inputMin
{
    NSInteger hour = inputMin / 60;
    NSInteger min = inputMin % 60;
    NSString * result;
    
    
    if (hour == 0)
        result = [NSString stringWithFormat:@"%d분 남음", min];
    else if (min == 0)
        result = [NSString stringWithFormat:@"%d시간 남음", hour];
    else
        result = [NSString stringWithFormat:@"%d시간 %d분 남음", hour, min];
    
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
    plusMenuToggled = NO;
    MKCoordinateRegion region;
    region.center.latitude = 37.4788;
    region.center.longitude = 126.9523;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.005;    
    mapView.region = region;
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
