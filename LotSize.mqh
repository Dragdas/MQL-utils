//+------------------------------------------------------------------+
//|                                                      LotSize.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class LotSize
  {
private:             bool   fix;
                     double fixedLot; 
                     double floatingLot; 

public:
                     
                     LotSize();
                    ~LotSize();
                     LotSize(bool fix,double fixedLot, double floatingLot){
                     this.fix=fix;
                     this.fixedLot=fixedLot;
                     this.floatingLot=floatingLot;
                     }
                     
                     // zaraca wielkość poczatkowych pozycji do otworzenia 
                     double getLotSize(){
                     if (fix==true)
                     return (fixedLot);
                     else if ((AccountBalance()/1000*floatingLot)>0.01)
                     return (AccountBalance()/1000*floatingLot);
                     else return (0.01);
                     
                     }
                     
                     
                     
                     
                     
                     
                    
                    
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LotSize::LotSize()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LotSize::~LotSize()
  {
  }
//+------------------------------------------------------------------+
