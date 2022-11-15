//+------------------------------------------------------------------+
//|                                                          Mmd.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


#include "ElektroParowoz.mq4" 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Mmd
  {
private:

public:
                     Mmd();
                    ~Mmd();
                    
                    // zwraca 0 w trendzie wzrostowym, 1 w spadkowym i -1 gdy nei ma trendu 
           double    trend(){
                     double niebieska1,niebieska2,zielona1,zielona2,pomaranczowa1, pomaranczowa2;

                     zielona1= iMA(Symbol(),0,1440,0,MODE_SMA,PRICE_CLOSE,0);
                     zielona2 = iMA(Symbol(),0,1440,0,MODE_EMA,PRICE_CLOSE,0);
                     
                     if (getGrajZPom()==true){
                     if (zielona1==0 ||zielona2==0 )
                     return (-1);
                     else if (nizszaPomaranczowa()>wyzszaNiebieska()+getPomOdNieb()*Point && nizszaNiebieska()>wyzszaZielona()     )
                     return (0);
                     else if (wyzszaPomaranczowa()<nizszaNiebieska()-getPomOdNieb()*Point && wyzszaNiebieska()<nizszaZielona()    )
                     return (1);
                     else return (-1);
                     }
                     
                     else {
                     if (zielona1==0 ||zielona2==0 )
                     return (-1);
                     else if ( nizszaNiebieska()>wyzszaZielona()     )
                     return (0);
                     else if ( wyzszaNiebieska()<nizszaZielona()    )
                     return (1);
                     else return (-1);
                     
                     }
           
                     }
                    
           double    wyzszaNiebieska(){
                     double niebieska1,niebieska2;
                     niebieska1 = iMA(Symbol(),0,288,0,MODE_SMA,PRICE_CLOSE,0);
                     niebieska2 = iMA(Symbol(),0,288,0,MODE_EMA,PRICE_CLOSE,0);
                     
                     if(niebieska1>niebieska2)
                     return NormalizeDouble(niebieska1,5);
                     else return NormalizeDouble(niebieska2,5);
                     
                     }         
           
           double    nizszaNiebieska(){
                     double niebieska1,niebieska2;
                     niebieska1 = iMA(Symbol(),0,288,0,MODE_SMA,PRICE_CLOSE,0);
                     niebieska2 = iMA(Symbol(),0,288,0,MODE_EMA,PRICE_CLOSE,0);
                     
                     if(niebieska1<niebieska2)
                     return NormalizeDouble(niebieska1,5);
                     else return NormalizeDouble(niebieska2,5);
                     
           
                     }
 
 
 
           double    wyzszaZielona(){
                     double zielona1,zielona2;
                     zielona1= iMA(Symbol(),0,1440,0,MODE_SMA,PRICE_CLOSE,0);
                     zielona2 = iMA(Symbol(),0,1440,0,MODE_EMA,PRICE_CLOSE,0);
                     
                     if(zielona1>zielona2)
                     return NormalizeDouble(zielona1,5);
                     else return NormalizeDouble(zielona2,5);
                     
                     }         
           
           double    nizszaZielona(){
                     double zielona1,zielona2;
                     zielona1= iMA(Symbol(),0,1440,0,MODE_SMA,PRICE_CLOSE,0);
                     zielona2 = iMA(Symbol(),0,1440,0,MODE_EMA,PRICE_CLOSE,0);
                     
                     if(zielona1<zielona2)
                     return NormalizeDouble(zielona1,5);
                     else return NormalizeDouble(zielona2,5);
                     
           
                     } 
                     
            double    wyzszaPomaranczowa(){
                     double pomaranczowa1, pomaranczowa2;
                     pomaranczowa1 = iMA(Symbol(),0,48,0,MODE_SMA,PRICE_CLOSE,0);
                     pomaranczowa2 = iMA(Symbol(),0,48,0,MODE_EMA,PRICE_CLOSE,0);
                     
                     if(pomaranczowa1>pomaranczowa2)
                     return NormalizeDouble(pomaranczowa1,5);
                     else return NormalizeDouble(pomaranczowa2,5);
                     
                     }         
           
           double    nizszaPomaranczowa(){
                     double pomaranczowa1, pomaranczowa2;
                     pomaranczowa1 = iMA(Symbol(),0,48,0,MODE_SMA,PRICE_CLOSE,0);
                     pomaranczowa2 = iMA(Symbol(),0,48,0,MODE_EMA,PRICE_CLOSE,0);
                     
                     if(pomaranczowa1<pomaranczowa2)
                     return NormalizeDouble(pomaranczowa1,5);
                     else return NormalizeDouble(pomaranczowa2,5);
                     
           
                     }                     
                     
 
          int        katNiebieskiej(){
                     double niebieska1 = iMA(Symbol(),0,288,0,MODE_SMA,PRICE_CLOSE,0);
                     double niebieska2 = iMA(Symbol(),0,288,0,MODE_EMA,PRICE_CLOSE,0);
                     double niebieska1stara = iMA(Symbol(),0,288,0,MODE_SMA,PRICE_CLOSE,ILOSC_SWIECZEK_DO_KATA);
                     double niebieska2stara = iMA(Symbol(),0,288,0,MODE_EMA,PRICE_CLOSE,ILOSC_SWIECZEK_DO_KATA);
                     
                     if ( niebieska1stara<niebieska1 && niebieska2stara<niebieska2   )
                     return 0;
                     if ( niebieska1stara>niebieska1 && niebieska2stara>niebieska2   )
                     return 1;
                     else return -1;
                     
                     }
 
                    
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Mmd::Mmd()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Mmd::~Mmd()
  {
  }
//+------------------------------------------------------------------+
