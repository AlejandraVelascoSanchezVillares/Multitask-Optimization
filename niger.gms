sets
i numero de centro /Tanout,Agadez,Zinder,Maradi/
j numero de localidad /In-Gall,Aderbissinat,Tessaoua,Dakoro,Tatokou,Bakatchiraba,Mayahi,Koundoumaoua,Sabon-Kafi/
o numero de funcion objetivo /demanda,coste,distancia,equidad/
jota valores para obtener lambda en los bucles /j1*j10/
numit /1*3/
 
alias(o,oo);

table dist(i,j) km del centro i a la localidad j
        In-Gall Aderbissinat Tessaoua Dakoro Tatokou Bakatchiraba Mayahi Koundoumaoua Sabon-Kafi
Tanout    396       147         191     244    43        8         252      197          43
Agadez    119       161         492     562    258       306       553      490          336 
Zinder    541       286         114     300    188       152       156      71           102
Maradi    625       454         122     124    355       320       95       183          269;

parameters
coste(i) coste por tonelada gestionada en el centro i /Tanout 70,Agadez 50,Zinder 30,Maradi 90/
dem(j) demanda de la localidad j /In-Gall 156,
                                  Aderbissinat 81,
                                  Tessaoua 129,
                                  Dakoro 213,
                                  Tatokou 39,
                                  Bakatchiraba 30,
                                  Mayahi 273,
                                  Koundoumaoua 30,
                                  Sabon-Kafi 18/
d(i,j) matriz con 1 si dist(i j)<=200 y 0 eoc
alfa(o) parametro para variar la funcion objetivo a minimizar
mp(o,o) matriz de pagos
la lambda parametro para la frontera de Pareto
DeaspV /1 150,2 100,3 300/
CaspV /1 20500, 2 34000,3 41100/
DaspV /1 57300, 2 80500,3 100000/
EaspV /1 0.1,2 0.22,3 0.45/;
*Construimos la matriz d(i,j)
d(i,j)$(dist(i,j)<=200)=1;

scalars
cantidadDisponible toneladas totales de ayuda recibida /850/
demandaTotal demanda total de las localidades /969/
costeCentro coste fijo por abrir un centro /1000/
presupuestoTotal presupuesto total /40000/
limCentros numero maximo de centros que puedo construir /3/
minPorcentaje porcentaje minimo de demanda que tengo que satisfacer /0.6/
k escalar empleado para los bucles
m escalar empleado para los bucles
epsCoste epsilon para el metodo de las epsilon restricciones en la frontera de Pareto de demanda y coste /0/
epsDistancia epsilon para el metodo de las epsilon restricciones en la frontera de Pareto de demanda y distancia /0/
epsEquidad epsilon para el metodo de las epsilon restricciones en la frontera de Pareto de demanda y equidad /0/
Deasp
Casp
Dasp 
Easp ; 

variables
const(i) 1 si se construye un centro en i 0 si no
cant(i) toneladas que llegan al centro i
t(i,j) toneladas transportadas del centro i a la localidad j
demNS(j) demanda no satisfecha en la localidad j
prop proporcion de demanda total no satisfecha
NDem
NC 
ND
NE 
PDem
PC 
PD 
PE
zdemanda total de la demanda no satisfecha
zcoste coste total
zdistancia distancia total recorrida entre los centros y las localidades
zequidad reparto entre las localidades sea equitativo
zi(o) variable selecciona la funcion objetivo o-esima
z suma de las zi(o) 
zponderadaDC funcion objetivo ponderada de la demanda y el coste
zponderadaDD funcion objetivo ponderada de la demanda y la distancia
zponderadaDE funcion objetivo ponderada de la demanda y la equidad
zmetas funcion objetivo metas;

positive variables t,cant,demNS,prop,NDem,NC,ND,NE,PDem,PC,PD,PE;
binary variables const;

