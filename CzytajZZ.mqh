//+------------------------------------------------------------------+
//|                                                     CzytajZZ.mqh |
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
class CzytajZZ
  {
private:          int periodDecydujacy;
                  int periodPodrzedny;
public:
                     CzytajZZ();
                    ~CzytajZZ();
                     CzytajZZ(int periodDecydujacy){
                     this.periodDecydujacy=periodDecydujacy;
                     }
                     CzytajZZ(int periodDecydujacy,int periodPodrzedny){
                     this.periodDecydujacy=periodDecydujacy;
                     this.periodPodrzedny=periodPodrzedny;
                     }
                     
                     
                    
                    
                    int nowyWierzcholek(){
                     
                     if (iCustom(NULL,0,"ZigZag",periodDecydujacy,5,3,0,0)==0)
                     return (2);
                     else {
                     double war1,war2;
                     for (int i=0;true;i++){
                     if (iCustom(NULL,0,"ZigZag",periodDecydujacy,5,3,0,i)!=0){
                     
                     war2=war1;
                     war1=iCustom(NULL,0,"ZigZag",periodDecydujacy,5,3,0,i);
                     if(war2!=0){
                     if  (war1>war2)  
                     return (0);
                     
                     else if(war1<war2 )
                     return (1);
                     else return (2);
                     }
                     else if (i>300)
                     return (2);
                     }}}}
                     
                     double aktualnyZZ(){
                                         
                     return ( iCustom(NULL,0,"ZigZag",periodDecydujacy,5,3,1,0)  );
                     }
                     
                     
                     
                     double poziomWierzcholkaPodrzednego(int ktory){
                     int wierzcholek=0;
                     double poziom;
                     double war1,war2,war3;
                     
                     for (int i=0;true;i++){
                     if (iCustom(NULL,0,"ZigZag",periodPodrzedny,5,3,0,i)!=0){
                     if (ktory==0){
                     poziom=iCustom(NULL,0,"ZigZag",periodPodrzedny,5,3,0,i);
                     break;
                     } 
                     
                     
                     
                     war3=war2;
                     war2=war1;
                     war1=iCustom(NULL,0,"ZigZag",periodPodrzedny,5,3,0,i);
                     if(war3!=0){
                     if  ((war3>war2 && war2<war1 ) || (war3<war2 && war2>war1)   )
                     wierzcholek++;
                     
                     if(wierzcholek==ktory ){
                     poziom=war2;
                     break;
                     
                     }
                     
                     }
                     else if (i>400)
                     break;
                     }
                     
                     }
                     return poziom;
                     }
                     
                     
                     
                     
                     
                     
                     
                     
                    
                    
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CzytajZZ::CzytajZZ()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CzytajZZ::~CzytajZZ()
  {
  }
//+------------------------------------------------------------------+
