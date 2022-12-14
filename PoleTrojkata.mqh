//+------------------------------------------------------------------+
//|                                                 PoleTrojkata.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "ZarzadzaniePozycjami.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PoleTrojkata
  {
private:             
                     int magicNumber;
                     double czasOdOtwarciaOstatnijePozycji(int typ){
                     ZarzadzaniePozycjami* manag = new ZarzadzaniePozycjami(magicNumber);
                     manag.zaznaczNajlepszaPozycjeDanegoTypu(typ);
                     
                     if (CheckPointer(GetPointer (manag))!=POINTER_INVALID)
                           delete (GetPointer(manag)); 
                     return ((TimeCurrent()-OrderOpenTime())/60);
                     
                     }
 
          
                     
                     
                     
                     
public:
                     PoleTrojkata();
                    ~PoleTrojkata();
                     PoleTrojkata(int typOstatniejPozycji,int magicNumber){
                     
                     this.magicNumber=magicNumber;
                     }
                    
                    
                     double poleTrojkata( int typ){
                     ZarzadzaniePozycjami* manag = new ZarzadzaniePozycjami(magicNumber);
                     manag.zaznaczNajlepszaPozycjeDanegoTypu(typ);
                     double wysokosc=(Ask-OrderOpenPrice())/Point;
                     double poziomOtwarcianajlepszejPozycji;
                     double pole=(wysokosc*czasOdOtwarciaOstatnijePozycji(typ))/2;
                     if(pole<0)
                     pole*=-1;
                     
                     
                     if (CheckPointer(GetPointer (manag))!=POINTER_INVALID)
                           delete (GetPointer(manag)); 
                     
                     return pole;
                     
                     
                     
                     }
                     
                     
                     
                    
                    
                    
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PoleTrojkata::PoleTrojkata()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PoleTrojkata::~PoleTrojkata()
  {
  }
//+------------------------------------------------------------------+
