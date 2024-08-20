## Curso de Diseño Digital Avanzado - EAMTA 2023

### 1er bloque: Introduccion

Nada a mas de 1GHz se puede hacer por software

Memoria: es practicamente posible de verificar, por lo general se hacen abstracciones y usarlas como cajas negras hasta el final del diseño.

ASIC: Application specific Integrated Circuit

#### Niveles de jerarquia
level 1 CPU
level 2 memory cpu i/o


#### Design Process
El proceso de diseño es un ida y vuelta entre diseño y verificación

### Design

Los registros tienen que setearse a un estado de reset por hardware.

#### Cell standard

+ son celdas de tamaño estandard
+ facibilita el ruteo
  
Se hace el diseño de macro cells listas
+ Hard macros 
+ Soft macros (sumadores, cosas simples)

#### Gate level netlist
es un archivo que modela las conexiones y en base a esto se produce el esquematico


#### low power design techiniques

clock gating : le deja de dar clock a las partes del circuito que no se usa
Multi voltage: diferentes partes del circuito usan distintos voltages en base a lo que se esta usando
power gating: apaga las partes de los circuitos que no se usan

#### floorplanning

hay que crear el grid, caracteristicas de las filas, tamaños de las celdas
El objetivo es minimizar el largo del routing y el area total

Todos los calculos se hacen en proporción a los tiles, que es una unidad minima que puede crear la maquina que fabrica los chips

---




----
### 2do bloque: Verilog

#### Verilog vs VHDL

VHDL es un lenguaje que no da lugar a otra interpretacion posible. Es muy solido. Por eso muchos vendors que venden IC usan VHDL

Por el otro lado, el estandar de Verilog deja abierta alugnas variables al simulador, por lo tanto puede ser un poco mas ambiguo.

System Verilog es para verificar los circuitos.

#### Lenguajes de especificaciones

SVA, SPL. Es para depurar los diseños, para verificar que funcionen bien.

#### Behavioral vs Structural
En behavioral describis el comportamiento del circuito. Por lo que la herramienta sabe lo que estas haciendo en terminos boleanos y aritmeticos.
En structural describis el circuito logico. El tema es que el simulador no va a entender que queres hacer una suma. Simplemente hace la logica.

#### Design mantras
+ One clock, one edge, Flip-Flops only : El analisis de las herramientas es de un flanco.
+ Design BEFORE coding
+ Behavior implies function
+ Clearly separate control and datapath

#### Variables

+reg: store values from procedural statements
+Wire: connects elements continuosly
+Logic : any of the above (adapts to the context)
+Integer : signed 32 bits value for simulator or conditioning purposes
+Time : machine word to track current simulation time (sin signo)
+Arrays : logic [<word>] variable [<pack/index>]

#### Basic

No es recomendable en un always evaluar una variable que está en otro always 

Cada vez que una variable de la lista de sensibilidad cambia, el always se ejecuta.

always_comb no es lo mismo que always @(*).
El always @(*) se ejecuta cuando cualquier variable cambia, pero si una variable es de entrada y salida al mismo tiempo (osea bidireccional) podria generar un latch.
El always_comb es mas parecido al assign pero tiene mas versatibilidad para hacer por ejemplo, un case. 

| bit wise or
|| or por reduccion n_bits | n_bits = 1_bit


#### codigos de bash

vlogan -sverilog -debug_access+all 5_memory.v
vcs -sverilog -debug_access+all -kdb +lint=all 5_tb_memory.v 5_memory.v 

#### synopsys verdi (wavelengths)

+ En la pestaña instance seleccionas el modulo de mayor jerarquia
+ En la esquina superior izquierda seleccionas "Signal List"
+ Seleccionas todas las signals que quieras ver y seleccionas Add to waveform> Add to new or Add to wave3
+ Bajo de la barra de herramientas escribis un tiempo de simulacion y apretas la flecha verde.
+ En la pestaña de wave seleccionas el 100% y hace un zoom de ventana


### Maquinas de estado

Critical path is defined as the chain of gates in the longest (slowed) path throught the logic


---

### Design Compiler(DC) - Herramienta para sintesis lógica

Se hace la sintesis lógica pensando en la sintesis física.

TCL (Tool Command Language) www.tcl.tk/man

Sintesis: la transformación de una idea en dispositivo implementable en lógica y luego la implementación física.

register transfer architectural HDL (verilog) -> sinthesis -> gate level netlist (RTL que optimiza synopsys)-> phisical design -> phisical device


Para que el programa haga el diseño óptimo, tengo que darle los constraints(SDCs) (generalmente de timing, temp, potencia) 
Pero el diseño fue mapeado a las librerias (compuertas and2324(ponele))

#### Synthesis = Translation + Logic Optimization + Gate Mapping

1) Translation : del RTL source al Generic boolean Gates Unmapped
2) Logic Optimization: Constraints y librerias (Por lo general, el constraint mas importante es cumplir el timing)
3) Gate netlist: optimize+map =Technology specific gates (mapped netlist)

