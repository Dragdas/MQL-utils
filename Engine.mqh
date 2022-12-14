//+------------------------------------------------------------------+
//|                                                       Engine.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


#include "LotSize.mqh"
#include "CzytajZZ.mqh"
#include "PoleTrojkata.mqh"
#include "ZarzadzaniePozycjami.mqh"
#include "Mmd.mqh"
#include <stdlib.mqh>
#include "MechanizmParkowy.mqh"
#include "ElektroParowoz.mq4" 
#include "Hedge.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//---      zmienne sterowniki
         double     najlepszyWierzcholek=0,poziomSLzlotego; // poziom najwyszego/ najnizszego wierzcholka po otwarciu i wyłuskaniu złotej pozycji
         double     najwiekszaStrata;
  bool uciekajNaBe = false;
  bool moznaZamykac=false;// przeciwko polotkom 
  int czekaj=-1;
  int poprzedniaPozycja=2;
  
class Engine
  {      
  
private:          //---zmienne globalne
                   
         

         
         
         //---       funkcje prywatne
         void        zerowanie(){
                     najlepszyWierzcholek=0;
                     poziomSLzlotego=0;
                     uciekajNaBe=false;
                     moznaZamykac=false;
                     
                     
                     }
                     // otwiera pierwsza pozycje jezeli jest taka potrzeba
         void        otwarciePierwszejPozycji(){
                     Mmd* mmd= new Mmd();
                     ZarzadzaniePozycjami* manager =new ZarzadzaniePozycjami(magicNumber);
                     if(getGrajJednostronnie()==true && manager.iloscPozycji(-1)==0)
                     kierunekRozegrania=mmd.trend();
                     
                     LotSize* lotObj=new LotSize(fixedLot,fixedLotSize,lotPer1k);
                     CzytajZZ* zzObj=new CzytajZZ(periodNadrzedny);
                     
                     if( ( poprzedniaPozycja==0 && zzObj.nowyWierzcholek()==1) || ( poprzedniaPozycja==1 && zzObj.nowyWierzcholek()==0) ){
                     //Print("zmieniam czekaj");
                     czekaj=-1;
                     
                     }
                     
                     if(manager.iloscPozycji(-1)==0 && mmd.trend()!=(-1) && GRAJ_DALEJ==true && czekaj==-1){
                     
                     //otwieranie longa
                     
                     // otwieranie longa
                     //Print ("Trend: ",mmd.trend()," ramie ",zzObj.nowyWierzcholek());
                     if ( zzObj.nowyWierzcholek()==0 && mmd.trend()==0 && kierunekRozegrania==0 && mmd.katNiebieskiej()!=1 ){
                     zerowanie();
                     if(  OrderSend(Symbol(),0,lotObj.getLotSize(),Ask,20,0,0,NULL,magicNumber,0,clrBlue) <0  ){
                     int error = GetLastError();
                     Print("Błąd przy probie otwarcia pierwszej pozycji long error #",GetLastError()," = ",ErrorDescription(error));
                     } else 
                     kierunekRozegrania=0;
                     poprzedniaPozycja=0;
                     }
                    //otwieranie shorta
                     if (zzObj.nowyWierzcholek()==1 && mmd.trend()==1 && kierunekRozegrania==1 && mmd.katNiebieskiej()!=0){
                     zerowanie();
                     if(  OrderSend(Symbol(),1,lotObj.getLotSize(),Bid,20,0,0,NULL, magicNumber ,0,clrRed )   <0){
                     int error = GetLastError();
                     Print("Błąd przy probie otwarcia pierwszej pozycji short error #",GetLastError()," = ",ErrorDescription(error));
                     }else 
                     kierunekRozegrania=1;
                     poprzedniaPozycja=1;
                     }
                     
       
                     
                     }
                     
                     if (CheckPointer(GetPointer (lotObj))!=POINTER_INVALID)
                           delete (GetPointer(lotObj)); 
                     if (CheckPointer(GetPointer (zzObj))!=POINTER_INVALID)
                           delete (GetPointer(zzObj));
                                                
                     if (CheckPointer(GetPointer (mmd))!=POINTER_INVALID)
                           delete (GetPointer(mmd)); 
                     if (CheckPointer(GetPointer (manager))!=POINTER_INVALID)
                           delete (GetPointer(manager));       
         
                     }
                     
                     // zamyka wszystkie pozycje jezeli wyrysowal sie nowy wierzcholek a wszystkie pozycje sa na plus 
         void        zamknieciePozycjiNaNowymWierzcholku(){
         
                     ZarzadzaniePozycjami* manager = new ZarzadzaniePozycjami(magicNumber);
                     CzytajZZ* zz = new CzytajZZ(periodNadrzedny);
                     
                     if(manager.iloscPozycji(-1)>0 && ( (kierunekRozegrania==1 && zz.nowyWierzcholek()==0) || (kierunekRozegrania==0 && zz.nowyWierzcholek()==1)) ){
                     moznaZamykac=true;
                     //Print("kierunek  ",kierunekRozegrania,"  wierzcholek ",zz.nowyWierzcholek()," ilosc pozycji ",manager.iloscPozycji(-1));
                     }
                     
                     
                     if( ( (kierunekRozegrania==1 && zz.nowyWierzcholek()==1)  || (kierunekRozegrania==0 && zz.nowyWierzcholek()==0 ) )
                            && manager.wartoscWszystkichPozycji()>0  && moznaZamykac==true  ){
                     for ( ;manager.iloscPozycji(-1)>0 ; ){
                     for(int i=OrdersTotal()-1; i>=0; i--){                     
                     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true){
                     if ( OrderMagicNumber()==magicNumber){
                     
                     if ( OrderClose(OrderTicket(),OrderLots(),Bid,500,clrGreen)!=true)
                     Print ("Błąd funkcji order close w czasie zamykania wszytskich pozycji. Błąd: ",GetLastError()," = ", ErrorDescription(GetLastError()));  
                     else{
                      Print("Zamykam pozycje na nowym ramieniu. ");                
                      Print ("Największa strata: ",NormalizeDouble(najwiekszaStrata,2));
                     }
                     
                     }                     
                     
                     }
                     else Print ("Błąd funkcji order Select w czasie zaznaczania wszystkich pozycji do zamkniecia. Błąd: ",
                           GetLastError()," = ",ErrorDescription(GetLastError()));
                     }
                     
                     
                     }
                     
                     }
                     
                     if (CheckPointer(GetPointer (manager))!=POINTER_INVALID)
                           delete (GetPointer(manager));
                     if (CheckPointer(GetPointer (zz))!=POINTER_INVALID)
                           delete (GetPointer(zz));        
         
                     }

                     //otwiera pozycje grid
         void        grid(){
                     ZarzadzaniePozycjami* manager = new ZarzadzaniePozycjami(magicNumber);
                     manager.zaznaczNajlepszaPozycjeDanegoTypu(kierunekRozegrania);
                     double poziomZlotegoTrade=OrderOpenPrice();
                     PoleTrojkata* tr = new PoleTrojkata(kierunekRozegrania,magicNumber);
                     double poleTr=tr.poleTrojkata(kierunekRozegrania);
                     
                     
                    // Print("poziom złotego trade: ",poziomZlotegoTrade);
                     // wariant rozgrywaia longów
                     if ( kierunekRozegrania==0 && Ask<poziomZlotegoTrade-minOdlMiedzyTradami*Point && poleTr>minPoleTrojkata 
                           && manager.iloscPozycji(-1)>0 ){
                     LotSize* lotObj = new LotSize(fixedLot,fixedLotSize,lotPer1k);
                     if ( OrderSend(Symbol(),0,lotObj.getLotSize(),Ask,20,0,0,NULL,magicNumber,0,clrBlue )<0 )
                     Print("Błąd przy probie otwarcia gridu long error #",GetLastError()," = ",ErrorDescription(GetLastError()));
                     
                     if (CheckPointer(GetPointer (lotObj))!=POINTER_INVALID)
                           delete (GetPointer(lotObj)); 
                     }
                     
                     
                     //wariant z shortami
                     if ( kierunekRozegrania==1 && Bid>poziomZlotegoTrade+minOdlMiedzyTradami*Point && poleTr>minPoleTrojkata && 
                           manager.iloscPozycji(-1)>0){
                     LotSize* lotObj = new LotSize(fixedLot,fixedLotSize,lotPer1k);
                     if ( OrderSend(Symbol(),1,lotObj.getLotSize(),Bid,20,0,0,NULL,magicNumber,0,clrRed )<0 )
                     Print("Błąd przy probie otwarcia gridu short error #",GetLastError()," = ",ErrorDescription(GetLastError()));
                     
                     if (CheckPointer(GetPointer (lotObj))!=POINTER_INVALID)
                           delete (GetPointer(lotObj)); 
                     }
                     
                     if (CheckPointer(GetPointer (manager))!=POINTER_INVALID)
                           delete (GetPointer(manager)); 
                     if (CheckPointer(GetPointer (tr))!=POINTER_INVALID)
                           delete (GetPointer(tr));       
                     
                     
                     }
                     
                   
          void        uciekczkaNaBe (){
                     if(FILTR_ANTYFIRANKOWY==true){         
                     ZarzadzaniePozycjami* manager=new ZarzadzaniePozycjami(magicNumber);
                     CzytajZZ* zz = new CzytajZZ(periodNadrzedny);
                     
                     //Print("ilosc pozycji  ",manager.iloscPozycji(-1)," wartosc  ",manager.wartoscWszystkichPozycji());
                     
                     
                     if (manager.iloscPozycji(-1)==1 && manager.wartoscWszystkichPozycji()>0){
                     
                     manager.zaznaczNajlepszaPozycjeDanegoTypu(kierunekRozegrania);
                     
                     if(odlegloscMiedzyPoziomami(Ask,OrderOpenPrice())>ODLEGLOSC_DO_MONITOROWANIA   )   
                     uciekajNaBe=true;
                     }
                     
                     if (uciekajNaBe==true && manager.wartoscWszystkichPozycji()<=WARTOSC_BE && manager.wartoscWszystkichPozycji()>0){
                     
                     czekaj=zz.nowyWierzcholek();
                     for ( ;manager.iloscPozycji(-1)>0 ; ){
                     for(int i=OrdersTotal()-1; i>=0; i--){                     
                     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true){
                     if ( OrderMagicNumber()==magicNumber){
                     if ( OrderClose(OrderTicket(),OrderLots(),Bid,500,clrGreen)!=true)
                     Print ("Błąd funkcji order close w czasie zamykania pozycji z filtra antyfirankowego. Błąd: ",GetLastError()," = ", 
                           ErrorDescription(GetLastError()));  
                     else{
                      Print("Zamykam pozycje z powodu filtra antyfirankowego. ");                
                      
                     }
                     
                     }                     
                     
                     }
                     else Print ("Błąd funkcji order Select w czasie zaznaczania pozycji do zamkniecia w filtrze antyfirankowym. Błąd: ",
                           GetLastError()," = ",ErrorDescription(GetLastError()));
                     }
                     
                     
                     } 
                     
                     
                     }
                     
                     
                     
                     if (CheckPointer(GetPointer (zz))!=POINTER_INVALID)
                           delete (GetPointer(zz)); 
                     
                     if (CheckPointer(GetPointer (manager))!=POINTER_INVALID)
                           delete (GetPointer(manager));
                     }
                     }
                     
                     //próba wycowania si ez pozycji jezeli mamy jeden trej a zmienił sie tren
         void        uciekczka (){
                     ZarzadzaniePozycjami* manager=new ZarzadzaniePozycjami(magicNumber);
                     Mmd* mmd = new Mmd();
                     
                     if (manager.iloscPozycji(-1)==1){
                     manager.zaznaczNajlepszaPozycjeDanegoTypu(kierunekRozegrania);
                     if (OrderType()!=mmd.trend() ){
                     // zmiana tp pozycji z ktorej uciekamy na minimalny zysk
                     //longi 
                     if (OrderType()==0 && Bid>NormalizeDouble(OrderOpenPrice()+15*Point,5)){
                     if(false==OrderClose(OrderTicket(),OrderLots(),Bid,50,clrBlue))
                        Print("Nieudana próba zamkniecia Long z funkcji ucieczka  Błąd: ",GetLastError()," = ",ErrorDescription(GetLastError()));
                     
                     }else if(OrderType()==0 && Bid<OrderOpenPrice() && OrderTakeProfit()!=NormalizeDouble(OrderOpenPrice()+15*Point,5)   ){
                        if (false==OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(OrderOpenPrice()+15*Point,5),0,clrBlack))
                           Print("Nieudana próba zmiany tp w funkcji ucieczka z longa Błąd: ",GetLastError()," = ",ErrorDescription(GetLastError()));
                     }
                     //shorty
                     if (OrderType()==1 && Ask<NormalizeDouble(OrderOpenPrice()-15*Point,5)){
                     if(false==OrderClose(OrderTicket(),OrderLots(),Ask,50,clrBlue))
                        Print("Nieudana próba zamkniecia Long z funkcji ucieczka  Błąd: ",GetLastError()," = ",ErrorDescription(GetLastError()));
                     
                     
                     }else if(OrderType()==1 && Ask>OrderOpenPrice() && OrderTakeProfit()!=NormalizeDouble(OrderOpenPrice()-15*Point,5)   ){
                        if (false==OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(OrderOpenPrice()-15*Point,5),0,clrBlack))
                        Print("Nieudana próba zmiany tp w funkcji ucieczka z shorta Błąd: ",GetLastError()," = ",ErrorDescription(GetLastError()));
                     }
                     }
                     }
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     if (CheckPointer(GetPointer (mmd))!=POINTER_INVALID)
                           delete (GetPointer(mmd)); 
                     if (CheckPointer(GetPointer (manager))!=POINTER_INVALID)
                           delete (GetPointer(manager));       
                     }

         void        zamykanieKoszyka(){
                     ZarzadzaniePozycjami* manag=new ZarzadzaniePozycjami(magicNumber);
                     if (najwiekszaStrata>manag.wartoscWszystkichPozycji())
                     najwiekszaStrata=manag.wartoscWszystkichPozycji();
                     if(manag.wartoscKoszyka(kierunekRozegrania)>0 && manag.iloscPozycji(odwrotnyKierunek(kierunekRozegrania))==0 ){
                     // zamykanie wszystkich pozycji bez zlotej
                     manag.zaznaczNajlepszaPozycjeDanegoTypu(kierunekRozegrania);
                     double ticketZlotejPozycji= OrderTicket();
                     for ( ;manag.iloscPozycji(-1)>1 ; ){
                     
                     for(int i=OrdersTotal()-1; i>=0; i--){                     
                     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true){
                     
                     if ( OrderMagicNumber()==magicNumber && OrderTicket()!=ticketZlotejPozycji){
                     
                     if ( OrderClose(OrderTicket(),OrderLots(),Bid,500,clrGreen)!=true)
                     Print ("Błąd funkcji order close w czasie zamykania wszytskich pozycji koszyka n-1. Błąd: ",
                              GetLastError()," = ",ErrorDescription(GetLastError())); 
                     else{ 
                     Print ("Zamykam pozycje z koszyka n-1");                 
                     Print ("Największa strata: ",NormalizeDouble(najwiekszaStrata,2));
                     // przesuwanie Sl złotej pozycji na BE jezeli zmienił sie trend
                     //longi
                     Mmd* mmd = new Mmd();
                     if (   manag.iloscPozycji(0)==1&& manag.iloscPozycji(1)==0 &&  mmd.trend()!=0 && OrderStopLoss()!= OrderOpenPrice()+15*Point  ){
                     manag.zaznaczNajlepszaPozycjeDanegoTypu(0);
                     if (Bid>OrderOpenPrice()+15*Point ){
                     if (true !=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+15*Point,OrderTakeProfit(),0,clrBlue))
                     Print ("Błąd funkcji order modify w czasie przesuwania Sl złotego trejdu na BE. Błąd: ",GetLastError()," = ",
                              ErrorDescription(GetLastError())); 
                     }
                     }
                     // shorty
                     if (   manag.iloscPozycji(1)==1 && manag.iloscPozycji(0)==0 &&  mmd.trend()!=1        ){
                     manag.zaznaczNajlepszaPozycjeDanegoTypu(1);
                     if (Ask<OrderOpenPrice()-15*Point && OrderStopLoss()!= OrderOpenPrice()-15*Point){
                     if (true !=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-15*Point,OrderTakeProfit(),0,clrBlue))
                     Print ("Błąd funkcji order modify w czasie przesuwania Sl złotego trejdu na BE. Błąd: ",GetLastError()," = ",
                              ErrorDescription(GetLastError())); 
                     }
                     }
                     
                     
                     if (CheckPointer(GetPointer (mmd))!=POINTER_INVALID)
                           delete (GetPointer(mmd)); 
                     
                     }
                     }                     
                     
                     }
                     else Print ("Błąd funkcji order Select w czasie zaznaczania wszystkich pozycji do zamkniecia koszyka n-1. Błąd: ",
                           GetLastError()," = ",ErrorDescription(GetLastError()));
                     
                     }
                     }
                     }
                     
                     
                     if (CheckPointer(GetPointer (manag))!=POINTER_INVALID)
                           delete (GetPointer(manag));
                     
                          
                     
                     }   



      void           przesuwanieSLZlotegoTrade(){
                     ZarzadzaniePozycjami* manager = new ZarzadzaniePozycjami(magicNumber);
                     Mmd* mmd = new Mmd();
                     
                     double poziomOtwarciaZlotego;
                     if ( manager.iloscPozycji(-1)==1 && manager.wartoscWszystkichPozycji()>0   ){
                     
                     // dla złotego longa
                     if (kierunekRozegrania==0){
                     
                     manager.zaznaczNajlepszaPozycjeDanegoTypu(0);
                     poziomOtwarciaZlotego=OrderOpenPrice();
                     
                     if ( odlegloscMiedzyPoziomami(Bid,mmd.wyzszaNiebieska())>getOdlegloscOdNiebieskiej() && mmd.wyzszaNiebieska()>poziomOtwarciaZlotego  ){
                     
                     
                     manager.zaznaczNajlepszaPozycjeDanegoTypu(0);
                     if(OrderStopLoss()!=mmd.wyzszaNiebieska() && OrderType()==0 ){
                     if (true!= OrderModify(OrderTicket(),OrderOpenPrice(),mmd.wyzszaNiebieska(),OrderTakeProfit(),0,clrNONE))
                     Print("Błąd przy próbie modifikacji SL złotego longa. Błąd: ", GetLastError()," = ",ErrorDescription(GetLastError()));
                     
                     }
                     }
                     }
                     //dla złotego shorta
                     if (kierunekRozegrania==1){
                     
                     manager.zaznaczNajlepszaPozycjeDanegoTypu(1);
                     poziomOtwarciaZlotego=OrderOpenPrice();
                     
                     if ( odlegloscMiedzyPoziomami(Ask,mmd.nizszaNiebieska())>getOdlegloscOdNiebieskiej() && mmd.nizszaNiebieska()<poziomOtwarciaZlotego  ){
                     
                     //Print ( odlegloscMiedzyPoziomami(Ask,mmd.nizszaNiebieska())>getOdlegloscOdNiebieskiej() ,"   " , 
                     // mmd.nizszaNiebieska()<poziomOtwarciaZlotego  );
                     manager.zaznaczNajlepszaPozycjeDanegoTypu(1);
                     if(OrderStopLoss()!=mmd.nizszaNiebieska() && OrderType()==1 ){
                     if (true!= OrderModify(OrderTicket(),OrderOpenPrice(),mmd.nizszaNiebieska(),OrderTakeProfit(),0,clrNONE))
                     Print("Błąd przy próbie modifikacji SL złotego shorta. Błąd: ", GetLastError()," = ",ErrorDescription(GetLastError()));
                     
                     }
                     }
                     }
                   
                   
                   
                     } 
                     // zamykanie objektów
                     
                     if (CheckPointer(GetPointer ( mmd))!=POINTER_INVALID)
                           delete (GetPointer(mmd));
                     
                     if (CheckPointer(GetPointer ( manager))!=POINTER_INVALID)
                           delete (GetPointer(manager));      
      
                     }
     
     
     
     void            grajZParkami(){
                     MechanizmParkowy* parki= new MechanizmParkowy(magicNumber,kierunekRozegrania);
                     parki.robParki(tablicaPozycjiDlaParek);
                     if (CheckPointer(GetPointer (parki))!=POINTER_INVALID)
                           delete (GetPointer(parki));
                     }                       


     void            przesuwajPierwotnePozycje(){
                     
                     ZarzadzaniePozycjami* manager=new ZarzadzaniePozycjami(magicNumber);
                     MechanizmParkowy* parki=new MechanizmParkowy(magicNumber,kierunekRozegrania);
                     //zerowanie tabeli jezeli nie mamy pozycji
                     if (manager.iloscPozycji(-1)<=1)
                     parki.usunZamkniete(tablicaPozycjiDlaPrzesuwania);
                     
                     if (manager.iloscPozycji(-1)>1)
                     parki.przenosPozycje(tablicaPozycjiDlaPrzesuwania);
                     
                     if (CheckPointer(GetPointer (manager))!=POINTER_INVALID)
                           delete (GetPointer(manager));
                     if (CheckPointer(GetPointer (parki))!=POINTER_INVALID)
                           delete (GetPointer(parki));
                     
                     } 
                     
                     
         void        slNaZielonej(){
         
                     Mmd* mmd=new Mmd();
                     ZarzadzaniePozycjami* manager = new ZarzadzaniePozycjami(magicNumber);
                     if( ( kierunekRozegrania==1 && Ask>mmd.wyzszaZielona()  || kierunekRozegrania==0 && Bid<mmd.nizszaZielona()) &&
                            manager.iloscPozycji(-1)>=2 ) {
                     for ( ;manager.iloscPozycji(-1)>0 ; ){
                     for(int i=OrdersTotal()-1; i>=0; i--){                     
                     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true){
                     if ( OrderMagicNumber()==magicNumber){
                     
                     if ( OrderClose(OrderTicket(),OrderLots(),Bid,500,clrGreen)!=true)
                     Print ("Błąd funkcji order close w czasie zamykania wszytskich pozycji na sl. Błąd: ",GetLastError()," = ", 
                           ErrorDescription(GetLastError()));  
                     else{
                      Print("Zamykam pozycje na SL zielona mmd. ");                
                      Print ("Największa strata: ",NormalizeDouble(najwiekszaStrata,2));
                     }
                     
                     }                     
                     
                     }
                     else Print ("Błąd funkcji order Select w czasie zaznaczania wszystkich pozycji do zamkniecia na SL na zielonej. Błąd: ",
                           GetLastError()," = ",ErrorDescription(GetLastError()));
                     }
                     
                     
                     }
                     
                     }
                     
                     if (CheckPointer(GetPointer (mmd))!=POINTER_INVALID)
                           delete (GetPointer(mmd));
                     if (CheckPointer(GetPointer (manager))!=POINTER_INVALID)
                           delete (GetPointer(manager));      
                             
         
                     }                     
                     
                     bool jestesmyWHedge;
                     
         void        hedge(){
                     ZarzadzaniePozycjami* manager = new ZarzadzaniePozycjami(magicNumber);
                     Mmd* mmd=new Mmd();
                     Hedge* he=new Hedge(magicNumber);
                     
                     //if( ((kierunekRozegrania==0 && mmd.trend()==1) || (kierunekRozegrania==1 && mmd.trend()==0))  && 
                     //manager.wartoscWszystkichPozycji() < AccountBalance()*(getOtworzHedgeNaStracie())*-0.01        )
                     if( kierunekRozegrania!=mmd.trend()   && 
                     manager.wartoscWszystkichPozycji() < AccountBalance()*(getOtworzHedgeNaStracie())*-0.01        )
                     jestesmyWHedge=true;
                     
                     if (jestesmyWHedge==true)
                     jestesmyWHedge=he.rozegrajHedgeIWyzeruj();
                     
                     
                     
                     if (CheckPointer(GetPointer (manager))!=POINTER_INVALID)
                           delete (GetPointer(manager));  
                     
                     if (CheckPointer(GetPointer (mmd))!=POINTER_INVALID)
                           delete (GetPointer(mmd));
                     if (CheckPointer(GetPointer (he))!=POINTER_INVALID)
                           delete (GetPointer(he));
                     }
                     

