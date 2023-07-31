;
; Programa para Monty. 
; Fecha: 23/11/2002
; Por: Alejandro Alonso-Puig
; mundobot.com
;
; Función:
;	- inicio por palmada
;	- seguimiento de luz mediante sensores optoelectronicos (ojos)
;	- demostracion de alegria mediante movimiento de pinza cuando se dirige a la luz
;	- control obstaculos con bumpers.


	list 		p=16f84
	include		"P16F84a.INC"


	Contador	EQU	0x0C	;Contador multiuso
	CodReturn	EQU	0x0D	;Codigo retorno rutina "RetardoChk" y "RetChkLuz"... 
					;...Indica si hubo colision o luz. Valores a continuacion:
	CBumpDcho	EQU	0x01	;Choque Bumper derecho durante rutina "RetardoChk"
	CBumpIzdo	EQU	0xFF	;Choque Bumper izquierdo durante rutina "RetardoChk"
	CLuz		EQU	0x01	;Luz detectada durante rutina "RetChkLuz"


	; Definiciones bits del registro RA

	MotorIzdo0	EQU	0	;RA0
	MotorIzdo1	EQU	1	;RA1
	MotorDcho0	EQU	2	;RA2
	MotorDcho1	EQU	3	;RA3
	OjoDcho		EQU	4	;RA4

	; Definiciones bits del registro RB

	SueloDcho	EQU	0	;RB0	Sensor infrarojo dcho por reflexion (suelo)
	SueloIzdo	EQU	1	;RB1	Sensor infrarojo izdo por reflexion (suelo)
	BumperDcho	EQU	2	;RB2	
	BumperIzdo	EQU	3	;RB3
	OjoIzdo		EQU	4	;RB4
	Ultrasonido	EQU	5	;RB5
	Micro		EQU	6	;RB6
	PinzaAltavoz	EQU	7	;RB7

	org	0
	goto	INICIO
	org	5


;---------------------------------------------------------------------------
INICIO		;Inicio del cuerpo del programa

	bsf	STATUS,RP0		;Apunta a banco 1
	movlw	b'00010000'		;Establece puerta A como SALIDA...
	movwf	TRISA			;...excepto RA4 (SensorOpt dcho)
	movlw	b'01111111'		;Establece puerta B como ENTRADA...
	movwf	TRISB			;...excepto RB7 (Pinza/Altvoz)
	movlw	b'00000111'		;Configuracion OPTION para TMR0
	movwf	OPTION_REG
	bcf	STATUS,RP0		;Apunta a banco 0

	; Establecemos valores iniciales de las puertas

	bcf	PORTB,PinzaAltavoz	; Altavoz en silencio y pinza quieta
	clrf	INTCON			; Anula interrupciones


Quieto	CALL	Parar

	;Periodo de estabilizacion
	Movlw	d'50'			;Tiempo de retardo...
	movwf	Contador		;...se carga en "contador"
	CALL 	Retardo

	;Control de activacion de Sonido (palmada)
ChkMic	btfss	PORTB,Micro		; Chequea micro
	GOTO	ChkMic			; Si no esta activo vuelve a chequear Micro
	CALL	Alegria			; Si se ha producido un sonido muestra alegría
	CALL	HaciaAlante		; Si se ha producido un sonido Monty empieza a andar



BUCLE	;Bucle principal del programa


ChkOjos	;Control de sensores optoelectronicos (ojos)

	btfsc	PORTA,OjoDcho		; Chequea ojo dcho
	GOTO	VerSi2			; Si esta activo se chequea el izdo
	btfsc	PORTB,OjoIzdo		; Si no, se chequea ojo izdo
	GOTO	Vuelta			; Si no, ninguno lo esta. Vuelta de reconocimiento
	CALL	GiraIzda		; Si activo, giramos hacia la luz..
	GOTO	Bumpers			; ..y seguimos chequeando bumpers

VerSi2	btfss	PORTB,OjoIzdo		; Chequea ojo izdo
	GOTO	DosActivos		; Si esta activo entonces ambos ojos lo estan --> Alineado
	CALL	GiraDcha		; Si no, solo el dcho lo esta (giramos hacia luz)
	GOTO	Bumpers			

DosActivos	;Los dos ojos detectan luz
	CALL	HaciaAlante
	CALL	Alegria
	GOTO	Bumpers			

Vuelta	;Vuelta de reconocimiento en busca de luz
	movlw	d'120'			;Tiempo de giro...
	movwf	Contador		;...se carga en "Contador"
	CALL	GiraDcha
	CALL	RetChkLuz
	movwf	CodReturn		;Analizamos código retorno rutina
	decfsz	CodReturn,W		;Chequea si hubo luz
	GOTO	Quieto			;No hay luz. Monty se duerme
	GOTO	ChkOjos			;Hubo luz. Saltamos a rutina de reacción.