equations
fobjdemanda total de la demanda no satisfecha
fobjcoste coste total
fobjdistancia distancia total recorrida entre los centros y las localidades
fobjequidad reparto entre las localidades sea equitativo
*bjetivo(o) selecciona la variable del objetivo o-esimo
*obj suma de las zi(o)
fobjponderadaDC metodo de las ponderaciones para frontera de Pareto entre demanda y coste
fobjponderadaDD metodo de las ponderaciones para frontera de Pareto entre demanda y distancia
fobjponderadaDE metodo de las ponderaciones para frontera de Pareto entre demanda y equidad
presupuesto no se puede superar el presupuesto disponible
toneladas1 no se puede superar la cantidad de toneladas disponibles
toneladas2 hay que satisfacer al menos un 60% de la demanda total
toneladas3(i) el centro i no puede mandar mas toneladas de las que recibe
numeroCentros numero maximo de centros que se pueden construir
demandaLocalidad(j) no enviamos a cada localidad mas de lo que demandan
noEnviamos(i,j) no enviamos toneladas si el centro no se ha construido o si esta a mas de 200km
repartoEquitativo(j) la proporcin de demanda total no satisfecha es mayor o igual que la proporcion de demanda no satisfecha en cada j
restEpsDC metodo de las epsilon restricciones para frontera de Pareto entre demanda y coste
restEpsDD metodo de las epsilon restricciones para frontera de Pareto entre demanda y distancia
restEpsDE metodo de las epsilon restricciones para frontera de Pareto entre demanda y equidad
fobjmetas programacion por metas
metasDem programacion por metas para la demanda
metasC programacion por metas para coste
metasD programacion por metas para distancias
metasE programacion por metas para equidad;
 

fobjdemanda..zdemanda=E=sum(j,demNS(j));
fobjcoste..zcoste=E=sum(i,costeCentro*const(i)+coste(i)*cant(i));
fobjdistancia..zdistancia=E=sum((i,j),dist(i,j)*t(i,j));
fobjequidad..zequidad=E=prop;
*bjetivo(o)..zi(o)=E=zdemanda$(ord(o)=1)+zcoste$(ord(o)=2)+zdistancia$(ord(o)=3)+zequidad$(ord(o)=4);
*obj..z=E=sum(o,alfa(o)*zi(o));
fobjponderadaDC..zponderadaDC=E=la*(zdemanda/119)+(1-la)*(zcoste/20690);
fobjponderadaDD..zponderadaDD=E=la*(zdemanda/119)+(1-la)*(zdistancia/54411.433);
fobjponderadaDE..zponderadaDE=E=la*(zdemanda/119)+(1-la)*(zequidad/0.206);
presupuesto..sum(i,costeCentro*const(i)+coste(i)*cant(i))=L=presupuestoTotal;
toneladas1..sum(i,cant(i))=L=cantidadDisponible;
toneladas2..sum((i,j),t(i,j))=G=minPorcentaje*demandaTotal;
toneladas3(i)..sum(j,t(i,j))=L=cant(i);
numeroCentros..sum(i,const(i))=L=limCentros;
demandaLocalidad(j)..sum(i,t(i,j))+demNS(j)=E=dem(j);
noEnviamos(i,j)..t(i,j)=L=d(i,j)*dem(j)*const(i);
repartoEquitativo(j)..prop=G=demNS(j)/dem(j);
restEpsDC..zcoste=L=epsCoste;
restEpsDD..zdistancia=L=epsDistancia;
restEpsDE..zequidad=L=epsEquidad;

fobjmetas..zmetas=E=(PC/Casp)+(PD/Dasp)+(PE/Easp)+(PDem/Deasp);
metasDem..Deasp=E=zdemanda+NDem-PDem;
metasC..Casp=E=zcoste+NC-PC;
metasD..Dasp=E=zdistancia+ND-PD;
metasE..Easp=E=zequidad+NE-PE;

*Matriz de pagos


*Programaacion por metas*
model metas /all-fobjponderadaDC-fobjponderadaDD-fobjponderadaDE-restEpsDC-restEpsDD-restEpsDE/;
loop(numit,
    Deasp =DeaspV(numit);
    Casp=CaspV(numit);
    Dasp=DaspV(numit);
    Easp=EaspV(numit);
     solve metas using MIP minimizing zmetas
     );
