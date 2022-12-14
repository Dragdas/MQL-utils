//+------------------------------------------------------------------+
//|                                             MechanizmParkowy.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include "ZarzadzaniePozycjami.mqh"
#include <stdlib.mqh>
#include "ElektroParowoz.mq4" 
#include "LotSize.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class MechanizmParkowy
  {
private:              void dopiszNowaPierwszaPozycjeDoTablicy(int& tablicaPozycji[][]){
                           ArraySort(tablicaPozycji,WHOLE_ARRAY,0,MODE_DESCEND);
                           ZarzadzaniePozycjami* manager=new ZarzadzaniePozycjami(magicNumber);
                           if( manager.iloscPozycji(kierunekRozegrania)==1 && (tablicaPozycji[0][0]==0 || tablicaPozycji[0][1]!=-1   )  ){
                           manager.zaznaczNajlepszaPozycjeDanegoTypu(kierunekRozegrania);
                           tablicaPozycji[0][0]=OrderTicket();
                           tablicaPozycji[0][1]=-1;
                           tablicaPozycji[0][2]=0;
                           tablicaPozycji[0][3]=0;
                           }
                           if (CheckPointer(GetPointer ( manager))!=POINTER_INVALID)
                           delete (GetPointer(manager));  
                           
                           }
                           
                      void usunZamknietePozycjeZTablicy(int&tablicaPozycji[][]){
                           ArraySort(tablicaPozycji,WHOLE_ARRAY,0,MODE_DESCEND);
                           for(int i=0;tablicaPozycji[i][0]!=0;i++){
                           //sprawdz czy jest przypisana juz jakas parka i kasowanie wpisu w tabeli jezeli parka została zamknieta
                           if(tablicaPozycji[i][2]!=0){
                           if(true== OrderSelect(tablicaPozycji[i][2],SELECT_BY_TICKET,MODE_TRADES)){
                           if (   OrderCloseTime()!= 0    ){
                           tablicaPozycji[i][2]=0;
                           }
                           }
                           else{
                           int error = GetLastError();
                           Print("Błąd przy probie zaznaczenia pozycji przy czyszczeniuTablicyPozycji error #",GetLastError()," = ",ErrorDescription(error));
                           } 
                           }
                           // sprawdzanie czy pozycja glowna została juz zamknieta i elentualne usuwanie jej z tabeli
                           if(tablicaPozycji[i][0]!=0){
                           if(true== OrderSelect(tablicaPozycji[i][0],SELECT_BY_TICKET,MODE_TRADES)){
                           if (   OrderCloseTime()!= 0    ){
                           tablicaPozycji[i][0]=0;
                           tablicaPozycji[i][1]=0;
                           tablicaPozycji[i][3]=0;
                           if (tablicaPozycji[i][2]!=0){
                           if(true== OrderSelect(tablicaPozycji[i][2],SELECT_BY_TICKET,MODE_TRADES)){
                           if (OrderCloseTime()==0){
                           if (false==OrderClose(OrderTicket(),OrderLots(),Bid,500,clrGray)){
                           int error = GetLastError();
                           Print("Błąd przy probie zamniecia parki z powodu zamniecia pozycji glownej error #",GetLastError()," = ",ErrorDescription(error));
                           }
                           }
                           }
                           else{
                           int error = GetLastError();
                           Print("Błąd przy probie zaznaczenia parki do zamniecia z powodu zamniecia pozycji glownej error #",GetLastError()," = ",ErrorDescription(error));
                           }
                           }
                           
                           ArraySort(tablicaPozycji,WHOLE_ARRAY,0,MODE_DESCEND);
                           i=0;
                           
                           
                           }
                           }
                           else{
                           int error = GetLastError();
                           Print("Błąd przy probie zaznaczenia pozycji przy czyszczeniuTablicyPozycji error #",GetLastError()," = ",ErrorDescription(error));
                           }
                           }
                           if (tablicaPozycji[i][0]==0)
                           break;
                           }
                           }   
                           


                      void usunZamknietePozycjeZTablicyDlaPrzesuwania(int&tablicaPozycji[][]){
                           for(int s=0;s<2;s++){
                           if(s==0)
                           ArraySort(tablicaPozycji,WHOLE_ARRAY,0,MODE_ASCEND);
                           if(s==1)
                           ArraySort(tablicaPozycji,WHOLE_ARRAY,0,MODE_DESCEND);
                           
                           for(int i=0;tablicaPozycji[i][0]!=0;i++){
                           
                           // sprawdzanie czy pozycja glowna została juz zamknieta i elentualne usuwanie jej z tabeli
                           if(tablicaPozycji[i][0]!=0){
                           if(true== OrderSelect(tablicaPozycji[i][0],SELECT_BY_TICKET,MODE_TRADES)){
                           if (   OrderCloseTime()!= 0    ){
                           tablicaPozycji[i][0]=0;
                           tablicaPozycji[i][1]=0;
                           tablicaPozycji[i][2]=0;
                           tablicaPozycji[i][3]=0;
                           
                           ArraySort(tablicaPozycji,WHOLE_ARRAY,0,MODE_DESCEND);
                           i=0;
                           
                           
                           }
                           }
                           else{
                           int error = GetLastError();
                           Print("Błąd przy probie zaznaczenia pozycji przy czyszczeniuTablicyPozycji error #",GetLastError()," = ",ErrorDescription(error));
                           }
                           }
                           
                           if (tablicaPozycji[i][0]==0)
                           break;
                           }
                           
                           
                           }
                           
                           }


                           
                              
                   void    dopiszPozycjeGridDoTabeli(int&tablicaPozycji[][]){
                           ArraySort(tablicaPozycji,WHOLE_ARRAY,0,MODE_DESCEND);
                           
                           
                           
                           for(int i=OrdersTotal()-1; i>=0; i--){                     
                           if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true){
                           if(OrderMagicNumber()==magicNumber && OrderType()==kierunekRozegrania) {
                           
                           bool trzebaDodac=true;
                           int gdzieDodac=0;
                           for (int i =0;tablicaPozycji[i][0]!=0 || i==0;i++){
                           if (OrderTicket()==tablicaPozycji[i][0]){
                           trzebaDodac=false;
                           break;
                           }
                           gdzieDodac++;
                           }
                           
                           
                           if (tablicaPozycji[gdzieDodac+1][0]==0 && trzebaDodac==true){
                           tablicaPozycji[gdzieDodac+1][0]=OrderTicket();
                           tablicaPozycji[gdzieDodac+1][1]=OrderType();
                           } 
                           
                           
                           
                           
                           }
                           }
                           else{
                           int error = GetLastError();
                           Print("Błąd przy probie zaznaczenia pozycji przy dopisywaniu do tabeli pozycji grid error #",GetLastError()," = ",ErrorDescription(error));
                           }
                           }
                           }          

                     void  ustawPoziomyOtwarciaParek(int& tablicaPozycji[][]){
                           // ustaw poziom do otwarcia pierwszej parki jezeli pozycja nie miała jeszcze parki 
                           ArraySort(tablicaPozycji,WHOLE_ARRAY,0,MODE_DESCEND);
                           
                           for(int i =0;tablicaPozycji[i][0]!=0;i++){
                           
                           // ustaw poziom do otwarcia pierwszej parki jezeli pozycja nie miała jeszcze parki 
                           if (tablicaPozycji[i][1]!=-1 && tablicaPozycji[i][2]==0 && tablicaPozycji[i][3]==0){
                              //dla longow
                              if (tablicaPozycji[i][1]==0)
                              tablicaPozycji[i][3]=(-1)*getOdlegloscDoOtwarciaParki();
                              //dla shortow
                              if (tablicaPozycji[i][1]==1)
                              tablicaPozycji[i][3]=getOdlegloscDoOtwarciaParki();
                           }
                           //mamy parke ale nie zostal przesuniety poziom do ponowienia parki
                           else if (tablicaPozycji[i][1]!=-1 && tablicaPozycji[i][2]!=0 ){
                              if (true== OrderSelect(tablicaPozycji[i][2],SELECT_BY_TICKET,MODE_TRADES)   ){
                              if (OrderCloseTime()==0){
                              //dla longow
                              if (kierunekRozegrania==0)
                              tablicaPozycji[i][3]=(-1)*( getOdlegloscDoPonowieniaParki()+odlegloscMiedzyPozycjami(tablicaPozycji[i][0]  ,tablicaPozycji[i][2]  )   );
                              //dla shortow
                              if (kierunekRozegrania==1)
                              tablicaPozycji[i][3]=( getOdlegloscDoPonowieniaParki()+odlegloscMiedzyPozycjami(tablicaPozycji[i][0]  ,tablicaPozycji[i][2]  )   );
                              }
                              else tablicaPozycji[i][2]=0;
                              
                              }
                              else{
                              int error = GetLastError();
                              Print("Błąd przy probie zaznaczenia parki dla potrzeb ustalenia poziomu do ponwienia parki error #",GetLastError()," = ",ErrorDescription(error));
                              }
                              
                           }
                           // jezeli mielismy parke ale została zamknieta a poziom do ponowienia musi zostac zmieniony bo 
                           //cena weszla nad poziom otwarcia pierwszej pozycji
                           else if (tablicaPozycji[i][1]!=-1 && tablicaPozycji[i][2]==0 && tablicaPozycji[i][3]!=0 && (tablicaPozycji[i][3]!=getOdlegloscDoOtwarciaParki() && tablicaPozycji[i][3]!=getOdlegloscDoOtwarciaParki()*(-1) )  ){
                              //dla longów
                              if (true==OrderSelect(tablicaPozycji[i][0],SELECT_BY_TICKET)){
                                 if (OrderType()==0&& Bid>=OrderOpenPrice())
                                 tablicaPozycji[i][3]=(-1)*80;  //getOdlegloscDoPonowieniaParki();
                              }
                              else{
                              int error = GetLastError();
                              Print("Błąd przy probie zaznaczenia pierwszej pozycji przy resetowaniu poziomu otwarcia parki error #",GetLastError()," = ",ErrorDescription(error));
                              }
                              
                              //dla shortów 
                              if (true==OrderSelect(tablicaPozycji[i][0],SELECT_BY_TICKET)){
                                 if (OrderType()==1 && Ask<=OrderOpenPrice())
                                 tablicaPozycji[i][3]= 80;  //getOdlegloscDoPonowieniaParki();
                              }
                              else{
                              int error = GetLastError();
                              Print("Błąd przy probie zaznaczenia pierwszej pozycji przy resetowaniu poziomu otwarcia parki error #",GetLastError()," = ",ErrorDescription(error));
                              }
                           }
                           }
                           }


                           
                     void  postawParki(int&tablicaPozycji[][]){
                           ArraySort(tablicaPozycji,WHOLE_ARRAY,0,MODE_DESCEND);
                           for (int i=0;tablicaPozycji[i][0]!=0;i++){
                           
                           //dla longów
                           if (kierunekRozegrania==0 && tablicaPozycji[i][2]==0 && tablicaPozycji[i][3]!=0 && tablicaPozycji[i][1]!=(-1) )
                              if(true == OrderSelect(tablicaPozycji[i][0],SELECT_BY_TICKET)){
                              if(OrderCloseTime()==0 && Bid<=OrderOpenPrice()+tablicaPozycji[i][3]*Point){
                              int ticketParki = OrderSend(Symbol(),1,OrderLots(),Bid,50,0,0,"Parka dla pozycji ticket: "+tablicaPozycji[i][0],magicNumber,0,clrRed);
                              Print("Otworzyłem pozycje ",ticketParki , " S jako parkę dla ticketu: ",tablicaPozycji[i][0], " o oznaczeniu ",tablicaPozycji[i][1]);
                              if (ticketParki>=0){
                              tablicaPozycji[i][2]=ticketParki;
                              //drukujInformacje(tablicaPozycji);
                              }else{
                              int error = GetLastError();
                              Print("Błąd przy probie otwarcia parki S dla longa error #",GetLastError()," = ",ErrorDescription(error));
                              }
                              }
                              }else{
                              int error = GetLastError();
                              Print("Błąd przy probie zaznaczenia pierwotnej pozycji(long) przy otwieraniu parki error #",GetLastError()," = ",ErrorDescription(error));
                              }
                           //dla shortów
                              if (kierunekRozegrania==1 && tablicaPozycji[i][2]==0 && tablicaPozycji[i][3]!=0 && tablicaPozycji[i][1]!=(-1))
                              if(true == OrderSelect(tablicaPozycji[i][0],SELECT_BY_TICKET)){
                              if(OrderCloseTime()==0 && Ask>=OrderOpenPrice()+tablicaPozycji[i][3]*Point){
                              int ticketParki = OrderSend(Symbol(),0,OrderLots(),Ask,50,0,0,"Parka dla pozycji ticket: "+tablicaPozycji[i][0],magicNumber,0,clrRed);
                              Print("Otworzyłem pozycje ",ticketParki , " L jako parkę dla ticketu: ",tablicaPozycji[i][0], " o oznaczeniu ",tablicaPozycji[i][1]);
                              
                              if (ticketParki>=0){
                              tablicaPozycji[i][2]=ticketParki;
                              //drukujInformacje(tablicaPozycji);
                              }else{
                              int error = GetLastError();
                              Print("Błąd przy probie otwarcia parki L dla shorta error #",GetLastError()," = ",ErrorDescription(error));
                              }
                              }
                              }else{
                              int error = GetLastError();
                              Print("Błąd przy probie zaznaczenia pierwotnej pozycji(short) przy otwieraniu parki error #",GetLastError()," = ",ErrorDescription(error));
                              }
                           
                           }
                           }
                           
                           
                     void  ustawSLnaParkach(int& tablicaPozycji[][]){
                           ArraySort(tablicaPozycji,WHOLE_ARRAY,0,MODE_DESCEND);
                           for (int i=0;tablicaPozycji[i][0]!=0;i++){
                           if (tablicaPozycji[i][2]!=0 && tablicaPozycji[i][3]!=0){
                           if(true==OrderSelect(tablicaPozycji[i][0],SELECT_BY_TICKET)){
                           //dla longów
                           if (kierunekRozegrania==0 && Ask<=OrderOpenPrice()+tablicaPozycji[i][3]*Point ){
                           if(true==OrderSelect(tablicaPozycji[i][2],SELECT_BY_TICKET)){
                           //Print ("magic ",magicNumber," kierunek zagrywki ",kierunekRozegrania," SL pozycji:  ",OrderStopLoss(),"  SL do ustawienia  ",OrderOpenPrice()-15*Point, " warunek  ", NormalizeDouble(OrderStopLoss(),5)!=NormalizeDouble(OrderOpenPrice()-15*Point,5) );
                           if(NormalizeDouble(OrderStopLoss(),5)!=NormalizeDouble(OrderOpenPrice()-15*Point,5) && Ask<OrderOpenPrice()-20*Point  ){
                              if(false==OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-15*Point,5),OrderTakeProfit(),0,clrGray)){
                              int error = GetLastError();
                              Print("Błąd przy probie zmianie SL parki S dla L error tutaj #",GetLastError()," = ",ErrorDescription(error));
                              
                              }
                           }
                           }
                           else{
                              int error = GetLastError();
                              Print("Błąd przy probie zaznaczenia parki S dla L przy ustawianiu sl error #",GetLastError()," = ",ErrorDescription(error));
                              }
                           
                           }
                           
                           //dla shortów
                           if (kierunekRozegrania==1 && Bid>=OrderOpenPrice()+tablicaPozycji[i][3]*Point ){
                           if(true==OrderSelect(tablicaPozycji[i][2],SELECT_BY_TICKET)){
                           if(NormalizeDouble(OrderStopLoss(),5)!=NormalizeDouble(OrderOpenPrice()+15*Point,5) && Bid>OrderOpenPrice()+20*Point  )
                              if(false==OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+15*Point,5),OrderTakeProfit(),0,clrGray)){
                              int error = GetLastError();
                              Print("Błąd przy probie zmianie SL parki L dla S error #",GetLastError()," = ",ErrorDescription(error));
                              
                              }
                           }else{
                              int error = GetLastError();
                              Print("Błąd przy probie zaznaczenia parki L dla S przy ustawianiu sl error #",GetLastError()," = ",ErrorDescription(error));
                              }
                           
                           }
                           
                           
                           }else{
                              int error = GetLastError();
                              Print("Błąd przy probie zaznaczenia pierwotnej pozycji przy ustawaniu SL parek error #",GetLastError()," = ",ErrorDescription(error));
                              }
                           
                           }
                           }
                           }



                     void  ustawPoziomZaknieciaPierowotnych(int& tablicaPozycji[][]){
                           ArraySort(tablicaPozycji,WHOLE_ARRAY,0,MODE_DESCEND);
                           double strefa;
                           
                           
                           ZarzadzaniePozycjami* manager=new ZarzadzaniePozycjami(magicNumber);
                           manager.zaznaczNajgorszaPozycjeDanegoTypu(kierunekRozegrania);
                           int ticket1=OrderTicket();
                           manager.zaznaczNajlepszaPozycjeDanegoTypu(kierunekRozegrania);
                           int ticket2=OrderTicket();
                           
                           if (kierunekRozegrania==0)
                           strefa=OrderOpenPrice()+getSzerokoscStrefy()*Point;
                           if (kierunekRozegrania==1)
                           strefa=OrderOpenPrice()-getSzerokoscStrefy()*Point;
                           
                           if (odlegloscMiedzyPozycjami(ticket1,ticket2)>getSzerokoscStrefy() ){
                           
                           for (int i=0;tablicaPozycji[i][0]!=0;i++){
                           if (true==OrderSelect(tablicaPozycji[i][0],SELECT_BY_TICKET)){
                           
                           //wariant dla longów
                           if (OrderType()==0 && OrderOpenPrice()>strefa)
                           tablicaPozycji[i][2]=(OrderOpenPrice()+30*Point)/Point;
                           
                           
                           if (OrderType()==1 && OrderOpenPrice()<strefa)
                           tablicaPozycji[i][2]=(OrderOpenPrice()-30*Point)/Point;
                           
                           
                           
                           }else{
                              int error = GetLastError();
                              Print("Błąd przy probie zaznaczenia pierwotnej pozycji przy ustawaniu ceny zamkniecia (przesuwanie tradów)parek error #",GetLastError()," = ",ErrorDescription(error));
                              }
                           
                           
                           
                           }
                           
                           }
                           
                           
                           
                           
                           if (CheckPointer(GetPointer (manager))!=POINTER_INVALID)
                              delete (GetPointer(manager));
                           
                           }    


                     void  zamknijPozycjeIUstawPoziomOdnowienia(int& tablicaPozycji[][]){
                           ArraySort(tablicaPozycji,WHOLE_ARRAY,0,MODE_DESCEND);
                           
                           for (int i=0;tablicaPozycji[i][0]!=0;i++){
                           if (true==OrderSelect(tablicaPozycji[i][0],SELECT_BY_TICKET)){
                           
                           //wariant dla longów
                           if (OrderType()==0 && tablicaPozycji[i][2]!=0 && Bid>tablicaPozycji[i][2]*Point){
                           if( true==OrderClose(OrderTicket(),OrderLots(),Bid,100,clrBlue)){
                           tablicaPozycji[i][0]=-1;
                           tablicaPozycji[i][1]=0;
                           tablicaPozycji[i][2]=0;
                           tablicaPozycji[i][3]=Bid/Point-getPozycjaLepszaO();
                           }else{
                              int error = GetLastError();
                              Print("Błąd przy probie zamknięcia pozycji long przy przenoszeniu error #",GetLastError()," = ",ErrorDescription(error));
                              }
                           
                           }
                           
                           // wariant dla shortow
                           if (OrderType()==1 && tablicaPozycji[i][2]!=0 && Ask<tablicaPozycji[i][2]*Point){
                           if( true==OrderClose(OrderTicket(),OrderLots(),Ask,100,clrBlue)){
                           tablicaPozycji[i][0]=-1;
                           tablicaPozycji[i][1]=1;
                           tablicaPozycji[i][2]=0;
                           tablicaPozycji[i][3]=Ask/Point+getPozycjaLepszaO();
                           }else{
                              int error = GetLastError();
                              Print("Błąd przy probie zamknięcia pozycji short przy przenoszeniu error #",GetLastError()," = ",ErrorDescription(error));
                              }
                           
                           }
                           
                           }else{
                              int error = GetLastError();
                              Print("Błąd przy probie zaznaczenia pierwotnej pozycji przy zamykaniu dla przenoszenia pozycji error #",GetLastError()," = ",ErrorDescription(error));
                              }
                           
                           }
                           }
                           
                           
                           
                           
                     void  odnowPozycjeWLepszejCenie(int& tablicaPozycji[][]){
                           ArraySort(tablicaPozycji,WHOLE_ARRAY,0,MODE_ASCEND);
                           
                           
                           LotSize* lot= new LotSize(getFixedLot(),getFixedLotSize(),getLotPer1k());
                           for(int i =0; tablicaPozycji[i][0]==-1 ; i++){
                           //Print("pozycja [  ",i,"][0] do odnowienia na ",tablicaPozycji[i][3]*Point);
                           
                           
                           if (tablicaPozycji[i][3]==0){
                           tablicaPozycji[i][0]=0;
                           tablicaPozycji[i][1]=0;
                           tablicaPozycji[i][2]=0;
                           tablicaPozycji[i][3]=0;
                           Print ("Błąd: do modułu odnawiania pozycji trafiła pozcyja bez ustalonej ceny odnowienia");
                           }
                           
                           // wariant dla longów
                           if (tablicaPozycji[i][1]==0 && tablicaPozycji[i][0]==-1 && tablicaPozycji[i][3]!=0 && Ask<tablicaPozycji[i][3]*Point){
                           int ticket=OrderSend(Symbol(),0,lot.getLotSize(),Ask,50,0,0,"Pozycja przeniesiona",magicNumber,0,clrBlue);
                           if(ticket==-1){
                              int error = GetLastError();
                              Print("Błąd przy probie ponowienia pozycji Long error #",GetLastError()," = ",ErrorDescription(error));
                           }else{
                           tablicaPozycji[i][0]=ticket;
                           tablicaPozycji[i][2]=0;
                           tablicaPozycji[i][3]=0;
                           }
                           }
                           
                           // wariant dla shortów
                           if (tablicaPozycji[i][1]==1 && tablicaPozycji[i][0]==-1 && tablicaPozycji[i][3]!=0 && Bid>tablicaPozycji[i][3]*Point){
                           int ticket=OrderSend(Symbol(),1,lot.getLotSize(),Bid,50,0,0,"Pozycja przeniesiona",magicNumber,0,clrRed);
                           if(ticket==-1){
                              int error = GetLastError();
                              Print("Błąd przy probie ponowienia pozycji Short error #",GetLastError()," = ",ErrorDescription(error));
                           }else{
                           tablicaPozycji[i][0]=ticket;
                           tablicaPozycji[i][2]=0;
                           tablicaPozycji[i][3]=0;
                           }
                           }
                           
                           }
                           
                           if (CheckPointer(GetPointer (lot))!=POINTER_INVALID)
                           delete (GetPointer(lot));
                           
                           }                           
                           
                           
                           


                      int magicNumber,kierunekRozegrania;
