//
//  UserLocationViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/11.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "UserLocationViewController.h"
#import "LoadingCell.h"


@interface UserLocationViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong)   NSDictionary *cityListDic;
@property (nonatomic, strong)   NSArray *cityListKeys;
@property (nonatomic, strong)   LoadingCell *loadingCell;
//  定位的城市
@property (nonatomic, copy)     NSString *locationCity;

@property (nonatomic, strong)   CLLocationManager *locationManager;

@property (nonatomic, copy)     GetCityNameBlock cityBlcok;

@end

@implementation UserLocationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
        
    }else {
        [self showAlert:@"尚未开启定位服务"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *pathDic = [[NSBundle mainBundle] pathForResource:@"citydict" ofType:@"plist"];
    _cityListDic = [NSDictionary dictionaryWithContentsOfFile:pathDic];
    if (_cityListDic) {
        _cityListKeys = [[_cityListDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }
    
    _loadingCell = [LoadingCell newCell];
    _loadingCell.loading = YES;

}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10.0f;
    }

    return _locationManager;
}

#pragma mark - MapViewDelegate

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [_locationManager stopUpdatingLocation];
    
    __weakSelf;
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *loactionDic = [placemark addressDictionary];
            NSString *city = [loactionDic stringForKey:@"State"];
            NSString *subLocality = [loactionDic stringForKey:@"subLocality"];
            _locationCity = HTSTR(@"%@ %@", city, subLocality);
            
            /*
            NSArray *keys = [loactionDic allKeys];
            for (NSString *KEY in keys) {
                NSLog(@"%@", KEY);
                NSLog(@"%@", [loactionDic stringForKey:KEY]);
            }
            */
        }
        
        if (weakSelf.cityBlcok) {
            weakSelf.cityBlcok(_locationCity);
        }else {
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                
                [self.locationManager requestWhenInUseAuthorization]; 
                [self.locationManager requestAlwaysAuthorization];
                
            }
            break;
        default:
            break;
            
            
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cityListKeys.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 0)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30.0f)];
    label.font = HTFont(14.0f);
    if (section == 0) {
        label.text = @"定位城市";
    }else {
        label.text = [_cityListKeys objectAtIndex:section - 1];
    }
    
    
    view.backgroundColor = [UIColor jt_backgroudColor];
    
    [view addSubview:label];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) return 1;
    
    NSString *key = [_cityListKeys objectAtIndex:section - 1];
    NSArray *objects = [_cityListDic valueForKey:key];
    
    return objects.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _cityListKeys;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (!isEmpty(self.locationCity)) {
            self.loadingCell.textLabel.text = self.locationCity;
            self.loadingCell.loading = NO;
        }else {
            if ([CLLocationManager locationServicesEnabled]) {
                self.loadingCell.textLabel.text = @"定位中...";
                self.loadingCell.loading = YES;
            }else {
                self.loadingCell.textLabel.text = @"尚未开启定位服务";
            }
        }
        
        return self.loadingCell;
    }
    
    static NSString *cityCellIdentifier = @"cityCellIdentifier";
    HTBaseCell *baseCell = [tableView dequeueReusableCellWithIdentifier:cityCellIdentifier];
    
    if (!baseCell) {
        baseCell = [[HTBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cityCellIdentifier];
    }
    
    NSArray *citys = [_cityListDic objectForKey:[_cityListKeys objectAtIndex:indexPath.section - 1]];
    baseCell.textLabel.text = [citys objectAtIndex:indexPath.row];
    
    return baseCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTBaseCell *cell = (HTBaseCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (_userSelectedBlock) {
        _userSelectedBlock(cell.textLabel.text);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getCityNameWithBlock:(GetCityNameBlock)getCityNameBlock
{
    _cityBlcok = getCityNameBlock;
    
    [self.locationManager startUpdatingLocation];
}

- (NSString *)title
{
    return @"选择城市";
}

@end
