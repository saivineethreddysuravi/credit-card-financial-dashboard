# Advanced DAX Measure Library

This document outlines the core DAX measures developed for the Enterprise Credit Risk & Portfolio Health Analytics dashboard. These measures are optimized for performance on a 3M+ transaction dataset in Power BI.

## 1. Risk Exposure Metrics

### Total Risk Exposure
Calculates the total transaction volume for accounts identified as 'High Risk' (> 80 score).
```dax
Total Risk Exposure = 
SUMX(
    FILTER(
        'Fact_Transactions',
        RELATED('Dim_Account_Risk'[Risk_Score]) > 80
    ),
    'Fact_Transactions'[Amount])
```

### Risk Exposure WoW % Change
Calculates the Week-over-Week variance in at-risk revenue.
```dax
Risk_Exposure_WoW_Var = 
VAR CurrentWeekRisk = [Total Risk Exposure]
VAR PreviousWeekRisk = CALCULATE([Total Risk Exposure], DATEADD('Dim_Date'[Date], -7, DAY))
RETURN
TF(
    ISBLANK(PreviousWeekRisk),
    0,
    DIVIDE(CurrentWeekRisk - PreviousWeekRisk, PreviousWeekRisk)
)
```J

## 2. PortfolioX[Y]šXÜÂ‚ˆÈÈÈX[HœËˆ]Tš\ÚÈ˜][Â•š\İX[^™\ÈH\˜Ù[YÙHÙˆHÜ›Û[È]\Èİ\œ™[H\™›Ü›Z[™ÈœËˆ[™\‹\\™›Ü›Z[™Ë‚˜^”Ü›Û[×ÒX[Ô˜][ÈH‘U’QJˆÕİ[š\ÚÈ^Üİ\™WKˆĞSÕSUJÕSJ	Ñ˜XİÕ˜[œØXİ[ÛœÉÖĞ[[İ[JKS
	Ñ[WĞXØÛİ[Ôš\ÚÉÊJBŠB˜‚‚ˆÈÈËˆ™]™[YH›Ü™XØ\İ[™È
R[\[Y[][ÛŠB‚ˆÈÈÈ›Ú™XİY[ÛH™]™[YH
“H[İš[™È]™\˜YÙJB˜Ù^”™]™[YWÍ“WÓ[İš[™×Ğ]™ÈHU‘TQÑV
ˆUTÒS”T’SÑ
	Ñ[WÑ]IÖÑ]WKTÕUJ	Ñ[WÑ]IÖÑ]WJKM‹SÓ•
KˆĞSÕSUJÕSJ	Ñ˜XİÕ˜[œØXİ[ÛœÉÖĞ[[İ[JJB˜‚