public:              
                      MechanizmParkowy();
                      MechanizmParkowy(int magicNumber,int kierunekRozegrania){
                      this.magicNumber=magicNumber;
                      this.kierunekRozegrania=kierunekRozegrania;
                      }
                     ~MechanizmParkowy();
            
            void     usunZamkniete(int& tablicaPozycji[][]){
                     usunZamknietePozycjeZTablicyDlaPrzesuwania(tablicaPozycji);
                     }
                    
            void     przenosPozycje(int& tablicaPozycji[][]){
                     dopiszNowaPierwszaPozycjeDoTablicy(tablicaPozycji);
                     dopiszPozycjeGridDoTabeli(tablicaPozycji);
                     ustawPoziomZaknieciaPierowotnych(tablicaPozycji);
                     zamknijPozycjeIUstawPoziomOdnowienia(tablicaPozycji);
                     odnowPozycjeWLepszejCenie(tablicaPozycji);
                     
                     }       
                    
                    
            void     robParki(int& tablicaPozycji[][]){
            
                     usunZamknietePozycjeZTablicy(tablicaPozycji);
                     dopiszNowaPierwszaPozycjeDoTablicy(tablicaPozycji);
                     //pilnujZebyNajgorszaPozycjaMialaOznaczenie(tablicaPozycji);
                     dopiszPozycjeGridDoTabeli(tablicaPozycji);
                     ustawPoziomyOtwarciaParek(tablicaPozycji);
                     postawParki(tablicaPozycji);
                     ustawSLnaParkach(tablicaPozycji);
                     
                     
                     
                     }  
                     
                     
                     
                    
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MechanizmParkowy::MechanizmParkowy()
  {
  
  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MechanizmParkowy::~MechanizmParkowy()
  {
  }
//+------------------------------------------------------------------+


int odlegloscMiedzyPozycjami(int ticket1, int ticket2){
double poziom1;
double poziom2;
if (ticket1==0 || ticket2==2)
return 0;

if (OrderSelect(ticket1,SELECT_BY_TICKET)==true)
poziom1=OrderOpenPrice();
else {
      int error = GetLastError();
      Print("Błąd przy probie zaznaczenia pozycji1 do obliczania odleglosci error #",GetLastError()," = ",ErrorDescription(error));
      }
      
if (OrderSelect(ticket2,SELECT_BY_TICKET)==true)
poziom2=OrderOpenPrice();
else {
      int error = GetLastError();
      Print("Błąd przy probie zaznaczenia pozycji2 do obliczania odleglosci error #",GetLastError()," = ",ErrorDescription(error));
      }

double wynik=(poziom1-poziom2)/Point;

if (wynik>=0)
return wynik;
else return wynik*(-1);

}


void drukujInformacje(int& tablicaPozycji[][]){
Print("!!!!!!!!!!!!!!!!!!!!!!!!!");
for (int i=0;i<6;i++){
Print("#######################");
Print("Poziom ponowienia parki [",i,"][3] = ",tablicaPozycji[i][3]);
Print("Ticket parki [",i,"][2] = ",tablicaPozycji[i][2]);
Print("Oznaczenie glownej pozycji [",i,"][1] = ",tablicaPozycji[i][1]);
Print("Ticket glownej pozycji [",i,"][0] = ",tablicaPozycji[i][0]);




}
Print("!!!!!!!!!!!!!!!!!!!!!!!!!");

}