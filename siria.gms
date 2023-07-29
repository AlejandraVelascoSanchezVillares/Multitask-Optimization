sets
i ciudades del grafo /Niamey,Gaya,Dosso,Tahoua,Maradi,Tanout,Agadez,Zinder/
origen(i) ciudades de donde sale la ayuda /Niamey,Gaya/
destino(i) ciudades llega la ayuda /Agadez,Zinder/
k tipo de vehiculo /1,2/
alias(i,j);

table d(i,j) distancia entre el nodo i y el nodo j
        Niamey Gaya Dosso Tahoua Maradi Tanout Agadez Zinder
Niamey    0     286  138   564     0      0      0      0
Gaya     286     0   151    0     626     0      0      0
Dosso    138    151   0    413    523     0      0      0
Tahoua   564     0   413    0     347    486    406     0
Maradi    0     626  523   347     0     313     0     235
Tanout    0      0    0    486    313     0     300    145
Agadez    0      0    0    406     0     300     0      0
Zinder    0      0    0     0     235    145     0      0;

table num(i,k) numero de vehiculos de tipo k que hay en la ciudad i
        1  2
Niamey 60 20
Gaya   55 40
Dosso  10 20
Tahoua  8 30
Maradi  5  5
Tanout  0  0
Agadez  0  0
Zinder  0  0;

parameters
fondo(origen) tamaño del fondo de origen /Niamey 800,Gaya 500/
dem(destino) demanda de la localidad /Agadez 237,Zinder 519/
capVeh(k) capacidad del vehiculo /1 1.5,2 3/
cosFijo(k) coste fijo del vehiculo k por km /1 0.1,2 0.15/
ruta(i,j) 1 si existe la ruta (i j) y 0 en otro caso;

ruta(i,j)$(d(i,j)>0)=1;
display ruta;

scalars
ayudaTotal toneladas que se envian /450/
presTotal presupuesto total /80000/
cosVaria coste variables por tonelada y por km /0.025/;

variables
t(i,j,k) toneladas enviadas de i a j en vehiculo de tipo k
n(i,j,k) numero de vehiculos de tipo k que van de i a j
z coste total de la mision;

positive variables t;
integer variables n;

equations
fobj coste total de la mision
presupuesto no se puede superar el presupuesto
capVehiculo(i,j,k) lo que lleva cada vehiculo no puede superar su capacidad
nodIntermedios(j) en los nodos intermedios no se queda la ayuda
tamFondo(origen) lo que sale de cada ciudad origen no puede superar el tamaño de los fondos
demanda(destino) no mandamos mas de la demanda
ayudaLlega lo que sale de origen llega a destino
ayudaDisp tenemos 450 toneladas para repartir
limVehi(i,k) no se puede usar un vehiculo si no hay
saleDest(destino) lo que sale del destino es nulo;

fobj..z=E=sum((i,j,k),cosVaria*d(i,j)*t(i,j,k))+2*sum((i,j,k),cosFijo(k)*d(i,j)*n(i,j,k));
presupuesto..sum((i,j,k)$(d(i,j)>0),cosVaria*d(i,j)*t(i,j,k))+2*sum((i,j,k)$(d(i,j)>0),cosFijo(k)*d(i,j)*n(i,j,k))=L=presTotal;
capVehiculo(i,j,k)$(d(i,j)>0)..t(i,j,k)=L=capVeh(k)*n(i,j,k)*ruta(i,j);
nodIntermedios(j)$(ord(j)>2 and ord(j)<7)..sum((i,k)$(d(i,j)>0),t(i,j,k))-sum((i,k)$(d(i,j)>0),t(j,i,k))=E=0;
tamFondo(origen)..sum((j,k)$(d(origen,j)>0),t(origen,j,k))=L=fondo(origen);
demanda(destino)..sum((i,k)$(d(i,destino)>0),t(i,destino,k))=L=dem(destino);
ayudaLlega..sum((origen,j,k)$(d(origen,j)>0),t(origen,j,k))=E=sum((i,destino,k)$(d(i,destino)>0),t(i,destino,k));
ayudaDisp..sum((origen,j,k)$(d(origen,j)>0),t(origen,j,k))=E=ayudaTotal;
limVehi(i,k)..sum(j$(d(i,j)>0),n(i,j,k))=L=num(i,k)+sum(j$(d(i,j)>0),n(j,i,k));
saleDest(destino)..sum((j,k)$(d(destino,j)>0),t(destino,j,k))=E=0;

option optcr=0;
model niger2 /all/;
solve niger2 using MIP minimizing z;
display t.l,n.l;