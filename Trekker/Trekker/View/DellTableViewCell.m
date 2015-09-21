//
//  DellTableViewCell.m
//  Trekker
//
//  Created by MS on 15-9-20.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "DellTableViewCell.h"

@implementation DellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadDataFromModel:(Deal *)deal
{
    [self.img setImageWithURL:[NSURL URLWithString:deal.imagurl] placeholderImage:[UIImage imageNamed:@"holder.png"] options:SDWebImageRetryFailed];
    self.desc.text = deal.desc;
    self.currentProice.text =[self reversPriceToString:deal andType:1];
    self.markPrice.text = [self reversPriceToString:deal andType:2];
    NSString * tempStr = [self reversPriceToString:deal andType:3];
    self.promotePrice.layer.cornerRadius = 5;
    if ([tempStr length] != 0) {
        self.promotePrice.layer.borderWidth = 1.0;
        self.promotePrice.layer.borderColor = [[UIColor redColor] CGColor];
    }else
    {
        self.promotePrice.layer.borderColor = [[UIColor clearColor] CGColor];
    }
    self.promotePrice.text = tempStr;
    self.saleNum.text = [NSString stringWithFormat:@"已售%@",deal.saleNum];
}

-(NSString *)reversPriceToString:(Deal *)deal andType:(NSInteger)typeId
{
    NSString * str = nil;
    double numLater;
    if (typeId == 1 ) {
       NSInteger num = [[NSString stringWithFormat:@"%@",deal.currentPrice] integerValue];
        numLater = num / 100.0;
        str = [NSString stringWithFormat:@"%.2lf",numLater];
    }else if (typeId == 2)
    {
        NSInteger num = [[NSString stringWithFormat:@"%@",deal.markPrice] integerValue];
        numLater = num / 100.0;
        str = [NSString stringWithFormat:@"%.2lf",numLater];
    }
    else if(typeId == 3)//根据是否立减 返回相应信息
    {
        NSInteger priceCurrent = [[NSString stringWithFormat:@"%@",deal.currentPrice] integerValue];
        NSInteger pricePro = [[NSString stringWithFormat:@"%@",deal.parameterPrice] integerValue];
        if (priceCurrent > pricePro) {
            str = [NSString stringWithFormat:@"立减%.2lf",(priceCurrent - pricePro) / 100.90];
        }else
        {
            str = @"";
        }
    }
    return str;
}

@end