#### Technology-specific Logic Libraries

+ Standard cell libraries
  + Optimized Gates 
+ Hard Macros or IP libraries
  + Instantiated in RTL ( not optimized)

##### Types of libraries
+ Target library: Principal -> Used to select Technology Specific Gates
  + unmapped netlist + constraint = mapped netlist
  
+ Link Library : Used to link the design
  + Cuando se especifica la compuerta en el diseño, directamente linkea la libreria. Eso queda fijo, el programa no la cambia a pesar de que podria no cumplir el constraint. Por lo general se usa en pocos casos.

Analyze+design can be used :
To modify parameter values + Without and explicit current design + Instead of read_verilog

Puertos vs pines
Ports are the inputs and outputs of the current design
Pins are the inputs and outputs of any cell that is instantiated inside the current design

#### Tipos de timing path
Path 1 : input path
Path 2 : reg to reg
Path 3 : output path
Path 4 : in out

DC optimizes each path group in turn, starting with the critical path in each group

El constraint basico que tenemos que dar es el clock:
+   Despues hay que modelar el block con los transition time, los delay time y la incertidumbre.

Al principio se hace el analisis de timing con un clock ideal. Porque se esta haciendo la sintesis logica

#### Compile
1) Hace optimizaciones logicas
   1) arquitectural level
   2) logic level
   3) gate level

---

### Sintesis fisica - IC Compiler II

Backend, refers to all steps that convert a circuit representation (gates and transistors) into a geometric representation.
La sintesis fisica toma la netlist en formato ascii, los constraints(timing, die, power) y las librerias (que son modelos asociados a los componentes del netlist).

#### Standard cell
+ Standard cells predisign layout of one specific basic logic gate
+ Tienen una altura estandar desde Vdd a Gnd. Otras celdas pueden tener una altura multiple a la estandar
+ El foundry tienen sus propios estandar cells

El grid esta formado por filas de altura estandard. 

#### Timing Driven Placement
+ Standard cells are placed in placement rows
+ Cells in a timing-critical path are place close together to reduce routing-related delays

El WNS(worst negative slack) es el que define el critical path y el que limita al circuito.

+ Tclk +- Tskew - tsu > Tcq + Tnext  // Esto lo limita el clock, por lo que se puede disminuir la velocidad del clock para que cumpla
+ Tcq + Tnext > Th +- Tskew // Esto no lo limita el clock, por lo tanto, para arreglarlo se deberia aumentar Tnext poniendo un buffer en el path por ejemplo

DRC (Design Rule Checks)

#### Floorplanning 
You Have to define Macro and Pad cell locations during the Floorplanning stage, before Placement and Routing
Layout is built with three types of reference cells:
- Macro Cells (ROMs, RAMs, IP Blocks)
- Standard cells (nand2, inv, ...)
- Pad cells (Inputs, Output, Vdd, GND)

#### Abutted Rows
Se pueden poner celdas costado con costado para unir las pistas de Vdd. Al tener doble de area, tenes la mitad de la resistencia.

Non Critical nets are routed around critical nets

#### Preferred Routing Directions
Metal Layers have preferred Routing directions.
Metal 1: Horizontal
Metal 2 : Vertical
Metal 3 : Horizontal
etc etc

#### VIas connecting metal to metal
El material de las vias es distinto a los metales y tiene su propio set de reglas

High Fanout Net Synthesis. Se dividen las cargas con mucho fanout.

#### Clock Distribution
We wish the clock to arrive to every point at the same time
We can use Tree or H-Tree distribution. Of course, there is a clock skew associated but it will be equally distributed. 

Al conectar salidas de buffers juntas para distrubuir una carga, se puede generar un cortocircuito en los cambios de flanco y se pierde potencia. 

#### DFM: Design for manufactory

+ Antenna Fixing : Evitar pistas largas para que la acumulacion de cargas rompa los dielectricos de los MOS (oxido)
+ Metal filling  : Se rellena con metal todas las zonas, incluso donde no se hizo routing. Esto es por el proceso de pulido que se hace, ya que los materiales tienen distintos coeficientes de erosion.


#### Scan chain
Dan coverage al testeo del funcionamiento del chip. Puede ser posible que el diseño en si ocupe un 50% del area y el resto sean buffers de clock y scan checks para el testeo.

#### The five stages of place_opt
1) Coarse placement : Performs buffering aware timing-driven placement and scan chain optimization (initial_place)
2) HFN buffering : Removes buffer trees, perform high fanout synthesis and logic DRC fixing (initial_drc)
3) Initial optimization : Performs quick timing optimization (initial_opto)
4) Final placement : Performs incremental and final timing-driven and global-route based congestion-driven placemente, as well as scan optimization (final_place)
5) Final optimization : Performs final full-scale optimization and legalizes the design (final_opto)