Bumpers	;Control de activacion de Bumpers

	btfsc	PORTB,BumperDcho	; Chequea bumper dcho
	GOTO	BprDch			; Si esta activo se procede con rutina de reaccion
	btfsc	PORTB,BumperIzdo	; Si no, Chequea bumper izdo
	GOTO	BprIzd			; Si esta activo se procede con rutina de reaccion
	GOTO	BUCLE			; Si no, se regresa al bucle



BprDch	;El bumper derecho ha sido activado. Se activa maniobra en cuatro tiempos

Tiempo1D	;Retrocedemos

	Movlw	d'35'			;Tiempo de retroceso...
	movwf	Contador		;...se carga en "contador"
	CALL	HaciaAtras
	CALL	Retardo

Tiempo2D	;Giro hacia atras (dcha)

	Movlw	d'19'			;Tiempo de giro...
	movwf	Contador		;...se carga en "contador"
	CALL	GiraIzda
	CALL	Retardo

Tiempo3D	;Avanzamos

	Movlw	d'35'			;Tiempo de avance...
	movwf	Contador		;...se carga en "contador"
	CALL	HaciaAlante
	CALL	RetardoChk
	movwf	CodReturn		;Analizamos codigo retorno rutina para ver si hubo choque
	decfsz	CodReturn,W		;Chequea si hubo golpe bumper Dcho
	GOTO	VerIzdD			;No hubo golpe dcho. Vemos si hubo golpe Izdo
	GOTO	BprDch			;Hubo golpe dcho. Saltamos a la rutina de reaccion	
VerIzdD	incfsz	CodReturn,W		;Chequea si hubo golpe bumper izdo
	GOTO	Tiempo4D		;No hubo golpe Izdo. Continuamos Tiempo4
	GOTO	BprIzd			;Hubo golpe. Saltamos a la rutina de reaccion	


Tiempo4D	;Giro hacia adelante (dcha)

	Movlw	d'19'			;Tiempo de giro...
	movwf	Contador		;...se carga en "contador"
	CALL	GiraDcha
	CALL	RetardoChk
	movwf	CodReturn		;Analizamos codigo retorno rutina para ver si hubo choque
	decfsz	CodReturn,W		;Chequea si hubo golpe bumper Dcho
	GOTO	SeeIzdD			;No hubo golpe dcho. Vemos si hubo golpe Izdo
	GOTO	BprDch			;Hubo golpe dcho. Saltamos a la rutina de reaccion	
SeeIzdD	incfsz	CodReturn,W		;Chequea si hubo golpe bumper izdo
	GOTO	BUCLE			;No hubo golpe. Monty ya colocado. Regreso a Bucle
	GOTO	BprIzd			;Hubo golpe. Saltamos a la rutina de reaccion	


BprIzd	;El bumper izquierdo ha sido activado. Se activa maniobra en cuatro tiempos

Tiempo1I	;Retrocedemos

	Movlw	d'35'			;Tiempo de retroceso...
	movwf	Contador		;...se carga en "contador"
	CALL	HaciaAtras
	CALL	Retardo

Tiempo2I	;Giro hacia atras (dcha)

	Movlw	d'19'			;Tiempo de giro...
	movwf	Contador		;...se carga en "contador"
	CALL	GiraDcha
	CALL	Retardo

Tiempo3I	;Avanzamos

	Movlw	d'35'			;Tiempo de avance...
	movwf	Contador		;...se carga en "contador"
	CALL	HaciaAlante
	CALL	RetardoChk
	movwf	CodReturn		;Analizamos codigo retorno rutina para ver si hubo choque
	decfsz	CodReturn,W		;Chequea si hubo golpe bumper Dcho
	GOTO	VerIzdI			;No hubo golpe dcho. Vemos si hubo golpe Izdo
	GOTO	BprDch			;Hubo golpe dcho. Saltamos a la rutina de reaccion	
VerIzdI	incfsz	CodReturn,W		;Chequea si hubo golpe bumper izdo
	GOTO	Tiempo4I		;No hubo golpe Izdo. Continuamos Tiempo4
	GOTO	BprIzd			;Hubo golpe. Saltamos a la rutina de reaccion	


Tiempo4I	;Giro hacia adelante (dcha)

	Movlw	d'19'			;Tiempo de giro...
	movwf	Contador		;...se carga en "contador"
	CALL	GiraIzda
	CALL	RetardoChk
	movwf	CodReturn		;Analizamos codigo retorno rutina para ver si hubo choque
	decfsz	CodReturn,W		;Chequea si hubo golpe bumper Dcho
	GOTO	SeeIzdI			;No hubo golpe dcho. Vemos si hubo golpe Izdo
	GOTO	BprDch			;Hubo golpe dcho. Saltamos a la rutina de reaccion	
