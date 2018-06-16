//
//  PersonInfoVC.m
//  AnimalProtect
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 apem. All rights reserved.
//

#import "CLPetOwnerCheckDetailVC.h"
#import "CommTVCellView.h"
#import "APRedBtn.h"
#import "CLPetOwner.h"
#import "CityLevelDataService.h"

@interface CLPetOwnerCheckDetailVC ()

@property (weak, nonatomic) IBOutlet CommTVCellView *phoneV;
@property (weak, nonatomic) IBOutlet CommTVCellView *dogManID;
@property (weak, nonatomic) IBOutlet CommTVCellView *nameV;
@property (weak, nonatomic) IBOutlet CommTVCellView *orgNameV;
@property (weak, nonatomic) IBOutlet CommTVCellView *addressV;
@property (weak, nonatomic) IBOutlet APRedBtn *saveBtn;

@property (nonatomic, strong) CityLevelDataService *dataService;

@end

@implementation CLPetOwnerCheckDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    self.dataService = [[CityLevelDataService alloc] init];
    
    [self setNibWithModel:nil];
    
    [self requestPerson];
}

- (void)setNibWithModel:(CLPetOwner *)person
{
    self.phoneV.text = person.telephone;
    self.dogManID.text = person.ownerNo;
    self.nameV.text = person.name;
    self.orgNameV.text = person.orgName;
    self.addressV.text = person.village;
    self.addressV.text = person.address;
}

- (CLPetOwner *)getPersonFromNib
{
    CLPetOwner *person = [[CLPetOwner alloc] init];
    person.telephone = self.phoneV.text;
    person.ownerNo = self.dogManID.text;
    person.name = self.nameV.text;
    person.orgName = self.orgNameV.text;
    person.address = self.addressV.text;
    return person;
}

#pragma mark - IBAction

- (IBAction)saveBtnDidClick:(APRedBtn *)sender
{
    [self submitSheet];
}

#pragma mark - function

- (void)requestPerson
{
    [self showHUBText:@"正在加载.."];
    [self.dataService requestCheckWithOwnerNo:self.ownerID succ:^(CLPetOwner *owner) {
        [self hiddenHUB];
        [self setNibWithModel:owner];
    } fail:^(NSError *error) {
        [self hiddenHUB];
        [self toast:error.domain];
    }];
}

- (void)submitSheet
{
    CLPetOwner *person = [self getPersonFromNib];
    
    [self showHUBText:@"正在提交.."];
    [self.dataService requestSubmitCheck:person succ:^{
        [self hiddenHUB];
        [self.navigationController popViewControllerAnimated:YES];
        
    } fail:^(NSError *error) {
        [self hiddenHUB];
        [self toast:error.domain];
    }];
}

@end

