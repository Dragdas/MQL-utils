//+------------------------------------------------------------------+
//|                                                        Hedge.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "ZarzadzaniePozycjami.mqh"
#include "ElektroParowoz.mq4"
#include "Engine.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Hedge
  {
  
  void               otworzPierwszaPozycje(){
                     // ustal kierunek i czy trzeba ją otworzyć 
                     ZarzadzaniePozycjami* manager = new ZarzadzaniePozycjami(magicNumber);
                     
                     
                     // wariant otwarcia long dla selli
                     if  (manager.iloscPozycji(1)>0 && manager.iloscPozycji(0)==0){
                     manager.zaznaczNajlepszaPozycjeDanegoTypu(1);
                     if (Ask>OrderOpenPrice()){
                     
                     double lot=(manager.sumaWolumenu(1)*odlegloscMiedzyPoziomami(manager.sredniaCena(1),Bid+getWyjdzZHedge()*Point))/odlegloscMiedzyPoziomami(Bid,Bid+getWyjdzZHedge()*Point);
                     int ticket=OrderSend(Symbol(),0,lot,Ask,50,Ask-40*Point,0,"Hedge dla pozycji short",magicNumber,0,clrBlue);     
                     
                     if(ticket==-1){
                              int error = GetLastError();
                              Print("Błąd przy probie otwarcia pierwszej pozycji hedge L error #",GetLastError()," = ",ErrorDescription(error));
                     
                     }
                     
                     }
                     }
                     
                     
                     //wariant otwarcia  shorta dla longow
                     if ((manager.iloscPozycji(0)>0 && manager.iloscPozycji(1)==0)){
                     manager.zaznaczNajlepszaPozycjeDanegoTypu(0);
                     if(Bid<OrderOpenPrice()){
                     double lot=(manager.sumaWolumenu(0)*odlegloscMiedzyPoziomami(manager.sredniaCena(0),Ask-getWyjdzZHedge()*Point))/odlegloscMiedzyPoziomami(Ask,Ask-getWyjdzZHedge()*Point);
                     int ticket=OrderSend(Symbol(),1,lot,Bid,50,Bid+40*Point,0,"Hedge dla pozycji long",magicNumber,0,clrRed);     
                     
                     if(ticket==-1){
                              int error = GetLastError();
                              Print("Błąd przy probie otwarcia pierwszej pozycji hedge S error #",GetLastError()," = ",ErrorDescription(error));
                     
                     }
                     
                     }
                     
                     }
                     
                     
                     
                     if (CheckPointer(GetPointer (manager))!=POINTER_INVALID)
                           delete (GetPointer(manager)); 
                     
                     }
  
  

bool                 zamknijWszytskoNaPlus(){
                     ZarzadzaniePozycjami* manager = new ZarzadzaniePozycjami(magicNumber);
                     
                     if((manager.iloscPozycji(0)>0 && manager.iloscPozycji(1)>0 && manager.wartoscWszystkichPozycji()>1)||getSLK()==true){
                     // zawmknij wszystko i zwroc false
                     
                     for ( ;manager.iloscPozycji(-1)>0 ; ){
                     for(int i=OrdersTotal()-1; i>=0; i--){                     
                     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true){
                     if ( OrderMagicNumber()==magicNumber){
                     if ( OrderClose(OrderTicket(),OrderLots(),Bid,500,clrGreen)!=true)
                     Print ("Błąd funkcji order close w czasie zamykania wszytskich pozycji w hedge. Błąd: ",GetLastError()," = ", 
                           ErrorDescription(GetLastError()));  
                     else{
                      Print("Zamykam pozycje hedge. ");                
                      
                     }
                     
                     }                     
                     
                     }
                     else Print ("Błąd funkcji order Select w czasie zaznaczania wszystkich pozycji do zamkniecia w hedge. Błąd: ",
                           GetLastError()," = ",ErrorDescription(GetLastError()));
                     }
                     
                     
                     }                     
                     
                     if (CheckPointer(GetPointer (manager))!=POINTER_INVALID)
                           delete (GetPointer(manager));
                     
                     return false;
                     }
                     
                     
                     
                     
                     
                     
                     
                     if (CheckPointer(GetPointer (manager))!=POINTER_INVALID)
                           delete (GetPointer(manager)); 
                     return true;
                     }
                     
                     
  void               otwierajKolejnePozycjeHedge(){
                     
                     ZarzadzaniePozycjami* manager = new ZarzadzaniePozycjami(magicNumber);
                     
                     // otwieranie buy
                     if ( manager.iloscPozycji(0)>0 && manager.iloscPozycji(1)>0 && 
                     manager.sumaWolumenu(1)>=manager.sumaWolumenu(0) && Ask>=manager.sredniaCena(0) ){
                           double lot=(manager.sumaWolumenu(1)*odlegloscMiedzyPoziomami(manager.sredniaCena(1),Bid+getWyjdzZHedge()*Point))/odlegloscMiedzyPoziomami(Bid,Bid+getWyjdzZHedge()*Point);
                           int ticket=OrderSend(Symbol(),0,lot,Ask,50,0,0,"Hedge dla pozycji short",magicNumber,0,clrBlue);     
                     
                           if(ticket==-1){
                              int error = GetLastError();
                              Print("Błąd przy probie otwarcia pierwszej pozycji hedge L error #",GetLastError()," = ",ErrorDescription(error));
                              }
                     
                     }
                     
                     
                     // wariant dla shortów
                     if ( manager.iloscPozycji(1)>0 && manager.iloscPozycji(0)>0 && 
                     manager.sumaWolumenu(0)>=manager.sumaWolumenu(1) && Bid<=manager.sredniaCena(1) ){
                     
                     double lot=(manager.sumaWolumenu(0)*odlegloscMiedzyPoziomami(manager.sredniaCena(0),Ask-getWyjdzZHedge()*Point))/odlegloscMiedzyPoziomami(Ask,Ask-getWyjdzZHedge()*Point);
                     int ticket=OrderSend(Symbol(),1,lot,Bid,50,0,0,"Hedge dla pozycji long",magicNumber,0,clrBlue);     
                     
                     if(ticket==-1){
                              int error = GetLastError();
                              Print("Błąd przy probie otwarcia pierwszej pozycji hedge S error #",GetLastError()," = ",ErrorDescription(error));
                     
                     }
                     
                     }
                     
                     
                     
                     
                     
                     if (CheckPointer(GetPointer (manager))!=POINTER_INVALID)
                           delete (GetPointer(manager)); 
                     
                     }

  
private:
                     int magicNumber;
public:
                     Hedge(int magicNumber){
                     this.magicNumber=magicNumber;}
                     Hedge();
                    ~Hedge();
                    
                    
            bool     rozegrajHedgeIWyzeruj(){
                     if(getSLK()==false)
                     otworzPierwszaPozycje();
                     otwierajKolejnePozycjeHedge();
                     
                     
                     return zamknijWszytskoNaPlus();
                     
                     }        
                    
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Hedge::Hedge()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Hedge::~Hedge()
  {
  }
//+------------------------------------------------------------------+
