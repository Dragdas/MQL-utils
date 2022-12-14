//+------------------------------------------------------------------+
//|                                         ZarzadzaniePozycjami.mqh |
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
class ZarzadzaniePozycjami
  {
private:             
                     int magicNumber;

public:
                     ZarzadzaniePozycjami();
                    ~ZarzadzaniePozycjami();
                     ZarzadzaniePozycjami(int magicNumber){
                     
                     this.magicNumber=magicNumber;                  
                     }
                    
                    
                    double wartoscKoszyka(int kierunekZlotego){
                    double w;
                    zaznaczNajlepszaPozycjeDanegoTypu(kierunekZlotego);
                    int ticketNajlepszejPozycji=OrderTicket();
                    
                    for(int i=OrdersTotal()-1; i>=0; i--){                     
                     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true){
                     
                     if (OrderTicket()!=ticketNajlepszejPozycji && OrderMagicNumber()==magicNumber){
                     w+=OrderProfit()+OrderCommission()+OrderSwap();
                                       
                     }                     
                     
                     }
                     else Print ("Błąd funkcji order Select w czasie obliczania wartosci koszyka n-1. Błąd: ",GetLastError());
                     }
                    return w;
                    }
                    
                    
                    double wartoscWszystkichPozycji(){
                    double w;
                                        
                    for(int i=OrdersTotal()-1; i>=0; i--){                     
                     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true){
                     
                     if ( OrderMagicNumber()==magicNumber){
                     w+=OrderProfit()+OrderCommission()+OrderSwap();
                                       
                     }                     
                     
                     }
                     else Print ("Błąd funkcji order Select w czasie obliczania wartosci koszyka n-1. Błąd: ",GetLastError());
                     }
                    return w;
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    void zaznaczNajlepszaPozycjeDanegoTypu(int typ){
                     
                     double cenaOtwarciaNajlepszejPozycji;
                     int ticketNajlepszejPozycji=-1;
                     
                     if( (typ==0 && iloscPozycji(0)==0  ) || (typ==1 && iloscPozycji(1)==0 )  ) 
                     OrderSelect(-1,SELECT_BY_TICKET);
                     else if( (typ==0 && iloscPozycji(0)>0) || ( typ==1 && iloscPozycji(1)>0   )   ){
                     
                     if (typ==0 )
                     cenaOtwarciaNajlepszejPozycji=500;
                                        
                     for(int i=OrdersTotal()-1; i>=0; i--){                     
                     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true){
                     //Print ("sprawdzam: rodzaj= ",typ, " ordType ",OrderType()," mn: ",magicNumber," order MN: ",OrderMagicNumber()   );

                     if (OrderOpenPrice()>cenaOtwarciaNajlepszejPozycji && OrderType()==typ && OrderMagicNumber()==magicNumber && typ==1 ){
                     cenaOtwarciaNajlepszejPozycji=OrderOpenPrice();
                     ticketNajlepszejPozycji=OrderTicket();
                     }
                     
                     if (OrderOpenPrice()<cenaOtwarciaNajlepszejPozycji && OrderType()==typ && OrderMagicNumber()==magicNumber && typ==0  ){
                     cenaOtwarciaNajlepszejPozycji=OrderOpenPrice();
                     ticketNajlepszejPozycji=OrderTicket();
                     }
                                         
                     
                     }
                     else Print ("Błąd funkcji order Select w szukaniu najlepszej pozycji. Błąd: ",GetLastError());
                     }
                    
                     if(OrderSelect(ticketNajlepszejPozycji,SELECT_BY_TICKET)!=true)
                     Print ("Błąd funkcji order Select wprzy zaznaczaniu najlepszej pozycji. Błąd: ",GetLastError());

                     }
                     }
                     
                     
                     
                     void zaznaczNajgorszaPozycjeDanegoTypu(int typ){
                     
                     double cenaOtwarciaNajgorszejPozycji;
                     int ticketNajgorszejPozycji=-1;
                     
                     if( (typ==0 && iloscPozycji(0)==0  ) || (typ==1 && iloscPozycji(1)==0 )  ) 
                     OrderSelect(-1,SELECT_BY_TICKET);
                     else if( (typ==0 && iloscPozycji(0)>0) || ( typ==1 && iloscPozycji(1)>0   )   ){
                     
                     if (typ==1 )
                     cenaOtwarciaNajgorszejPozycji=500;
                                        
                     for(int i=OrdersTotal()-1; i>=0; i--){                     
                     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true){
                     //Print ("sprawdzam: rodzaj= ",typ, " ordType ",OrderType()," mn: ",magicNumber," order MN: ",OrderMagicNumber()   );

                     if (OrderOpenPrice()<cenaOtwarciaNajgorszejPozycji && OrderType()==typ && OrderMagicNumber()==magicNumber && typ==1 ){
                     cenaOtwarciaNajgorszejPozycji=OrderOpenPrice();
                     ticketNajgorszejPozycji=OrderTicket();
                     }
                     
                     if (OrderOpenPrice()>cenaOtwarciaNajgorszejPozycji && OrderType()==typ && OrderMagicNumber()==magicNumber && typ==0  ){
                     cenaOtwarciaNajgorszejPozycji=OrderOpenPrice();
                     ticketNajgorszejPozycji=OrderTicket();
                     }
                                         
                     
                     }
                     else Print ("Błąd funkcji order Select w szukaniu najlepszej pozycji. Błąd: ",GetLastError());
                     }
                    
                     if(OrderSelect(ticketNajgorszejPozycji,SELECT_BY_TICKET)!=true)
                     Print ("Błąd funkcji order Select wprzy zaznaczaniu najlepszej pozycji. Błąd: ",GetLastError());

                     }
                     }
                     
                     
                     
                     
                    
                     // zwraca ilosc pozycji -1- wszystkie, 
                    double iloscPozycji(int rodzaj){
                    double w;
                                        
                    for(int i=OrdersTotal()-1; i>=0; i--){                     
                     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true){
                     //Print ("sprawdzam: rodzaj= ",rodzaj, " ordType ",OrderType()," mn: ",magicNumber," order MN: ",OrderMagicNumber()   );
                     if (OrderType()==rodzaj && OrderMagicNumber()==magicNumber){
                     w+=1;}
                     
                     if (rodzaj==(-1) && OrderMagicNumber()==magicNumber){
                     //Print ("sprawdzam: rodzaj= ",rodzaj, " mn: ",magicNumber," order MN: ",OrderMagicNumber()   );
                     w+=1;
                     //Print ("w:  ",w   );
                     }
                                       
                                         
                     
                     }
                     else Print ("Błąd funkcji order Select w liczeniu ilości otwartych pozycji. Błąd: ",GetLastError());
                     }
                    return w;
                    }
                    
                    
                    double sumaWolumenu(int rodzaj){

                     double wolumen;

                     for (int i=0 ; i<OrdersTotal();i++){
                     if(OrderSelect(i,SELECT_BY_POS)==True){
                     if (OrderType()==rodzaj && OrderMagicNumber()==magicNumber)
                     wolumen+=OrderLots();
                     }else
                     Print("Błąd OrderSelect w formule sumy wolumenu. Błąd: ",GetLastError()," i= ",i);

                     }
                     return (wolumen);
                     }
                    
                    
             double sredniaCena(int rodzaj){
                    double sumaCen;

                    for (int i=0 ; i<OrdersTotal();i++){
                    if(OrderSelect(i,SELECT_BY_POS)==True){
                    if (OrderType()==rodzaj && OrderMagicNumber()==magicNumber)
                    sumaCen+=OrderOpenPrice();
                    }else
                        Print("Błąd OrderSelect w formukle sumy wolumenu. Błąd: ",GetLastError()," i= ",i);

                     }
                    if (iloscPozycji(rodzaj)==0)
                    return (0);
                    else
                    return (sumaCen/iloscPozycji(rodzaj));
                    }
                    
                    
                    
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ZarzadzaniePozycjami::ZarzadzaniePozycjami()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ZarzadzaniePozycjami::~ZarzadzaniePozycjami()
  {
  }
//+------------------------------------------------------------------+