bool        fixedLot, prowadzeniePozycji,trybOptymalizacji,zamknijNaBE;
double      fixedLotSize,lotPer1k, minPoleTrojkata,wirtualneBE;

int         kierunekRozegrania; //<0- nie rozgrywamy 0- rozgrywamy w gore 1- rozgrywamy w dol
int         tablicaPozycjiDlaParek[200][4];
int         tablicaPozycjiDlaPrzesuwania[200][4];// 0- ticket pozycji 1- rodzxaj pozycji/oznaczenie pierwszej pozycji 2- na jakiej 
                                                //cenie trzeba zamknac 3- na jakiej odnowic
         
int         magicNumber,periodNadrzedny, periodPodrzedny,minOdlMiedzyTradami,rok,miesiac,grajTylko;


public:              // kreatory
                     Engine();
                    ~Engine();
                     Engine(int grajTylko,int magicNumber, bool FIXED_LOT, double FIXED_LOT_SIZE,double LOT_PER_1K,int periodNadrzedny,
                     double minPoleTrojkata, int periodPodrzedny,bool prowadzeniePozycji, int minOdlMiedzyTradami,bool trybOptymalizacji,
                              int rok,int miesiac){
                     fixedLot=FIXED_LOT;
                     fixedLotSize=FIXED_LOT_SIZE;
                     lotPer1k=LOT_PER_1K;
                     this.magicNumber=magicNumber;
                     this.periodNadrzedny=periodNadrzedny;
                     this.periodPodrzedny=periodPodrzedny;
                     this.minPoleTrojkata=minPoleTrojkata;
                     this.prowadzeniePozycji=prowadzeniePozycji;
                     this.minOdlMiedzyTradami=minOdlMiedzyTradami;
                     this.trybOptymalizacji=trybOptymalizacji;
                     this.rok=rok;
                     this.miesiac=miesiac;
                     
                     if(getGrajJednostronnie()==false)
                     this.kierunekRozegrania=grajTylko;
                     else this.kierunekRozegrania=-1;
                     
                     }
                     
                     void log(){
                     
                     ZarzadzaniePozycjami* manager = new ZarzadzaniePozycjami(magicNumber);
                     CzytajZZ*zzObj=new CzytajZZ(periodNadrzedny,periodPodrzedny);
                     Mmd* mmd=new Mmd();
                     if (najwiekszaStrata>manager.wartoscWszystkichPozycji())
                     najwiekszaStrata=manager.wartoscWszystkichPozycji();
                     manager.zaznaczNajlepszaPozycjeDanegoTypu(0);
                     if (grajTylko==0){
                     Comment( " Balance: ",NormalizeDouble(AccountBalance(),2)," Equity: ",NormalizeDouble(AccountEquity(),2),   " \n"+          
                              " wartosc wszystkich pozycji obiektu  ", NormalizeDouble(manager.wartoscWszystkichPozycji(),2)  ,"wirtualne BE ON: ",
                                       zamknijNaBE,"\n"+
                              "ZZ: ",zzObj.nowyWierzcholek()," mmd trend  ", mmd.trend(),"  kierunek rozegrania  " , kierunekRozegrania,"   \n"+
                              "    \n"+
                              "    \n"
                     
                     
                              );
                              
                     }
                     if (CheckPointer(GetPointer ( mmd))!=POINTER_INVALID)
                           delete (GetPointer(mmd));  
                     if (CheckPointer(GetPointer ( zzObj))!=POINTER_INVALID)
                           delete (GetPointer(zzObj));        
                     if (CheckPointer(GetPointer ( manager))!=POINTER_INVALID)
                           delete (GetPointer(manager));      
                              
                              
                     }
                     
                     void realizacjaStrategii(){
                     
                     if (jestesmyWHedge==false){   
                     // otwieranie pierwszej pozycji 
                     if (Year()<=rok && trybOptymalizacji==true){
                     if (Year() == rok && Month()<miesiac){
                     otwarciePierwszejPozycji();
                     }
                     else if (Year()<rok)
                     otwarciePierwszejPozycji();
                     }
                     else if (trybOptymalizacji==false) 
                     otwarciePierwszejPozycji();
                     
                     //jezeli trend sie zmienil gdy mamy jedna pozycje to probujemy z niej uciec
                     uciekczka();
                     
                     // ucieczka jezeli nie trafilismy 
                     uciekczkaNaBe();
                     
                     
                     // otwieranie kolejnych pozycji (grid)
                     grid();
                     
                     
                     
                     
                     //zamykanie koszyka n-1
                     zamykanieKoszyka();
                     
                     
                     //prowadzenie pozycji (przesuwa SL na złotym trade)
                     if (prowadzeniePozycji==true )
                     przesuwanieSLZlotegoTrade();
                     
                     
                     
                     //przesuwanie pozycji w lepsze miejsce
                     if(true== getPrzesuwajPierwotnePozycje() )
                     przesuwajPierwotnePozycje();
                     
                     
                     
                     // sl na zielonej
                     if(getSlNaZielonej()==true )
                     slNaZielonej();
                     

                
                     //zamykanie wszystkiego jezeli wyrysował sie przeciwny wierzcholek i jestesmy na plus 
                     zamknieciePozycjiNaNowymWierzcholku();
                     
                     
                     //moduł parkowy
                     if (getMechanizmParkowy()==true)
                     grajZParkami();
                     
 
                     }
 
 
                     //hedge xD xD xD
                     if (getGrajZHedge()==true)
                     hedge();                     
                     
                     }
                    
                    
                    
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Engine::Engine()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Engine::~Engine()
  {
  }
//+------------------------------------------------------------------+

int odwrotnyKierunek(int kierunek){
if(kierunek==0)
return 1;
if (kierunek==1)
return 0;
else return -1;
}



int odlegloscMiedzyPoziomami(double poziom1, double poziom2){

double wynik=(poziom1-poziom2)/Point;

if (wynik>=0)
return wynik;
else return wynik*(-1);

}