SeeIzdI	incfsz	CodReturn,W		;Chequea si hubo golpe bumper izdo
	GOTO	BUCLE			;No hubo golpe. Monty ya colocado. Regreso a Bucle
	GOTO	BprIzd			;Hubo golpe. Saltamos a la rutina de reaccion	


	
;---------------------------------------------------------------------------
; Subrutinas


HaciaAlante
	bsf	PORTA,MotorDcho0
	bcf	PORTA,MotorDcho1
	bcf	PORTA,MotorIzdo0
	bsf	PORTA,MotorIzdo1
	RETURN

HaciaAtras
	bcf	PORTA,MotorDcho0
	bsf	PORTA,MotorDcho1
	bsf	PORTA,MotorIzdo0
	bcf	PORTA,MotorIzdo1
	RETURN

GiraDcha
	bcf	PORTA,MotorDcho0
	bsf	PORTA,MotorDcho1
	bcf	PORTA,MotorIzdo0
	bsf	PORTA,MotorIzdo1
	RETURN

GiraIzda
	bsf	PORTA,MotorDcho0
	bcf	PORTA,MotorDcho1
	bsf	PORTA,MotorIzdo0
	bcf	PORTA,MotorIzdo1
	RETURN


Parar		;Para los motores
	bcf	PORTA,MotorDcho0
	bcf	PORTA,MotorDcho1
	bcf	PORTA,MotorIzdo0
	bcf	PORTA,MotorIzdo1
	RETURN
	
Retardo		;Provoca un retardo segun el valor de "Contador"
Bucle1	movlw	00			;Inicializacion bucle interno
	movwf	TMR0
Bucle2	btfss	INTCON,T0IF		;¿Terminado bucle interno?
	goto	Bucle2			;No, continuar bucle interno
	bcf	INTCON,T0IF		;Si, bajar bandera
	decfsz	Contador,F		;Decrementar contador bucle externo
	goto	Bucle1			;y repetir bucle externo hasta fin
	RETURN


RetardoChk	;Provoca un retardo segun el valor de "Contador" con chequeo bumpers
BucleA	movlw	00			;Inicializacion bucle interno
	movwf	TMR0
BucleB	btfsc	INTCON,T0IF		;¿Terminado bucle interno?
	GOTO	Sigue			;Si, continua
	btfsc	PORTB,BumperDcho	;No. Chequeamos bumpers y seguimos con bucle si no hay choque
	retlw	CBumpDcho		;Activado. Salimos de subrutina con codigo de razon
	btfsc	PORTB,BumperIzdo	;No. Chequeamos bumper izdo
	retlw	CBumpIzdo		;Activado. Salimos de subrutina con codigo de razon
	goto	BucleB			;Ningun bumper activo, continuar bucle interno
Sigue	bcf	INTCON,T0IF		;Condicion Si, bajar bandera
	decfsz	Contador,F		;Decrementar contador bucle externo
	goto	BucleA			;y repetir bucle externo hasta fin
	retlw	0			;Regresa sin colision

RetChkLuz	;Provoca un retardo segun el valor de "Contador" con chequeo luz
BuclA	movlw	00			;Inicializacion bucle interno
	movwf	TMR0
BuclB	btfsc	INTCON,T0IF		;¿Terminado bucle interno?
	GOTO	Sigu			;Si, continua
	btfsc	PORTA,OjoDcho		;No. Chequeamos Ojos y seguimos con bucle 
	retlw	CLuz			;Activado. Salimos de subrutina con codigo de razon
	btfsc	PORTB,OjoIzdo		;No. Chequeamos Ojo izdo
	retlw	CLuz			;Activado. Salimos de subrutina con codigo de razon
	goto	BuclB			;Ningun Ojo activo, continuar bucle interno
Sigu	bcf	INTCON,T0IF		;Condicion Si, bajar bandera
	decfsz	Contador,F		;Decrementar contador bucle externo
	goto	BuclA			;y repetir bucle externo hasta fin
	retlw	0			;Regresa sin detección de luz


Alegria		;Muestra alegria con un pitido y movimiento de pinza
	bsf	PORTB,PinzaAltavoz
	Movlw	d'10'			;Tiempo de retardo...
	movwf	Contador		;...se carga en "contador"
	CALL 	Retardo
	bcf	PORTB,PinzaAltavoz
	Movlw	d'10'			;Tiempo de retardo...
	movwf	Contador		;...se carga en "contador"
	CALL 	Retardo
	RETURN

Fin
	END
